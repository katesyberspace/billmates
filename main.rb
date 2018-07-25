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

  def random_join_pin
    ('AA000'..'ZZ999').to_a.sample
  end
end


get '/' do
  erb :index
end

get '/users/new' do 
  erb :new_user
end

post '/users/new' do
  user = User.new
  user.name = params[:name]
  user.email = params[:email]
  user.password = params[:password]
  user.save
  session[:user_id] = user.id
  redirect "users/#{user.id}"
end


get '/users/:id' do
  if logged_in?
    erb :users_detail
  else
    redirect '/'
  end
end

get '/bills/:id' do
  @bill = Bill.find(params[:id])
  erb :bills_detail
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

post '/bills/new' do
  bill = Bill.new
  bill.name = params[:name]
  bill.user_id = current_user.id
  bill.open = true
  @random_num = random_join_pin()
  while Bill.find_by(join_pin: @random_num) do
    @random_num = random_join_pin()
  end 
  bill.join_pin = @random_num
  bill.save
  join = Usersxbill.new
  join.bill_id = bill.id
  join.user_id = current_user.id
  join.save
  redirect "/users/#{current_user.id}"
end

post '/bills/join' do
  bill = Bill.find_by(join_pin: params[:join_pin])
  if Usersxbill.find_by(user_id: current_user.id, bill_id: bill.id)
  else
    join = Usersxbill.new
    join.bill_id = bill.id
    join.user_id = current_user.id
    join.save
  end    
  redirect "users/#{current_user.id}"
end


post '/items/new' do 
  # raise 'sdsfsdf'
  item = Item.new
  item.bill_id = params[:bill_id]
  item.name = params[:name]
  item.amount = params[:amount]
  item.paid_by_user_id = User.find_by(name: params[:paid_by]).id

  item.created_by_user_id = current_user.id
  item.save

  redirect "/bills/#{params[:bill_id]}"
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end






