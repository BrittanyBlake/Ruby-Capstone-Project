require 'nokogiri'
require 'httparty'
require 'byebug'


    def scraper
        url = "https://www.mediamarkt.es/es/category/_smartphones-701189.html"
        unparsed_page = HTTParty.get(url)
        parsed_page = Nokogiri::HTML(unparsed_page)
        smartphones = Array.new
        smartphone_listings = parsed_page.css('div.product-wrapper')
        page = 1

        per_page = smartphone_listings.count
        total = parsed_page.css('hgroup.cf').css('h1').css('em').text.split("")[1..3].join("").to_i
        last_page = (total.to_f / per_page.to_f).round #this doesnt work for me- shows 11 not 12

        while page <= last_page
            pagination_url = "https://www.mediamarkt.es/es/category/_smartphones-701189.html?searchParams=&sort=&view=PRODUCTLIST&page=#{page}"

            puts pagination_url
            puts "page: #{page}"
            puts ''

            pagination_unparsed_page = HTTParty.get(url)
            pagination_parsed_page = Nokogiri::HTML(unparsed_page)
            pagination_smartphone_listings = parsed_page.css('div.product-wrapper')

            pagination_smartphone_listings.each do |smartphone_listing|
                 smartphone = {
                name: smartphone_listing.css('div.content').css('h2').css('a').text.strip,
                price:"€" + smartphone_listing.css('div.price').text,
                url: "https://www.mediamarkt.es" + smartphone_listing.css('div.content').css('a')[0].attributes["href"].value
                }
                smartphones << smartphone
                puts "Added #{smartphone[:name]}"
                puts ""
            end
             page += 1
        end
         byebug
    end

    scraper
   
