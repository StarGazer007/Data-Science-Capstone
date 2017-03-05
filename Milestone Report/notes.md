These are the steps involved:

Turn everything lower-case.

Expand common abbreviations like n for and and y for why; 
write out emoticons that do carry a meaning, e.g. <3 for love; 
replace ANSI left and right single quotation marks, 
low-9 quotation mark with straight apostrophes; 
take out rt :, which stands for retweets.

Remove all numbers.

Remove all symbols and punctuations except for intra-word-dashes and intra-word-apostrophes.

Remove profanity words. The character string profanityWords were taken from this link. When writing the function, 
phrases people names that are related to profanity are not considered
Still need a solution for this.

Remove white spaces.

The function is called corupcleaner and can be viewed in the Appendix Item 2. 


Thoughts on Improvement and Prediction
Based on my exploratory analyses and doing Quiz 2, I realize that I still have a lot to do to improve my prediction model.

Correct the mistakes in my clean function.
ANSI quotation marks. I need to open each file in Notepad++ and save them using ANSI encoding.
Single letter abbreviations. u for you but not in the case of the U.S..
Non-profanity words that have the same spelling as profanity words. Dick
Consider tagging stopwords like when reading a test phrase. I got a better result predicting the word following make me using my trigrams library than make me the in my fourgrams library.

Repetitive sampling to improve my library? This should be a smart option but it is very time-consuming.
I was lucky to have found out about Amazon Web Services, but my Amazon EC2 instance got stuck when I used it to create my n-grams library. I need to troubleshoot in the weeks to come.
Implement stemming to reduce my n-grams library. For instance, “happiest”, “happier”, and “happy” can be stored as one word.

Convert word counts in different n-grams libraries into some kind of probability statistics for a true prediction model, like a multi-variate regression model. I will need to combine the three libraries into one library with probability values.

Tag misspelt words as well by sourcing an external library. That shall reduce the size of my n-grams library too.

Think of a way to deal with words that are not in the library.
