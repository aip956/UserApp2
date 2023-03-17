require 'sinatra'
require_relative 'my_user_model'



get '/users' do
    @users = User.all
    erb :index
end

post '/users' do
    user = User.new(
        firstname: params[:firstname],
        lastname: params[:lastname],
        age: params[:age],
        password: params[:password],
        email: params[:email]
    )
    user.save
    redirect '/'
end

get '/users/new' do
    erb :new
end

get '/*' do
    "404 Not Found"
  end