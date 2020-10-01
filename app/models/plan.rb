
class Plan < ActiveRecord::Base
    belongs_to :user
    belongs_to :risk_level
    has_many :reviews
    @@all = []
    
    def average_rating
        return 'N/A' if reviews.none?
        self.reviews.average(:rating)
    end

    def other_user_reviews
        #TODO
        #self.reviews 
    end
    
end