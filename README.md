# imdb-watchlist-decider - Readme

This script is just a proof of concept. It's not for general usage. Probably Imdb forbids the usage.
Use it at your own risk.

It will login into your Imdb Account and gets a random movie from your watchlist. 
oAuth login (Google, Facebook, ..) is not supported.

It's also almost ready to return a movie from your recommendations, the code is there, but is does not work.
The returned page from Mechanize doesn't hat the div[@class='rec_item'] objects, which it should have...
Feel free to fix it.

This script isn't nearly perfect, it was my first attempt with ruby, ever.

## 1. Requirements
1. Ruby
2. Rubygems
3. Rubygem: highline
4. Rubygem: mechanize

## 2. Usage

1. `ruby imdb.rb`
2. Enter e-mail adress + password
3. Wait

## 3. Todos

1. Refactor the code... 
2. Fix the recommendation thing
3. Error handling
4. oAuth support 
