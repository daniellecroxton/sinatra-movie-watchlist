require 'spec_helper'

describe "Movie" do
  before do
    @movie = Movie.create(:title => "It's the Great Pumpkin, Charlie Brown")

  end
  it "can be initialized" do
    expect(@movie).to be_an_instance_of(Movie)
  end

  it "can have a title" do
    expect(@movie.title).to eq("It's the Great Pumpkin, Charlie Brown")
  end

  it "can slugify its name" do

    expect(@movie.slug).to eq("its-the-great-pumpkin-charlie-brown")
  end

  describe "Class methods" do
    it "given the slug can find an movie" do
      slug = "its-the-great-pumpkin-charlie-brown"
      expect((Movie.find_by_slug(slug)).title).to eq("It's the Great Pumpkin, Charlie Brown")
    end
  end

end
