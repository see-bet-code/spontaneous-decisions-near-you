require "json"
require "http"
require "optparse"

class YelpAPI

    @@all = []

    # Constants, do not change these
    API_KEY = ENV["YELP_API_KEY"]
    API_HOST = "https://api.yelp.com"
    SEARCH_PATH = "/v3/businesses/search"
    BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path


    DEFAULT_BUSINESS_ID = "flatiron-school-new-york"
    DEFAULT_TERM = "school"
    DEFAULT_LOCATION = "10004"
    SEARCH_LIMIT = 25
    DEFAULT_DISTANCE_LIMIT = 8046.72

    DATA_HASH = JSON.parse(File.read('./lib/categories.json'))


    # Make a request to the Fusion search endpoint. Full documentation is online at:
    # https://www.yelp.com/developers/documentation/v3/business_search
    #
    # term - search term used to find businesses
    # location - what geographic location the search should happen
    #
    # Examples
    #
    #   search("burrito", "san francisco")
    #   # => {
    #          "total": 1000000,
    #          "businesses": [
    #            "name": "El Farolito"
    #            ...
    #          ]
    #        }
    #
    #   search("sea food", "Seattle")
    #   # => {
    #          "total": 1432,
    #          "businesses": [
    #            "name": "Taylor Shellfish Farms"
    #            ...
    #          ]
    #        }
    #
    # Returns a parsed json object of the request
    def self.search(term, location=DEFAULT_LOCATION, limit=SEARCH_LIMIT)
        url = "#{API_HOST}#{SEARCH_PATH}"
        params = {
            term: term,
            location: location,
            limit: limit,
            is_closed: false
        }

        response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
        response.parse
    end

    def self.business_reviews(business_id)
        url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}/reviews"
        response = HTTP.auth("Bearer #{API_KEY}").get(url)
        response.parse["reviews"]
    end
  


    # Look up a business by a given business id. Full documentation is online at:
    # https://www.yelp.com/developers/documentation/v3/business
    # 
    # business_id - a string business id
    #
    # Examples
    # 
    #   business("yelp-san-francisco")
    #   # => {
    #          "name": "Yelp",
    #          "id": "yelp-san-francisco"
    #          ...
    #        }
    #
    # Returns a parsed json object of the request
    def self.business(business_id)
        url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}"

        response = HTTP.auth("Bearer #{API_KEY}").get(url)
        response.parse
    end

    def self.parent_categories
        
        DATA_HASH.map do |hash|
            hash['alias'] if hash['parents'].empty?
        end.uniq
    end

    def self.user_categories(age)
        exclusions = age < 21 ? ["adultentertainment", "bars"] : []
        DATA_HASH.map do |hash|
            hash['alias'] if !(exclusions.include?(hash['parents'].first) || exclusions.include?(hash['alias']))
        end.compact.uniq
    end

    def self.assign_risk_level(dist)
        case dist
        when 0..4024
            1
        when 4025..40234
            2
        else
            3
        end
    end


    def self.seed_yelp_plans(age, location)

        rand_category = self.user_categories(age).sample
        businesses = self.search(rand_category, location)['businesses']
        if businesses.size == 0
            self.seed_yelp_plans(age, location)
        else
            businesses.map do |plan|
                risk = self.assign_risk_level(plan['distance'])
                address = plan['location']['display_address'].join(" ")
                categories = plan['categories'].map { |hash| hash['alias'] }
                open('./db/seeds.rb', 'a') do |f|
                    f << "\nPlan.create(\"name\"=>\"#{plan['name']}\", \"location\"=>\"#{address}\", \"category\"=>\'#{categories}\',
                        \"user_id\"=>nil, \"risk_level_id\"=>#{risk}, \"distance\"=>#{plan['distance']}, \"desc\"=>nil)"
                end

                #self.append_to_seed(name: plan['name'], address: address, categories: categories, risk: risk, distance: plan['distance'])
            end
        end
    end

    def self.append_to_seed(name: , address: , categories:, risk:, distance: )
        open('./db/seeds.rb', 'a') do |f|
            f << "\nPlan.create(\"name\"=>\"#{name}\", \"location\"=>\"#{address}\", \"category\"=>\'#{categories}\',
                \"user_id\"=>nil, \"risk_level_id\"=>#{risk}, \"distance\"=>#{distance}, \"desc\"=>nil)"
        end
    end



    options = {}
    OptionParser.new do |opts|
        opts.banner = "Example usage: ruby sample.rb (search|lookup) [options]"

        opts.on("-tTERM", "--term=TERM", "Search term (for search)") do |term|
            options[:term] = term
    end

    opts.on("-lLOCATION", "--location=LOCATION", "Search location (for search)") do |location|
        options[:location] = location
    end

    opts.on("-bBUSINESS_ID", "--business-id=BUSINESS_ID", "Business id (for lookup)") do |id|
        options[:business_id] = id
    end

    opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
    end

    command = ARGV


    case command.first
        when "search"
            term = options.fetch(:term, DEFAULT_TERM)
            location = options.fetch(:location, DEFAULT_LOCATION)

            raise "business_id is not a valid parameter for searching" if options.key?(:business_id)

            response = search(term, location)

            puts "Found #{response["total"]} businesses. Listing #{SEARCH_LIMIT}:"
            response["businesses"].each {|biz| puts biz["name"]}
        when "lookup"
            business_id = options.fetch(:business_id, DEFAULT_BUSINESS_ID)


            raise "term is not a valid parameter for lookup" if options.key?(:term)
            raise "location is not a valid parameter for lookup" if options.key?(:lookup)

            response = business(business_id)

            puts "Found business with id #{business_id}:"
            puts JSON.pretty_generate(response)
        else
            #puts "Please specify a command: search or lookup"
        end
    end

end

YelpAPI.seed_yelp_plans(21, 10004)
