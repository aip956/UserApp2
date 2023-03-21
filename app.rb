require 'sinatra'
require 'sqlite3'
require 'bcrypt'
require_relative 'my_user_model'


enable :sessions

user_model = User.new

# GET on /users. This action will 
# return all users (without their passwords).
get '/users' do
    @users = user_model.all_users
    # @users = User.all
    erb :index, locals: { users: @users } 
    # users.to_json(:except => :password)
end



# Before filter to check if the user is signed in
before '/users/*' do
    redirect '/sign_in' unless session[:user_id] || request.path_info == '/sign_in'
end


=begin
POST on /users. Receiving firstname, 
lastname, age, password and email. 
It will create a user and store in your 
database and returns the user created 
(without password).
=end
post '/sign_in' do
    request.body.rewind
    data = JSON.parse(request.body.read)
    # email = params[:email]
    # password = params[:password]
    email = data["email"]
    password = data["password"]
    puts "Email: #{email}"
    puts "Password: #{password}"
    user = user_model.authenticate(email, password)
    puts "User_app.rb: #{user.inspect}"
    if user
        session[:user_id] = user['id']
        user.to_json(:except => :password)
    else
        status 401
    end
end

get '/sign_in' do
    erb :sign_in
end

# put '/users' do
#     puts "Received PUT request to /users endpoint"
#     puts "Request body: #{request.body.read}"
#     user_id = session[:user_id]
#     new_password = params[:new_password]
#     user = user_model.update_password(user_id, new_password)
#     puts "New password: #{:new_password}"
#     puts "done"
#     user.to_json(:except => :password)
# end
put '/users/:id' do
    id = params[:id]
    data = JSON.parse(request.body.read)
    new_password = data["password"]
    user_model.update_password(id, new_password).to_json(:except => :password)
  end

post '/users' do
    firstname = params["firstname"]
    lastname = params["lastname"]
    age = params["age"]
    password = params["password"]
    email = params["email"]
    user_model.add_user(firstname, lastname, age, password, email)
    redirect '/users'
end

get '/users/:id' do
    id = params[:id]
    user = user_model.find_user(id)
    user.to_json
end

# delete '/users/:id' do
#     id = params[:id]
#     user_model.delete_user(id)
#     redirect '/users'
# end

delete '/users/:id' do
    id = params[:id]
    user_id = session[:user_id]
    if id.to_i == user_id.to_i
        session[:user_id] = nil
    end
    user_model.delete_user(id)
    status 204
end

    

=begin
POST on /sign_in. Receiving email and password. 
It will add a session containing the user_id in
order to be logged in and returns the user created
(without password).

# Get /sign_in
get '/sign_in' do
    erb :sign_in
end

=end

# POST /sign_in
=begin
post '/sign_in' do
    email = params[:email]
    password = params[:password]

    # Validate email:password 
    user = User.authenticate(email, password)

    if user
        session[:user_id] = user.id
        redirect '/dashboard'
    else
        @error_message = "Invalid email or password"
        erb :sign_in
    end
end
=end



get '/*' do
    "404 Not Found"
end