class MoviesController < ApplicationController

#Movies Index
  get '/movies' do
    if logged_in?
      @user = current_user
      erb :'movies/movies'
    else
      redirect '/login'
    end
  end

#New Movie
  get '/movies/new' do
    if logged_in?
      erb :'movies/create_movie'
    else
      redirect '/login'
    end
  end

  post '/movies' do
    binding.pry
    if params[:title] == ""
      redirect to "/movies/new"
    elsif current_user.movies.find_by(title: params[:title]) == nil
      @movie = Movie.new(params)
      @movie.user_id = current_user.id
      @movie.save
      flash[:message] = "Successfully created movie."
      redirect "/movies/#{@movie.slug}"
    else
      @movie = current_user.movies.find_by(title: params[:title])
      flash[:message] = "Movie already exists, click 'Edit Movie' to change your movie."
      redirect "/movies/#{@movie.slug}"
    end
  end

#Show Movie and Delete
    get "/movies/:slug" do
      # binding.pry
      if logged_in?
        @movie = Movie.find_by_slug(params[:slug])
        erb :'movies/show_movie'
      else
        redirect '/login'
      end
    end

    delete '/movies/:slug/delete' do
      @movie = Movie.find_by_slug(params[:slug])
      # binding.pry
      if logged_in? && @movie.user_id == current_user.id
        @movie.delete
        redirect '/movies'
      else
        redirect '/login'
      end
    end

#Edit Movie
  get '/movies/:slug/edit' do
    erb :'movies/edit_movie'
  end

  patch "/movies/:slug" do

  end
end
