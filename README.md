# Bijou

[![Coverage Status](https://coveralls.io/repos/andela-cdaniel/bijou/badge.svg?branch=master&service=github)](https://coveralls.io/github/andela-cdaniel/bijou?branch=master) [![Code Climate](https://codeclimate.com/github/andela-cdaniel/bijou/badges/gpa.svg)](https://codeclimate.com/github/andela-cdaniel/bijou)

The Rails framework has always fascinated me in the way that it works, the beauty, the elegance and the way it makes rapid application development very easy has always struck me as a work of genius. While all these make Rails a beauty to use, I've always found myself lost in all the seeming magic that Rails employs to make all the little bits work efficiently.

Bijou is my attempt to understand Rails better by building a simple Ruby + Rack powered web framework. It comes with some of rails features built in albeit not as polished.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bijou'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bijou

## Usage
When creating a new Bijou application, a few things need to be setup and a few rules adhered to. Bijou follows the same folder structure as a typical rails app with all of the model, view and controller code packed inside of an app folder, configuration based code placed inside a config folder and the main database file in a db folder. [Here](https://github.com/andela-cdaniel/my_agenda) is a link to a to-do app built using Bijou with the correct folder setup, it can be forked, cloned and edited to suit other purposes.

### Setup

In order to run a Bijou app, it is assumed that a `config.ru` file exists in the root directory and all the needed files have been required here.

Example `config.ru` file:

* Note that the 'PATH' constant is required and must point to the current file directory as the gem uses this internally to find and link folders.

```ruby
PATH = __dir__

require "bijou"

$LOAD_PATH << File.join(PATH, "..", "app", "controllers")
$LOAD_PATH << File.join(PATH, "..", "app", "models")

Dir["../app/models/*.rb"].each { |file| require file }

module MyApp
  class Application < Bijou::Application
  end
end

BijouApp = MyApp::Application.new

require File.expand_path __FILE__, "./config/routes"

run BijouApp
```

### Routes

The route file should be required in the config.ru file after the application has been initialized and before the rack 'run' command is called.

Example route file:

```ruby
BijouApp.routes.draw do
  root "pages#index"
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
  get "signup", to: "pages#signup"
  post "signup", to: "users#create"
  put "user/:id", to: "users#update"
  delete "user/:id", to: "agendas#destroy"
end
```

### Models

Bijou implements a lightweight orm that makes it easy to query the database using ruby objects. It supports only sqlite3. Models are placed inside the `app/models` folder.

Example model file:

```ruby
class App < Bijou::BijouRecord
  map_model_to_table :todos
  table_property column_name: :name, type: :text, nullable: false
  table_property column_name: :done, type: :boolean, default: false
  create_table
end
```

### Controllers

Controllers are placed inside the `app/controllers` folder.

Example controller file:

```ruby
class PagesController < Bijou::BaseController
  def index
    @todos = Todo.all
  end

  def about
  end

  def show
    @todo = Todo.find(params[:id])
  end
end
```

### Views

View templates are mapped to controller actions and must assume the same nomenclature as their respective actions.Erbuis is used as the templating engine and files which are views are required to have the .erb file extension after the .html extension. Views are placed inside the `app/views` folder. A default layout file is required and must be placed inside the `app/views/layouts` folder. It is also required that this file is named `application.html.erb` and has a `yield` command.

Example file:

```erb
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My New App</title>
</head>
<body>
  <%= yield %>
</body>
</html>
```
## Running the tests

Test files are placed inside the spec folder and have been split into two sub folders, one for unit tests and the other for integration tests. You can run the tests from your command line client by typing `rspec spec`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andela-cdaniel/bijou. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

