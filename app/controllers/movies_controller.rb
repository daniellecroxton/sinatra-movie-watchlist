class MoviesController < ApplicationController

#Movies Index
  get '/movies' do
    if logged_in?
      @user = current_user
      @movies = Movie.filter_movies(current_user, params['selected_genre'], params['selected_status'])
        @selected_genre = params['selected_genre']
        @selected_status = params['selected_status']
        # @movies = current_user.movies.all(genre == @selected_genre)

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
    if params[:title] == ""
      redirect to "/movies/new"
    elsif current_user.movies.find_by(title: params[:title]) == nil
      @movie = Movie.new(params)
      @movie.user_id = current_user.id
      @movie.save
      flash[:message] = "Successfully created movie."
      redirect "/movies"
    else
      @movie = current_user.movies.find_by(title: params[:title])
      flash[:message] = "Movie already exists, click 'Edit Movie' to change your movie."
      redirect "/movies/#{@movie.slug}"
    end
  end

#Edit Movie
    get '/movies/:slug/edit' do
      if logged_in?
        @movie = Movie.find_by_slug(params[:slug])
        erb :'movies/edit_movie'
      else
        redirect '/login'
      end
    end

    patch "/movies/:slug" do
      @movie = Movie.find_by_slug(params[:slug])
      if params[:title] == ""
        flash[:message] = "Movie title cannot be blank."
        redirect to "/movies/#{@movie.slug}/edit"
      else
        @movie.update(title: params[:title], notes: params[:notes], genre: params[:genre], watched: params[:watched])
        @movie.save
        flash[:message] = "Successfully updated movie."
        redirect "/movies/#{@movie.slug}"
      end
    end

#Show Movie and Delete
    get "/movies/:slug" do
      if logged_in?
        @movie = Movie.find_by_slug(params[:slug])
        erb :'movies/show_movie'
      else
        redirect '/login'
      end
    end

    delete '/movies/:slug/delete' do
      @movie = Movie.find_by_slug(params[:slug])
      if logged_in? && @movie.user_id == current_user.id
        @movie.delete
        redirect '/movies'
      else
        redirect '/login'
      end
    end



end
