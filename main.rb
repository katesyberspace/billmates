require 'sinatra'
require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/bill'
require_relative 'models/comment'
require_relative 'models/item'
require_relative 'models/usersxbill'

require 'bcrypt'
enable :sessions

# helpers do
#   def current_user
#     User.find_by(id: session[:user_id])
#   end
#   def logged_in?
#     !!current_user
#   end
# end


get '/' do
  erb :index
end





