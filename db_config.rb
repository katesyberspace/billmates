require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'billmates'
}

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || options)