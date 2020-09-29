class Plan < ActiveRecord::Base
    belongs_to :user
    belongs_to :risk_level
    has_many :reviews
end

#Test 2