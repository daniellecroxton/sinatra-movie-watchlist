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
      redirect "/movies"
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do
    if params[:email] == "" || params[:password] == ""
      redirect '/signup'
    elsif User.find_by(:email => params[:email]) != nil
      flash[:message] = "Email already registered, please log-in."
      redirect "/login"
    else
      @user = User.create(email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect "/movies"
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
