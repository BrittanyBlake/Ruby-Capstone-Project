require 'nokogiri'
require 'httparty'
require 'byebug'


    def scraper
        url = "https://www.mediamarkt.es/es/category/_smartphones-701189.html"
        unparsed_page = HTTParty.get(url)
        parsed_page = Nokogiri::HTML(unparsed_page)
        smartphones = Array.new

        smartphone_listings = parsed_page.css('div.product-wrapper')

        smartphone_listings.each do |smartphone_listing|
            smartphone = {
                name: smartphone_listing.css('div.content').css('h2').css('a').text.strip,
                price:"€" + smartphone_listing.css('div.price').text,
                url: "https://www.mediamarkt.es" + smartphone_listing.css('div.content').css('a')[0].attributes["href"].value
            }
            smartphones << smartphone
           
        end
         byebug
        
    end

    scraper
   
