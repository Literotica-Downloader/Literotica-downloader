#!/bin/sh
set -x #show commands
sed -i 's/\r//' "$1" #undo Microsoft nonsense
cd "$2"
#imports
script_directory="$(dirname "$0")"
export single_page="$(cat $script_directory/single_page.js)"
export first_page="$(cat $script_directory/first_page.js)"
export last_page="$(cat $script_directory/last_page.js)"
export nonextreme_page="$(cat $script_directory/nonextreme_page.js)"
export first_comments="$(cat $script_directory/first_comments.js)"
export next_comments="$(cat $script_directory/next_comments.js)"
#run
xargs -a "$1" -P ${3:-1} -I {} sh -c '
	get_page () {
		until [ -f "$2" ]; do
			wkhtmltopdf --run-script "$3" $1 "$2" ||
			sleep 2 # failed, wait and try again
		done
	}
	storyname=$(echo {} | cut -b 30-)
	filename="$storyname.pdf"
	set +x
	content="$(curl {})"
	title="$(echo "$content" | grep -o "<title data-rh=\"true\">.*</title>" | cut -b 23- | rev | cut -d - -f 3- | cut -b 2- | rev | recode html...ascii)"
	pages=$(echo "$content" | grep -o "page=[0-9]*\">[0-9]*" | tail -n 1 | cut -d ">" -f 2 ) #number of webpages in story
	set -x
	#story pages
	if [ -z $pages ];then #if single webpage
		get_page {} $filename "$single_page"
		pdfs="$filename"
	else #if not download all pages and join
		get_page {} first-$storyname.pdf "$first_page" #get first page
		url={}?page=$pages
		set +x
		content="$(curl $url)"
		set -x
		filename="$storyname?page=$pages.pdf"
		get_page $url $filename "$last_page" #get last page
		pdfs="$filename " #remember pages
		pages=$((pages-1))
		while [ $pages -gt 1 ];do #download pages in between
			url={}?page=$pages
			filename="$storyname?page=$pages.pdf"
			get_page $url $filename "$nonextreme_page"
			pdfs="$filename $pdfs"
			pages=$((pages-1))
		done
		pdfs="first-$storyname.pdf $pdfs"
	fi
	#comment pages
	set +x
	case "$content" in
		*comments_all*) #if story has comments
			set -x
			filename="comments-$storyname.pdf"
			get_page "{}/comments" $filename "$first_comments"
			pdfs="$pdfs $filename"
			set +x
			pages=$(curl {}/comments | grep -o "page=[0-9]*\">[0-9]*" | tail -n 1 | cut -d ">" -f 2 ) #number of comment pages
			set -x
			if [ -n "$pages" ];then #if more than one comments page
				while [ $pages -gt 1 ];do #download all comment pages
					url={}/comments?page=$pages
					filename="comments-$storyname?page=$pages.pdf"
					get_page $url $filename "$next_comments"
					pdfs="$pdfs $filename"
					pages=$((pages-1))
				done
			fi
			;;
	esac
	set -x
	pdfunite $pdfs "united-$storyname.pdf" #join all webpages into single document
	pdftocairo -pdf "united-$storyname.pdf" "$title.pdf" #repair xref table
	rm $pdfs "united-$storyname.pdf" #remove webpages from disk
	exiftool -overwrite_original_in_place -Title="$title" -Author={} -Producer="literotica.sh" "$title.pdf" #add url to meta data
'
