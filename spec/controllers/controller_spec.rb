require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("A-List")
    end
  end

  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to movies index' do
      params = {
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include("/movies")
    end

    it 'does not let a user sign up without an email' do
      params = {
        :email => "",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :email => "skittles@aol.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the movies index after login' do
      user = User.create(:email => "starz@aol.com", :password => "kittens")
      params = {
        :email => "starz@aol.com",
        :password => "kittens"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("movies")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:email => "starz@aol.com", :password => "kittens")

      params = {
        :email => "starz@aol.com",
        :password => "kittens"
      }
      post '/login', params
      session = {}
      session[:user_id] = user.id
      get '/login'
      expect(last_response.location).to include("/movies")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:email => "starz@aol.com", :password => "kittens")

      params = {
        :email => "starz@aol.com",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load /movies if user not logged in' do
      get '/movies'
      expect(last_response.location).to include("/login")
    end

    it 'does load /movies if user is logged in' do
      user = User.create(:email => "starz@aol.com", :password => "kittens")


      visit '/login'

      fill_in(:email, :with => "starz@aol.com")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      expect(page.current_path).to eq('/movies')
    end
  end

  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the movies index if logged in' do
        user1 = User.create(:email => "starz@aol.com", :password => "kittens")
        movie1 = Movie.create(:title => "Ghostbusters", :user_id => user1.id)

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/movies"
        expect(page.body).to include(movie1.title)
      end
    end

    it 'displays a message when the user has no movies saved' do
      user1 = User.create(:email => "starz@aol.com", :password => "kittens")

      visit '/login'

      fill_in(:email, :with => "starz@aol.com")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit "/movies"
      expect(page.body).to include("You have no movies saved yet.")
    end

    context 'logged out' do
      it 'does not let a user view the movies index if not logged in' do
        get '/movies'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new movie form if logged in' do
        user = User.create(:email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/movies/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a movie if they are logged in' do
        user = User.create(:email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/movies/new'
        fill_in(:title, :with => "Scream")
        click_button 'create_movie'

        user = User.find_by(:email => "starz@aol.com")
        movie = Movie.find_by(:title => "Scream")
        expect(movie).to be_instance_of(Movie)
        expect(movie.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user add a movie to the watchlist of another user' do
        user = User.create(:email => "starz@aol.com", :password => "kittens")
        user2 = User.create(:email => "silver@aol.com", :password => "horses")

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/movies/new'

        fill_in(:title, :with => "Scream")
        click_button 'create_movie'

        user = User.find_by(:id=> user.id)
        user2 = User.find_by(:id => user2.id)
        movie = Movie.find_by(:title => "Scream")
        expect(movie).to be_instance_of(Movie)
        expect(movie.user_id).to eq(user.id)
        expect(movie.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a blank movie' do
        user = User.create(:email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/movies/new'

        fill_in(:title, :with => "")
        click_button 'create_movie'

        expect(Movie.find_by(:title => "")).to eq(nil)
        expect(page.current_path).to eq("/movies/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new movie form if not logged in' do
        get '/movies/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single movie' do

        user = User.create(:email => "starz@aol.com", :password => "kittens")
        movie = Movie.create(:title => "The Haunting", :user_id => user.id)

        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit "/movies/#{movie.slug}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete Movie")
        expect(page.body).to include(movie.title)
        expect(page.body).to include("Edit Movie")
        expect(page.body).to include("A-List")
      end
    end

    context 'logged out' do
      it 'does not let a user view a movie' do
        user = User.create(:email => "starz@aol.com", :password => "kittens")
        movie = Movie.create(:title => "The Haunting", :user_id => user.id)
        get "/movies/#{movie.slug}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view movie edit form if they are logged in' do
        user = User.create(:email => "starz@aol.com", :password => "kittens")
        movie = Movie.create(:title => "The Addams Family", :user_id => user.id)
        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/movies/#{movie.slug}/edit"
        expect(page.status_code).to eq(200)
        expect(page.body).to include(movie.title)
      end

      it 'lets a user edit their own movie if they are logged in' do
        user = User.create(:email => "starz@aol.com", :password => "kittens")
        movie = Movie.create(:title => "The Blair Witch Project", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/movies/#{movie.slug}/edit"

        fill_in(:title, :with => "Ghostbusters 2")

        click_button 'submit'
        expect(Movie.find_by(:title => "Ghostbusters 2")).to be_instance_of(Movie)
        expect(Movie.find_by(:title => "The Blair Witch Project")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a movie with blank content' do
        user = User.create(:email => "starz@aol.com", :password => "kittens")
        movie = Movie.create(:title => "Ghostbusters", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/movies/#{movie.slug}/edit"

        fill_in(:title, :with => "")

        click_button 'submit'
        expect(Movie.find_by(:title => "")).to be(nil)
        expect(page.current_path).to eq("/movies/#{movie.slug}/edit")
      end
    end

    context "logged out" do
      it 'does not load view movie edit form if not logged in' do
        movie = Movie.create(:title => "Ghostbusters", :user_id => 1)

        get  "/movies/#{movie.slug}/edit"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own movie if they are logged in' do
        user = User.create(:email => "starz@aol.com", :password => "kittens")
        movie = Movie.create(:title => "Ghostbusters", :user_id => 1)
        visit '/login'

        fill_in(:email, :with => "starz@aol.com")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/movies/#{movie.slug}"
        click_button "Delete Movie"
        expect(page.status_code).to eq(200)
        expect(Movie.find_by(:title => "Ghostbusters!")).to eq(nil)
      end
    end


    context "logged out" do
      it 'does not load let user delete a movie if not logged in' do
        movie = Movie.create(:title => "Ghostbusters", :user_id => 1)
        visit "/movies/#{movie.slug}"
        expect(page.current_path).to eq("/login")
      end
    end
  end

end
