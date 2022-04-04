# Literotica-downloader
![](https://github.com/cab-1729/Literotica-downloader/blob/main/fpgrlimg.png?raw=true)
Bash script that reads a file with URLs of single literotica stories and stores them as PDFs locally.

## Dependencies
+ wkhtmltopdf
+ perl-exiftool
+ pdf-poppler-utils
+ bash
+ GNU coreutils (```cut```, ```rev```, ```grep```, ```curl```, ```xargs```, ...)

## Usage
```
/path/to/literotica.sh /path/to/url/file /path/to/directory/to/download [ number of stories concurrently (default=1)]
```
urlfile should be literotica links separated by newline :

```
https://www.literotica.com/s/...
https://www.literotica.com/s/...
https://www.literotica.com/s/...
...
```
## Capabilities
+ Stores stories as pdf.
+ Works for illustrated stories.
+ Removes ads and cam links, keeping just the story and related details.
+ If a story is multipaged, link to the first page only, in that case all pages will be downloaded into one file.
+ Adds comments at the end of the story (if any).
+ Can be used in conjunction with tor to anonymize.

## Disadvantages
+ This script will not sort stories by category, it will just dump them into one folder.
+ This script does not have a help menu or a man page.
+ This script will not throttle based on CPU power or internet connection, the concurrency argument is to be provided manually.
+ This script does not store in any other format, only PDF.
+ This script is not posix compliant.
