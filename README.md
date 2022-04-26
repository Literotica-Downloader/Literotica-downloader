# Literotica-downloader
![](https://github.com/Literotica-downloader/Literotica-downloader/blob/main/fpgrlimg.png?raw=true)
Shell script that reads a file with URLs of single _literotica_ stories and stores them as PDFs locally.

## Dependencies
+ wkhtmltopdf
+ perl-exiftool
+ pdf-poppler-utils
+ recode
+ GNU coreutils (```cut```, ```rev```, ```grep```, ```curl```, ```xargs```, ...)

## Usage
```
/path/to/literotica.sh /path/to/url/file /path/to/download/directory [number of stories to download concurrently (default=1)]
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
+ Has an inbuilt adblocker. Removes ads and cam links, keeping just the story and related details.
+ If a story is multipaged, link to the first page only, in that case all pages will be downloaded into one file.
+ Can be used in conjunction with tor to anonymize.
+ Is POSIX compliant (tested with ```dash```).
+ Includes all comments from the story at the end of the pdf.

## Disadvantages
+ This script will not sort stories by category, it will just dump them into one folder.
+ This script does not have a help menu or a man page.
+ This script will not throttle based on CPU power or internet connection, the concurrency argument is to be provided manually.
+ This script does not store in any other format, only PDF.
+ This script has no inbuilt way to stop the comments from being attached at the end.
+ This script does not work for multi-chaptered stories.
+ This script does not preserve files with the same name. If two stories have the same title, first one is overwritten.
+ This script does not include the author's biography in the file.
+ ~~This script is not posix compliant.~~
