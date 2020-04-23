require 'nokogiri'
require 'httparty'
require 'byebug'

class Scraper
  def scrape
    url = 'https://www.mediamarkt.es/es/category/_smartphones-701189.html'
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    smartphones = []
    smartphone_listings = parsed_page.css('div.product-wrapper')
    page = 1

    per_page = smartphone_listings.count
    total = parsed_page.css('hgroup.cf').css('h1').css('em').text.split('')[1..3].join('').to_i
    last_page = (total / per_page.to_f).round

    while page <= last_page
      pagination_url = "https://www.mediamarkt.es/es/category/_smartphones-701189.html?searchParams=&sort=&view=PRODUCTLIST&page=#{page}"

      puts pagination_url
      puts "page: #{page}"
      puts ''

      pagination_smartphone_listings = parsed_page.css('div.product-wrapper')

      pagination_smartphone_listings.each do |smartphone_listing|
        smartphone = {
          name: smartphone_listing.css('div.content').css('h2').css('a').text.strip,
          price: '€' + smartphone_listing.css('div.price').text,
          url: 'https://www.mediamarkt.es' + smartphone_listing.css('div.content').css('a')[0].attributes['href'].value
        }
        smartphones << smartphone
        puts "Added #{smartphone[:name]}"
        puts ''
      end
      page += 1
    end
  end
end

start = Scraper.new
start.scrape
