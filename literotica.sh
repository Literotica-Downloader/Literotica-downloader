#!/bin/sh
set -x #show commands
sed -i 's/\r//' "$1" #undo Microsoft nonsense
cd "$2"
script_directory="$(dirname "$0")"
export script_directory
xargs -a "$1" -P ${3:-1} -I {} sh -c '
	get_page () {
		until [ -f "$2" ]; do
			wkhtmltopdf --run-script "$(cat $script_directory/$3.js)" $1 "$2" ||
			sleep 2 # failed, wait and try again
		done
	}
	filename=$(echo -n {} | cut -b 30-).pdf
	set +x
	content="$(curl {})"
	title="$(echo "$content" | grep -o "<title data-rh=\"true\">.*</title>" | cut -b 23- | rev | cut -d - -f 3- | cut -b 2- | rev | recode html...ascii)"
	pages=$(echo "$content" | grep -o "page=[0-9]\">[0-9]" | wc -l) #number of webpages in story
	set -x
	[ $pages = 0 ] && (#if single webpage
		get_page {} $filename single_page
		set +x
		[ $(echo $content | grep -o comments_all) ] && (#if story has comments
			set -x
			get_page "{}/comments" "comments-$title.pdf" comment_page
			pdfunite $filename "comments-$title.pdf" "united-$title.pdf"
			pdftocairo -pdf "united-$title.pdf" "$title.pdf"
			rm "comments-$title.pdf" "united-$title.pdf" $filename
		) || (set -x; mv $filename "$title.pdf")
	) || (#if not download all pages and join
		get_page {} $filename first_page #get first page
		pdfs="$filename " #remember pages
		url={}?page=$((pages+1))
		set +x
		content="$(curl $url)"
		set -x
		filename=$(echo -n $url | cut -b 30-).pdf
		get_page $url $filename last_page #get last page
		pdfs="$pdfs $filename "
		while [ $pages -gt 1];do #download pages in between
			url={}?page=$pages
			filename=$(echo -n $url | cut -b 30-).pdf
			get_page $url $filename nonextreme_page
			pdfs="$pdfs $filename "
			pages=$((pages-1))
		done
		set +x
		[ $(echo $content | grep -o comments_all) ] && (#if story has comments
			set -x
			filename=comments-$(echo -n $url | cut -b 30-).pdf
			get_page "{}/comments" $filename comment_page
			pdfs="$pdfs $filename"
		)
		set -x
		pdfunite $pdfs "united-$title.pdf" #join all webpages into single document
		pdftocairo -pdf "united-$title.pdf" "$title.pdf" #repair xref table
		rm $pdfs "united-$title.pdf" #remove webpages from disk
	)
	exiftool -overwrite_original_in_place -Title="$title" -Author={} -Producer="literotica.sh" "$title.pdf" #add url to meta data
'
