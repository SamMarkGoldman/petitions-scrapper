require 'pry'
require 'mechanize'
require 'json'

file = File.open("results/results.json", 'r')
json = JSON.load(file) || { "counts" => [], "descriptions" => {} }
file.close


ROOT_URL = 'https://petitions.whitehouse.gov/'
agent = Mechanize.new
page = agent.get(ROOT_URL)

dump = { time: Time.new }
page.css('.node-petition').first(5).each do |petition|
  key = petition.css('h3 a').first['href']
  title = petition.css('h3').text
  number = petition.css('span.signatures-number').text
  dump[key] = { title: title, number: number }
end
json['counts'] << dump

dump.keys.each do |key|
  next if key == :time
  next if json["descriptions"][key]
  single_petition = agent.get(ROOT_URL + key)

  date = single_petition.css('.petition-attribution').text
  text = single_petition.css('.content p').text

  json['descriptions'][key] = { date: date, text: text }
end

file = File.open("results/results.json", 'w')
file.write(json.to_json)
file.close
