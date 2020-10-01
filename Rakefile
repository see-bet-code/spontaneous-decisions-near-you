ENV["PLAYLISTER_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

# Type `rake -T` on your command line to see the available rake tasks.

task :console do
    Pry.start
end

namespace :export do
    desc "Prints yelp_plans in a seeds.rb way."
    task :seeds_format => :environment do
      Plan.yelp_plans.each do |plan|
        puts "Plan.create(#{plan.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
      end
    end
  end

  task :environment do
    require_relative 'config/environment'
  end
    