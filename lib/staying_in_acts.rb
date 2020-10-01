require 'kimurai'
require 'json'

class ActivityScraper < Kimurai::Base
    @name= 'lockdown_activity_scraper'
    @start_urls = ["https://www.random-generator.org.uk/covid-19/"]
    @engine = :selenium_chrome

    @@all = []

    def scrape_page
        page = browser.current_response
        returned_acts = page.css('div.inner').css('form')[0].text.split(". ")[1..-1]
        returned_acts.each do |char_element|
            desc = char_element.include?(".") ? char_element.split(".") : char_element.split(/\d/)
            categories = ["Misc."]
            activity = "Plan.create(\"name\"=>\"Random Indoor Activities\", \"location\"=>nil, \"category\"=>\'#{categories}\',
            \"user_id\"=>nil, \"risk_level_id\"=>nil, \"distance\"=>nil, \"desc\"=>\"#{desc.first}\")\n"

            open('./db/seeds.rb', 'a') do |f|
                f << activity
            end
            # adding the object if it is unique
            @@all << activity if !@@all.include?(activity)
        end 
    end

    def parse(response, url:, data: {})

        browser.visit(url)
        self.scrape_page
    
        @@all
    end
end

ActivityScraper.parse!(:parse, url: "https://www.random-generator.org.uk/covid-19/")