class RiskLevel < ActiveRecord::Base
    has_many :plans
    has_many :users, through: :plans

    def local_plans
        client = Yelp::Client.new({ consumer_key: YOUR_CONSUMER_KEY,
                                consumer_secret: YOUR_CONSUMER_SECRET,
                                token: YOUR_TOKEN,
                                token_secret: YOUR_TOKEN_SECRET
                            })
    end
end