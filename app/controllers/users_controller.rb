class UsersController < ApplicationController
  use Rack::Flash

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
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/movies"
    else
      flash[:message] = "Incorrect login details"
      redirect "/login"
    end
  end

#Signup
  get '/signup' do
    if logged_in?
      redirect '/movies'
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do
    @user = User.new(params)
    if @user.save
      session[:user_id] = @user.id
      redirect '/movies'
    else
      flash[:message] = @user.errors.full_messages.to_sentence
      redirect "/signup"
    end
  end

#Logout
  get '/logout' do
    if logged_in?
      session.clear
      redirect to '/login'
    else
      redirect to '/'
    end
  end

end
