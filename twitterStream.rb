require 'twitter'
require 'ruby-tf-idf'

class ParseTwitterStreaming
  def initialize
    @client = Twitter::Streaming::Client.new do |config|
      config.consumer_key 		="mYE3Qx63kaXws1OqQF46EVJcT"

      config.consumer_secret 	="LNzS2TFENer9UVkdxb54dgzH8zIL1TRzyzUngZizBwOjsBE8wb"

      config.access_token		="175337983-mPwjZ0gs8nS2lAjksHmDPCTABUbE0X35R61aqXCd"

      config.access_token_secret	= "tWWt6SYenqkIoTVPs0NfGjUbG1blWaXHKZm3jfYqvkFnv"
    end

    @main_text = ""
    @count = 0	
    @result_words = []	
    @stop_words = ["a" , "about", "above",  "after",  "again",  "against",  "all", "am", "an", "and", "any", "are",  "aren't", "as", "at", "be", "because", "been", "before", "being", "below", "between", "both", "but", "by", "can't", "cannot", "could", "couldn't", "did", "didn't",  "do",  "does", "doesn't", "doing", "don't", "down", "during", "each", "few", "for", "from", "further",   "had", "hadn't", "has", "hasn't", "have", "haven't", "having", "he", "he'd", "he'll",  "he's",  "her",  "here", "here's", "hers", "herself", "him", "himself", "his", "how", "how's", "i",  "i'd", "i'll", "i'm", "i've", "if", "in", "into", "is", "isn't", "it", "it's", "its", "itself", "let's", "me",  "more",  "most", "mustn't",  "my", "myself", "no", "nor", "not", "of", "off", "on", "once", "only", "or", "other", "ought", "our", "ours", "ourselves", "out",  "own", "same", "shan't", "she", "she'd" ,"she'll", "she's", "should", "shouldn't", "so", "some", "such", "than", "that", "that's", "the", "their", "theirs", "them",  "themselves", "then", "there", "there's", "these", "they", "they'd", "they'll", "they're", "they've", "this", "those", "through", "to", "too", "under", "until", "up", "very", "was", "wasn't", "we", "we'd", "we'll", "we're",  "we've", "were", "weren't", "what", "what's", "when", "when's", "where", "where's", "which", "while", "who", "who's", "whom", "why",  "why's", "with", "won't", "would", "wouldn't", "you",  "you'd", "you'll", "you're", "you've", "your", "yours", "yourself",  "yourselves"]   
  end  

  def GetDataFor5mins
	  i = 0
	  begin
		  @client.sample do |object|   
		    if object.is_a?(Twitter::Tweet) && object.lang == "en"
		  	  puts object.text
			    totalWordCount object.text
			    @main_text = @main_text + filterStopWords(object.text)
		    end
			  i = i + 1
			  break if i > 60*60*5
		end
    rescue Exception => e
      puts e
	    puts "Word Count: "
      puts @count      
	  end	
  end

  def GetTop10Words
    t = RubyTfIdf::TfIdf.new(@main_text.split(' '), 0, false)
	
    sort = t.tf_idf.sort_by{ |value| value.values[0] }.reverse
	  sort.uniq!{|value| value}
	  puts sort
	  i = 0
    sort.each do |s|		
		  key, value = s.first
      @result_words << key
		  i = i + 1	
		  break if i == 10	
    end

	  @result_words
  end
	
  def filterStopWords text
    words = text.split(" ")
	  temp = ""
    words.each do |w|	 
      temp = temp + w + " " unless @stop_words.include? w.downcase.to_s.strip   
    end

	  temp
  end

  def totalWordCount text
    @count = @count + text.split(" ").count
  end

  def GetCountWord
 	  @count
  end
end


g = ParseTwitterStreaming.new
g.GetDataFor5mins
puts g.GetTop10Words

puts "++++++++++++++++++++ word count +++++++++++++++++++++++"

puts g.GetCountWord



