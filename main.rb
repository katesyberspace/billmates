require 'sinatra'
# require 'sinatra/reloader'
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

  def decimal_to_money(num)
    '%.2f' % num
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

get '/bills/edit' do
  if logged_in?
    @bill = Bill.find(params[:bill_id])
    erb :bill_edit
  else
    redirect '/'
  end
end

put '/bills/edit' do
  bill = Bill.find(params[:bill_id])
  bill.name = params[:name]
  bill.img_url = params[:img_url]
  bill.open = params[:open]
  # return bill.open.to_s
  bill.save
  redirect "/bills/#{params[:bill_id]}"
end


get '/bills/:id' do
  if logged_in?
    @bill = Bill.find(params[:id])
    erb :bills_detail
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
  join_pin = params[:join_pin].upcase
  # return join_pin
  bill = Bill.find_by(join_pin: join_pin)
  if bill
    if Usersxbill.find_by(user_id: current_user.id, bill_id: bill.id)
    else
      join = Usersxbill.new
      join.bill_id = bill.id
      join.user_id = current_user.id
      join.save
    end    
  end
  redirect "users/#{current_user.id}"
end


post '/bills/comments/new' do
  comment = Comment.new
  comment.bill_id = params[:bill_id]
  comment.user_id = current_user.id
  comment.content = params[:content]
  comment.save

  redirect "/bills/#{params[:bill_id]}"

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






