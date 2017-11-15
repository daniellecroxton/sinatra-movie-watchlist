class Movie < ActiveRecord::Base
  belongs_to :user

  def slug
    slug = self.title.strip.downcase

    #blow away apostrophes
    slug.gsub! /['`]/,""

    # @ --> at, and & --> and
    slug.gsub! /\s*@\s*/, " at "
    slug.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with hyphen
     slug.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'

     #convert double hyphens to single
     slug.gsub! /-+/,"-"

     #strip off leading/trailing hyphens
     slug.gsub! /\A[-\.]+|[-\.]+\z/,""

     slug
   end

  def self.find_by_slug(slug)
    self.all.find do |movie|
      movie.slug == slug
    end
  end

  def self.filter_movies(user, selected_genre, selected_status)
    filtered_movies = []
    if user.movies.empty?
      "You have no movies saved yet. Click the 'add movie' button to add a movie to your watchlist."
    elsif (selected_genre == "All" || selected_genre.blank? || selected_genre == nil) && (selected_status == "All" || selected_status.blank? || selected_status == nil)
         user.movies.collect do |movie|
           filtered_movies << movie
         end
    elsif (selected_genre == "All" || selected_genre.blank?) && (selected_status != "All" || !selected_status.blank?)
      user.movies.each do |movie|
        binding.pry

           filtered_movies << movie if selected_status == movie.watched

        end
    elsif (selected_genre != "All" || !selected_genre.blank?) && (selected_status == "All" || selected_status.blank?)
      user.movies.each do |movie|

           filtered_movies << movie if selected_genre == movie.genre
        end
     else
         user.movies.each do |movie|
            filtered_movies << movie if selected_genre == movie.genre && selected_status == movie.watched
           end
         end
         filtered_movies
     end

end
