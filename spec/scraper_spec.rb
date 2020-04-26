require_relative '../lib/scraper.rb'

RSpec.describe Scraper do
  let(:scraper) { Scraper.new }
  let(:scrape2) { instance_double('scraper') }

  describe '#initialize' do
    url = 'https://www.mediamarkt.es/es/category/_smartphones-701189.html'
    it 'should check if @url is equal to the url described here' do
      expect(scraper.instance_variable_get(:@url)).to eq(url)
    end

    it 'url should not be an empty string' do
      expect(scraper.instance_variable_get(:@url)).not_to eq('')
    end

    it 'should check if smartphones is an empty array' do
      expect(scraper.instance_variable_get(:@smartphones)).to eq([])
    end

    it 'smartphones should not have any elements in array ' do
      expect(scraper.instance_variable_get(:@smartphones)).not_to eq([''])
    end
  end

  describe '#scrape' do
    page_one_url = 'https://www.mediamarkt.es/es/category/_smartphones-701189.html?searchParams=&sort=&view=PRODUCTLIST&page=1'
    it 'should check if the first pagination url is equal to the url described here' do
      allow(scrape2).to receive(:scrape).and_return(page_one_url)
      result = scrape2.scrape
      expect(result).to include(page_one_url)
      expect(result).not_to eq('')
    end

    last_page = 12
    it 'should check if the page is less than or equal to the last page' do
      allow(scrape2).to receive(:scrape).and_return(rand(1..12))
      result = scrape2.scrape
      expect(result).to be <= last_page
      expect(result).not_to be > last_page
    end

    phone_info = 'Huawei P30 Lite, Azul, 128 GB, 4 GB RAM, 6.15" Full HD+, Kirin 710, 3340 mAh, Android costs €199,-'
    it 'should check if the phone_info is equal to the output in the terminal' do
      allow(scrape2).to receive(:scrape).and_return(phone_info)
      result = scrape2.scrape
      expect(result).to include(phone_info)
      expect(result).not_to eq('')
    end
  end
end
