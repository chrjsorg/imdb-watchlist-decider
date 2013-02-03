#!/bin/env ruby
# encoding: utf-8
# Gets a movie from your imdb watchlist.
# This is just a proof of concept, not for general usage.

require 'rubygems'
require 'mechanize'
require 'highline/import'

imdb_link = 'http://imdb.com'
login_page = 'https://secure.imdb.com/register-imdb/login'
id_imdb_login_a = 'imdb-toggle'
username_field = 'login'
password_field = 'password'
watchlist_link_id = 'nbpersonalize'
link_watchlist = '/list/watchlist'

email = ask('E-Mail:')
password = ask('Password:') { |q|
	q.echo = '*'	
}
#puts "1) From Watchlist 2) Recommendations"
choice = 1 #ask('Choice:', Integer) { |q| q.in = 1..2 }


a = Mechanize.new { |agent| 
	agent.user_agent_alias = 'Mac Safari'
	agent.follow_meta_refresh = true
}

def get_Output(page)
          title = page.at("head meta[name='title']")["content"][0..-7] #cut ' - ImDb'
          rating = page.parser.xpath("//*[@id='overview-top']/div[3]/div[1]").inner_html.strip + "/10"
          runtime = page.parser.xpath("//*[@class='infobar']/time").inner_html.strip
          genres =  page.parser.xpath("//*[@class='infobar']/a")
          output(title, rating, genres, runtime)
end

def output(title, rating, genres, runtime)
	puts "Your movie for tonight:"
	puts title
	puts runtime
	puts rating
  puts "Genres:"
 	  genres.each { |genre|
		puts genre.inner_html}
end

#Load login page
a.get(login_page) do |page|
  # click the imdb toggle
  login_page = a.click(page.link_with(:id => id_imdb_login_a))
  
  #fill the form
  login_form = login_page.forms[1]
  username_field = login_form.field_with(:name => username_field)
  password_field = login_form.field_with(:name => password_field)
  username_field.value = email
  password_field.value = password
  #submit
  main_page = login_form.submit

  #login failed
  if (main_page.link_with(:id => watchlist_link_id) == nil)
	puts 'login failed :('
  	Process.exit
  end

  #Get Movie from watchlist  
  if(choice == 1) 
	  watchlist_page = a.click(main_page.link_with(:href => link_watchlist))
    #Get all links to the movies from the watchlist
	  watchlist_items = watchlist_page.parser.xpath(".//div[@class='list_item grid']/div[@class='desc']/a/@href")
	  
    if(watchlist_items.count == 0) 
		  puts "No items on watchlist"
		  Process.exit
	  end

	  rnd = rand(watchlist_items.count)
	  watchlist_item_to_get = imdb_link +  watchlist_items[rnd]
	  moviePage = a.get(watchlist_item_to_get) 
	  
    get_Output(moviePage)
  end

  #Can't figure out, why there are not divs with the class rec_item, i think they are loaded async..
  #if(choice == 2)
	# watchlist_page = a.click(main_page.link_with(:href => '/list/watchlist'))
	# recommendation_items = main_page.parser.xpath("//div[@class='rec_item'/a/@href")
	# rnd = rand(recommendation_items.count)
  # recommendation_to_get = imdb_link + recommendation_items[rnd]
	# moviePage = a.get(recommendation_to_get)
	# get_Output(moviePage)
  #end

end
