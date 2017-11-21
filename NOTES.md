Sinatra Portfolio Project

Genre List
* Adventure
* Comedy
* Action
* Drama
* Suspense
* Horror
* Romantic Comedy
* Musical
* Documentary

File Structure
- app
    - controllers
        - application_controller.rb
        - users_controller.rb
        - movies_controller.rb
    - models
        - movie.rb
        - user.rb
        - concerns
            - slugifiable.rb
    - views
        - index.erb
        - layout.erb
        - movies
            - movies.erb
            - create_movie.erb
            - edit_movie.erb
            - show_movie.erb
        - users
            - create_user.erb
            - login.erb
            - show.erb
- config
    - environment.rb
- db
    - All auto after migration? Migrate file + development.sqlite, schema.rb, test.sqlite
- spec
    - controllers
        - controller_spec.rb
    - models
        - model_spec.rb
    - spec_helper.rb
- Gemfile
- LICENSE.md
- README.md
- Rakefile
- config.ru
- .rspec?
- NOTES.md

git push origin scraped
git checkout scraped
rspec spec/controllers/controller_spec.rb


Filter feature
All
Watched
Unwatched

All
[genre list]

Form
Use query string?
Post to “/movies/:filter” where filter is selection
Get “movies/:filter”




Background #FFF
Border 20px, #AAAAAA
#000 Buttons
Text Sizes
H1 30px - Titles of pages
H2 20px - logo
P 15px - buttons and regular type
15/15 button, logout, welcome description, Create and account
15/50 list
15/25 paragraph

Margins
100px

Gutter between columns
200 px
20px between label and input and 40px between fields

Buttons 10 px apart
Height 60px
Width 300px

CSS
Global
	Border
	Font Face
Movies
	Header
	H1
	H2
	H3
	P
	Buttons
	Input
	Text Area
	Select
	Side Container
	Main Container
User
	H1
	P
	Button
	Background
	Input
	Link
	Main Container
	Wrapper


Remaining tasks
	Would like to not have submit button on movie index
	Filter by status too
	Have dropdown stay on selection upon reload

Questions
	When to use model vs model attribute? (Genre)
	Where to house static data?
	Client side vs server side validation
	Password confirmation field, would data get stored?
