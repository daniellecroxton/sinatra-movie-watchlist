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
    if params[:title] == ""
      redirect to "/movies/new"
    else
      @movie = Movie.new(params)
      @movie.user_id == current_user.id
      @movie.save
      # binding.pry
      flash[:message] = "Successfully created movie."
      redirect "/movies/#{@movie.slug}"
    end
  end

#Edit Movie
  get '/movies/:slug/edit' do
    erb :'movies/edit_movie'
  end

  patch '/movies/:slug' do

  end

#Show Movie and Delete
  get 'movies/:slug' do
    @movie = Movie.find_by_slug(params[:slug])
    erb :'movies/show_movie'
  end

  delete 'movies/:slug/delete' do

  end

end
