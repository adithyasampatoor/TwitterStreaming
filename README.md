# Description


A ruby program to collect 5 minutes of tweets using the Twitter streaming API (statuses/sample) 

Also it will Obtain a total word count, by filtering out the "stop words" (words like "and", "the", "me", etc -- useless words), and present the 10 most frequent words in those 5 minutes of tweets.


It is Implemented in a way such that if you had to stop the program and restart, it will pick up from the total word counts that you started from.


##Things to do

gem install twitter and 
gem install ruby-tf-idf