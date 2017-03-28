#loading stored data
setwd("L:/git/Data-Science-Capstone/sample")
load("sample_data.rds")

#removing profanity
badwords <- list(c("ass","whore","slut","wtf","cunt","cunts","fucking","fuck","fucked","fucking","fucks"))
data <- removeWords(data,badwords)

data <- iconv(data,from="UTF-8",to="ASCII","")
data <- gsub("'","",data)
data <- gsub("\"","",data)
data <- gsub("!",".",data)
data <- stripWhitespace(data)
data <- unlist(strsplit(data,"[.][[:space:]]"))
data <- stripWhitespace(data)
data <- unlist(strsplit(data,"[?][[:space:]]"))
data <- stripWhitespace(data)
data <- unlist(strsplit(data,"[???][[:space:]]"))
data <- stripWhitespace(data)
data <- gsub("[^[:space:][:alnum:]]","",data)

#removing numbers,punctuation,extra white spaces and changing text to lowercase
data <- removeNumbers(data)
data <- stripWhitespace(data)
data <- removePunctuation(data)
data <- stripWhitespace(data)
data <- tolower(data)
data <- stripWhitespace(data)

data <- data[-which(sapply(data,nchar)==0)]
data <- data[-which(sapply(data,nchar)==1)]

data <- data[-which(stri_count(data,regex="\\S+")==1)]
data <- data[-which(stri_count(data,regex="\\S+")==2)]

data <- gsub("^[[:space:]]","",data)
setwd("L:/git/Data-Science-Capstone/sample")
save(data,file="clean_data.rds")
