require 'sinatra'
require 'sinatra/reloader'
require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/bill'
require_relative 'models/comment'
require_relative 'models/item'
require_relative 'models/usersxbill'
require 'bcrypt'
enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end
end


get '/' do
  erb :index
end

get '/users/:id' do
  if logged_in?
    erb :users_detail
  else
    redirect '/'
  end
end


post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  else
    erb :index
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end





