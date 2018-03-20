library(XML)
library(rvest)
library(RCurl)
library(rprojroot)

url <- 'http://bobby.gramacy.com/teaching/dataworks_rsm'

# Retreive content from url
rcurl.doc <- getURL(url, 
                    .opts = curlOptions(followlocation = TRUE))
# parse url
url_parsed <- htmlParse(rcurl.doc, asText = TRUE)

links <- xpathApply(url_parsed, "//a", XML::xmlValue)

files <- paste0(url,'/', gsub(' ','',links[-1]))

root <- find_root(is_rstudio_project)

for(i in files) {
  dir <- 'short_course'
  base <- basename(i)
  download.file(i, destfile = file.path(root,dir,base))
}
