class UsersController < ApplicationController

#Login
  get '/login' do
    if logged_in?
      redirect "/movies"
    else
      erb :'users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:email => params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/movies"
    else
      redirect "/login"
    end
  end

#Signup
  get '/signup' do
    if logged_in?
      redirect "/movies"
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do
    if params[:email] == "" || params[:password] == ""
      redirect '/signup'
    else
      @user = User.create(email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect "/movies"
    end
  end

#Show User
  get '/users/:slug' do
    erb :'users/show'
  end

#Logout
  get '/logout' do

  end

end
