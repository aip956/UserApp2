require 'sinatra'
require 'sqlite3'
require 'bcrypt'
require_relative 'my_user_model'


enable :sessions

user_model = User.new


get '/users' do
    users = user_model.all_users
    # @users = User.all
    # erb :index
    users.to_json(:except => :password)
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
    email = params[:email]
    password = params[:password]
    user = user_model.authenticate(email, password)
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

put '/users' do
    user_id = session[:user_id]
    new_password = params[:new_password]
    user = user_model.update_password(user_id, new_password)
    user.to_json(:except => :password)
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



delete '/users/:id' do
    id = params[:id]
    user_model.delete_user(id)
    redirect '/users'
end


    # request.body.rewind
    # user = User.new(
    #     firstname: params[:'firstname'],
    #     lastname: params[:'lastname'],
    #     age: params[:'age'],
    #     password: params[:'password'],
    #     email: params[:'email']
    # )
    # user.save
    # content_type :to_json
    # user.to_json(except: :password)
#     redirect '/users'
# end

# get '/users/new' do
#     erb :new
# end

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

=begin
# GET /dashboard
get '/dashboard' do
    # Validate user signed in
    if signed_in?
        erb :dashboard
    else
        redirect 'sign_in'
    end
end
=end

=begin
# PUT /users/:id
put '/users/:id' do |id|
    # Validate user signed in
    if signed_in?
        authenticate!
# Validate current user same as updated user
        if current_user.id == id.to_i
            email = params[:email]
            password = params[:password]

            # Update user's email
            user = User.find(id)
            user.email = email
            user.save

        # Return updated user w/o password
            { id: user.id, email: user.email }.to_json
        else
            status 403
        end
    else
        redirect '/sign_in'
    end
end
=end







get '/*' do
    "404 Not Found"
end