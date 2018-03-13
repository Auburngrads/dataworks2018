library(XML)
library(rvest)
library(RCurl)


url <- 'http://bobby.gramacy.com/teaching/dataworks_rsm'

# Retreive content from url
rcurl.doc <- getURL(url, 
                    .opts = curlOptions(followlocation = TRUE))
# parse url
url_parsed <- htmlParse(rcurl.doc, asText = TRUE)

links <- xpathApply(url_parsed, "//a", XML::xmlValue)

files <- paste0(url,'/', gsub(' ','',links[-1]))
