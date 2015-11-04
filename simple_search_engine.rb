require 'open-uri'
require 'nokogiri'

def simple_search_engine(search, *urls)
	#how many times the word appears on a page
	#make it not case sensitive
	#related words?
	
	#parse the file
	#loop through html, counting number of times the word occurs
	#display urls in order of word occurrences
	inner_html_hash = {}
	urls_array = []
	urls.each do |url|
		file = open(url)
		#p file.read
		text = Nokogiri::HTML(file).css('div').inner_html
		urls_array << text
		inner_html_hash[text] = url
	end

	

	occurrences = {}
	urls.each do |url|
		occurrences[url] = 0
	end

	#each url should be a string of words, separated by spaces

	urls_array.each do |text|
		text.split(' ').each do |word|
			search.split(' ').each do |search_word|
				if word.downcase == search_word.downcase
					p inner_html_hash[text]
					occurrences[inner_html_hash[text]] += 1
				end
			end
		end
	end

	urls.sort! {|a,b| occurrences[a] <=> occurrences[b]}
	urls.each_with_index do |url, index|
		p "#{index + 1}. #{url}"
	end
end

simple_search_engine("espn", 'http://www.google.com', 'http://espn.go.com/', 'http://www.berkshirehathaway.com/')