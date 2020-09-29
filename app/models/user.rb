class User < ActiveRecord::Base
    has_many :plans
    has_many :risk_levels, through: :plans
    has_many :reviews
end