class Review < ActiveRecord::Base
    validates :rating, :inclusion => { :in => %w(1..10),
    :message => "%{value} is not a valid rating, must be 1-10" }

    belongs_to :plan
    belongs_to :user

end