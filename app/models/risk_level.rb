class RiskLevel < ActiveRecord::Base
    has_many :plans
    has_many :users, through: :plans

    validates_uniqueness_of :name

end