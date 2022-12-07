require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'dotenv'
Dotenv.load

require 'lastfm'

lastfm = Lastfm.new(ENV['LAST_FM_API_KEY'], ENV['LAST_FM_SHARED_SECRET'])

artists_per_page = 30
number_of_pages = 300

letters = %w{a e i o u y}
letters.each do |search_letter|
  (0..number_of_pages).to_a.each do |page_number|
    if page_number > 0
      api = lastfm.artist.search(artist: search_letter, page: page_number)
    else
      api = lastfm.artist.search(artist: search_letter)
    end
    
    artists = api["results"]["artistmatches"]["artist"]

    data_file = File.open('../data/artists.txt', 'a')
    data_file.write(artists.collect { |a| a["name"] }.join("\n") + "\n")
    data_file.close

    if artists.count < artists_per_page
      next
    else
      sleep(0.20)
    end
  end
end
