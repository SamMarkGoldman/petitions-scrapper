require 'pry'
require 'mechanize'

agent = Mechanize.new
page = agent.get('https://petitions.whitehouse.gov/')

page.css('.node-petition').first(5).each do |petition|
  # binding.pry
  title = petition.css('h3').text
  number = petition.css('span.signatures-number').text
  puts "#{number.ljust(10)} | #{title}" if title && number
end

puts 'bye'