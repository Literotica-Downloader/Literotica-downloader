#!/bin/bash
# download stories from literotica from a file of urls
# first argument is the file to read the urls from,second argument is the download directory, third argument is the number of stories downloaded concurrently (default : 1)
# WARNING: if concurrency argument is not "1" logs and output will be jumbled, if concurrency is too high for the CPU or internet connection of the system, the script will fail.
set -x #show commands
sed -i 's/\r//' "$1" #undo Microsoft nonsense
cd "$2"
script_directory="$(dirname "$0")"
export script_directory
function get_page {
	until [ -f "$2" ]; do
		wkhtmltopdf --run-script "$(<$script_directory/$3.js)" $1 "$2" ||
		sleep 2 # failed, wait and try again
	done
}
function download {
	filename=$(cut -b 30- <<<$1).pdf
	set +x
	content="$(curl $1)"
	set -x
	title="$(grep -o "<title data-rh=\"true\">.*</title>" <<<$content | cut -b 23- | rev | cut -d - -f 3- | cut -b 2- | rev | recode html...ascii)"
	pages=$(grep -o "page=[0-9]\">[0-9]" <<<$content | wc -l) #number of webpages in story
	[[ $pages == 0 ]] && (#if single webpage
		get_page $1 $filename single_page
		[[ $(grep -o comments_all <<<$content) ]] && (#if story has comments
			get_page "$1/comments" "comments-$title.pdf" comment_page
			pdfunite $filename "comments-$title.pdf" "united-$title.pdf"
			pdftocairo -pdf "united-$title.pdf" "$title.pdf"
			rm "comments-$title.pdf" "united-$title.pdf" $filename
		) || mv $filename "$title.pdf"
	) || (#if not download all pages and join
		get_page $1 $filename first_page #get first page
		pdfs="$filename " #remember pages
		for page_number in $(seq 2 $pages); do #download pages in between
			url=$1?page=$page_number
			filename=$(cut -b 30- <<<$url).pdf
			get_page $url $filename nonextreme_page
			pdfs+="$filename "
		done
		url=$1?page=$(expr $pages + 1)
		set +x
		content="$(curl $url)"
		set -x
		filename=$(cut -b 30- <<<$url).pdf
		get_page $url $filename last_page #get last page
		pdfs+="$filename "
		if [ $(grep -o comments_all <<<$content) ]; then #if story has comments
			filename=comments-$(cut -b 30- <<<$url).pdf
			get_page "$1/comments" $filename comment_page
			pdfs+=$filename
		fi
		pdfunite $pdfs "united-$title.pdf" #join all webpages into single document
		pdftocairo -pdf "united-$title.pdf" "$title.pdf" #repair xref table
		rm $pdfs "united-$title.pdf" #remove webpages from disk
	)
	exiftool -overwrite_original_in_place -Title="$title" -Author=$1 -Producer="literotica.sh" "$title.pdf" #add url to meta data
}
export -f download get_page
xargs -a "$1" -P ${3:-1} -I {} bash -c 'download {}'
