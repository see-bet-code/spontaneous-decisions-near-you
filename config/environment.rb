require 'bundler/setup'
Bundler.require

require 'active_record'
require 'rake'
require_all 'app/models'
require_all 'lib'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/development.sqlite"
)

old_logger = ActiveRecord::Base.logger
# ActiveRecord::Base.logger = old_logger
ActiveRecord::Base.logger = nil

# if ENV["PLAYLISTER_ENV"] == "test"
#   ActiveRecord::Migration.verbose = false
# end




# ActiveRecord::Base.logger = Logger.new(STDOUT)
