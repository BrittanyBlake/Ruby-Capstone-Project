

require 'nokogiri'
require 'httparty'
require 'byebug'
require 'colorize'

class Scraper
  attr_reader :url, :parsed_page, :smartphones, :unparsed_page

  def initialize
    @url = 'https://www.mediamarkt.es/es/category/_smartphones-701189.html'
    @unparsed_page = HTTParty.get(url)
    @parsed_page = Nokogiri::HTML(unparsed_page)
    @smartphones = []
  end

  # rubocop:disable Metrics/AbcSize

  def scrape
    smartphone_listings = parsed_page.css('div.product-wrapper')
    page = 1

    per_page = smartphone_listings.count
    total = parsed_page.css('hgroup.cf').css('h1').css('em').text.split('')[1..3].join('').to_i
    last_page = (total / per_page.to_f).ceil
    
    puts "Total number of smartphones: #{total}".blue
    puts "Total number of pages: #{last_page}".blue
    puts "Number of Smartphones per page:#{per_page}".blue

    while page <= last_page
      pagination_url = "https://www.mediamarkt.es/es/category/_smartphones-701189.html?searchParams=&sort=&view=PRODUCTLIST&page=#{page}"

      puts pagination_url
      puts "page: #{page}"
      puts ''

      pagination_unparsed_page = HTTParty.get(pagination_url)
      pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
      pagination_smartphone_listings = pagination_parsed_page.css('div.product-wrapper')

      pagination_smartphone_listings.each do |smartphone_listing|
        smartphone = {
          description: smartphone_listing.css('div.content').css('h2').text.strip.split.drop(2).join(' ').gsub(/-/, ''),
          price: '€' + smartphone_listing.css('div.price-box').css('div.small').text,
          url: 'https://www.mediamarkt.es' + smartphone_listing.css('div.content').css('a')[0].attributes['href'].value
        }
        csv(smartphones)
        smartphones << smartphone
        phone_info(smartphone)
       
      end
      page += 1
    end
  end

  def phone_info(smartphone)
    puts ''
    puts " #{smartphone[:description]} costs #{smartphone[:price]}".red
    puts ''
  end

  def csv(smartphones)
    CSV.open("phones.csv", "w") do |csv|
      smartphones.each { |phone| csv << [phone[:description], phone[:price]] } 
    end
  end
  # rubocop:enable Metrics/AbcSize
end

