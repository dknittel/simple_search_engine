require 'open-uri'
require 'nokogiri'

def simple_search_engine(search, *urls)
	#related words?

	inner_html_hash = {}
	urls_array = []
	urls.each do |url|
		file = open(url)
		text = Nokogiri::HTML(file).css('div').inner_html
		urls_array << text
		inner_html_hash[text] = url
	end

	similar_words = []
	search.split(' ').each do |word|
		similar_word_html = Nokogiri::HTML(open("http://www.thesaurus.com/browse/#{word}")).css('div.relevancy-list span.text').children
		p similar_word_html.class
		similar_word_html.each do |node|
			similar_words << node.text
		end
	end

	# similar_word_occurrences = {}
	# urls.each do |url|
	# 	similar_word_occurrences[url] = 0
	# end

	urls_array.each do |text|
		text.split(' ').each do |word|
			similar_words.each do |similar_word|
				if word.downcase == similar_word.downcase
					similar_word_occurrences[inner_html_hash[text]] += 1
				end
			end
		end
	end

	occurrences = {}
	urls.each do |url|
		occurrences[url] = 0
	end

	urls_array.each do |text|
		text.split(' ').each do |word|
			search.split(' ').each do |search_word|
				if word.downcase == search_word.downcase
					occurrences[inner_html_hash[text]] += 1
				end
			end
		end
	end

	# priority = {}
	# urls.each do |url|
	# 	p (similar_word_occurrences[url] / 20)
	# 	p priority[url] = occurrences[url] + (similar_word_occurrences[url] / 20)
	# end

	#priority hash containing occurrences and (similar word occurences / 20) or so 

	urls.sort! {|a,b| priority[a] <=> priority[b]}
	urls.each_with_index do |url, index|
		p "#{index + 1}. #{url}"
	end
end

simple_search_engine("sport hello green", 'http://www.google.com', 'http://espn.go.com/', 'http://www.berkshirehathaway.com/')