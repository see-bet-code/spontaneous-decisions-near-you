class User < ActiveRecord::Base
    has_many :plans
    has_many :risk_levels, through: :plans
    has_many :reviews

    validates_uniqueness_of :email

    def selected_plans
        self.plans.map { |p| p.desc if p.selected? }.compact
    end
end

