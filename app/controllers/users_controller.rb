class UsersController < ApplicationController

#Login
  get '/login' do
    erb :'users/login'
  end

  post '/login' do

  end

#Signup
  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do

  end

#Show User
  get '/users/:slug' do
    erb :'users/show'
  end

#Logout
  get '/logout' do

  end

end
