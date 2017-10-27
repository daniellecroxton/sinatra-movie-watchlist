class MoviesController < ApplicationController

#Movies Index
  get '/movies' do
    @user = current_user
    erb :'movies/movies'
  end

#New Movie
  get '/movies/new' do
    erb :'movies/create_movie'
  end

  post '/movies' do

  end

#Edit Movie
  get '/movies/:id/edit' do
    erb :'movies/edit_movie'
  end

  patch '/movies/:id' do

  end

#Show Movie and Delete
  get 'movies/:id' do
    erb :'movies/show_movie'
  end

  delete 'movies/:id/delete' do

  end

end
