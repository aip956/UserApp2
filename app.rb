require 'sinatra'
require 'sinatra/flash'
require 'sinatra/authentication'
require 'bcrypt'
require_relative 'my_user_model'
enable :sessions

# GET on /users. This action will 
# return all users (without their passwords).
get '/users' do
    @users = User.all
    erb :index
end

=begin
POST on /users. Receiving firstname, 
lastname, age, password and email. 
It will create a user and store in your 
database and returns the user created 
(without password).
=end
post '/users' do
    user = User.new(
        firstname: params[:firstname],
        lastname: params[:lastname],
        age: params[:age],
        password: params[:password],
        email: params[:email]
    )
    user.save
    redirect '/users'
end

get '/users/new' do
    erb :new
end

=begin
POST on /sign_in. Receiving email and password. 
It will add a session containing the user_id in
order to be logged in and returns the user created
(without password).
=end
# Get /sign_in
get '/sign_in' do
    erb :sign_in
end

# POST /sign_in
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

# GET /dashboard
get '/dashboard' do
    # Validate user signed in
    if signed_in?
        erb :dashboard
    else
        redirect 'sign_in'
    end
end

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


# Authenticate! method
helpers do
    def authenticate!
        redirect 'sign_in' unless sign_in?
    end
end

# Helper method to check if user is signed in
def signed_in?
    !session[:user_id].nil?
end

# Helper method to get the current user
def current_user
    User.find(session[:user_id])
end




get '/*' do
    "404 Not Found"
  end