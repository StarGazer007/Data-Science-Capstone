
setwd("L:\\Cousera\\Capstone\\")

url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
destFile <- "\\data\\cs.zip"
output <- "L:\\Cousera\\Capstone\\data"

if (!file.exists(destFile)) {
  download.file(url, destFile)
  unzip(destfile,exdir=output) 
}


# Libraries used
libs <- c("tm", "dplyr", "SnowballC", "stringi","knitr","ggplot2","gridExtra")

lapply(libs, require, character.only = TRUE)

dirPath <- paste0(output ,"\\final\\en_US\\")
fileNames <-  c("en_US.blogs.txt","en_US.news.txt", "en_US.twitter.txt")

dataSetName <- c("blogs","news","twitter")

ds <- lapply(paste0(dirPath, fileNames ), readLines)
names(ds) <- dataSetName


# Compute statistics and summary info for each data type
WPL <- sapply(ds,function(x) summary(stri_count_words(x))[c('Min.','Mean','Max.')])

# Add meaningful Rownames
rownames(WPL) <- c('Min WPL','Mean WPL','Max WPL')

#Create Stats data frame
stats <- data.frame(
  FileName=c("en_US.blogs","en_US.news","en_US.twitter"),      
  t(rbind(
    sapply(data,stri_stats_general)[c('Lines','Chars'),],
    Words=sapply(data,stri_stats_latex)['Words',],
    WPL)
  ))

kable(stats)



# Set random seed for reproducibility and sample the data
set.seed(1218)
sampleBlogs <- data$blogs[sample(1:length(data$blogs), 0.01*length(data$blogs), replace=FALSE)]
sampleNews <- data$news[sample(1:length(data$news), 0.01*length(data$news), replace=FALSE)]
sampleTwitter <- data$twitter[sample(1:length(data$twitter), 0.01*length(data$twitter), replace=FALSE)]


# Remove unconvention/funny characters for sampled Blogs/News/Twitter
removeEmoticons <- function (x) {
  x <- iconv(x, "UTF-8", "ASCII", sub="")
}

cs_Blogs <- removeEmoticons(sampleBlogs)
cs_News <- removeEmoticons(sampleNews)
cs_Twitter <- removeEmoticons(sampleTwitter)


# Clean sample of 1% of each text file
combine.Data <- c(cs_Blogs,cs_News,cs_Twitter)


rm(data, cs_Blogs, cs_News, cs_Twitter)

build_corpus <- function (x = sampleData) {
  c <- VCorpus(VectorSource(x)) # Create corpus dataset
  c <- tm_map(c, tolower) # all characters to lowercase
  c <- tm_map(c, removePunctuation) # Remove punctuation
  c <- tm_map(c, removeNumbers) # Remove numbers
  c <- tm_map(c, stripWhitespace) # Remove whitespace
  c <- tm_map(c, removeWords, stopwords("english")) # remove english stop words
  c <- tm_map(c, stemDocument) # Stem the document
  c <- tm_map(c, PlainTextDocument) # Create plain text format
}
corpusData <- build_corpus(combine.Data)

rm(combine.Data)

#Run garbage collection to reclaim memory
gc()



library(RWeka)
getTermTable <- function(corpusData, ngrams = 1, lowfreq = 50) {
  #create term-document matrix tokenized on n-grams
  tokenizer <- function(x) { NGramTokenizer(x, Weka_control(min = ngrams, max = ngrams)) 
    
  }
  
  tdm <- TermDocumentMatrix(corpusData, control = list(tokenize = tokenizer))
  
  #find the top term grams with a minimum of occurrence in the corpus
  top_terms <- findFreqTerms(tdm,lowfreq)
  top_terms_freq <- rowSums(as.matrix(tdm[top_terms,]))
  top_terms_freq <- data.frame(word = names(top_terms_freq), frequency = top_terms_freq)
  top_terms_freq <- arrange(top_terms_freq, desc(frequency))
  
  
}

top.terms <- list(3)
for (i in 1:3) {
  top.terms[[i]] <- getTermTable(corpusData, ngrams = i, lowfreq = 10)
}



library(wordcloud)

# Set Plotting in 1 row 3 columns
par(mfrow=c(1, 3))
par(mar=c(0.5, 0.5, 0.5, 0.5))
pallets <- c("BuGn","OrRd","PuBu")

#wcLabel <- c("Unigram", "Bigrams", "Trigrams")
#wcFreq <- list(4000,4000,4000)

#wcTitle <- cbind(wcLabel,wcFreq)
#n <-names(top.terms[[1]])
#colnames(wcTitle) <- n
#wcTitle
#head(top.terms[[1]])
#top.terms[[1]] <-wcTitle[1,]
#top.terms[[1]] <-sort(top.terms[[1]]$frequency, decreasing = FALSE)
#top.terms[[2]] <- rbind(top.terms[[2]],wcTitle[2,])
#top.terms[[3]] <- rbind(top.terms[[3]],wcTitle[3,])


for (i in 1:3) {
  
  wordcloud(top.terms[[i]]$word, top.terms[[i]]$frequency,min.freq=1,  scale = c(3,0.5), max.words=200, random.order=FALSE, rot.per=0.45, fixed.asp = TRUE, use.r.layout = FALSE, colors=brewer.pal(9,pallets[i])
            
  )
  
  
  plot.Graphs <- function (x = top.terms, N=10) {
    
    g1 <- ggplot(data = head(x[[1]],N), aes(x = reorder(word, - frequency), y = frequency)) + 
      geom_bar(stat = "identity", fill = "#009E73", colour = "black") + 
      ggtitle(paste("Unigrams")) + 
      xlab("Unigrams") + ylab("Frequency") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    g2 <- ggplot(data = head(x[[2]],N), aes(x = reorder(word, -frequency), y = frequency)) + 
      geom_bar(stat = "identity", fill = "#E69F00", colour = "black") + 
      ggtitle(paste("Bigrams")) + 
      xlab("Bigrams") + ylab("Frequency") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    g3 <- ggplot(data = head(x[[3]],N), aes(x = reorder(word, -frequency), y = frequency)) + 
      geom_bar(stat = "identity", fill = "#56B4E9",colour = "black") + 
      ggtitle(paste("Trigrams")) + 
      xlab("Trigrams") + ylab("Frequency") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    # Put three plots into 1 row 3 columns
    gridExtra::grid.arrange(g1, g2, g3, ncol = 1)
  }
  library(gridExtra)
  plot.Graphs(x = top.terms, N = 30)
  
  
  
  