# Rubarb

Rubarb is a lightweight MVC framework which implements a user-friendly API to simplify running a server, constructing routes, rendering HTML pages, and handling redirects.

Visit this repo for a demo site built using Rubarb to see it in action!

## How to Use

To use Rubarb, simply clone this repo into the root directory of your project. To get a server up and running, you will need to create a `server.rb` file. It is recommended that your server file be located in your project's root directory for simpler command line interaction, but it could potentially live anywhere inside your project.

### Server File

Your server file will contain the interface between Rack's native `Server` class and your app's routes. See below for more information on constructing routes.

At the top of `server.rb`, be sure to require `rack` and `config/routes.rb`. This file uses Rack's built-in functionality, so you can consult the [Rack docs](http://www.rubydoc.info/gems/rack/Rack) for more information, but your `server.rb` should look very similar to this:

```ruby
require 'rack'
require './config/routes.rb'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  ROUTER.run(req, res)
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
```

Once your server file is all set up, simply navigate to your project's root directory and run
`$ bundle exec ruby server.rb` to start your local server. In your browser navigate to `localhost:3000` (or whichever port specified in your file) to see your app in action! You will, of course, need to setup routes, controllers, and views before anything is rendered in your browser. Read on for more information.

### Routes
Your app's routes should live in `config/routes.rb`. This file should construct a new instance of `Router` and save it to a constant so your server has access to it. By passing a block to `Router#draw`, routes can be constructed using the following template:
```ruby
http_method Regexp.new('url_regexp'), ControllerName, :controller_action
```
For example:
```ruby
get Regexp.new("^/users/new$"), UsersController, :new
```
will make a `GET` request to `/users/new`, create a new instance of the `UsersController` and call its `#new` method.

### Controllers
All of your app's controllers should exist in a separate `/controllers` directory and inherit from `ControllerBase`, which provides the following methods:

* `params`: returns a hash of any params passed to the controller (e.g. through form submission)
* `redirect_to(url)`: takes in a URL as an argument and will redirect to that page with a status of 302
* `render_content(content, content_type)`: renders content in a specific HTTP response format (e.g. "text/html")
* `render(template_name)`: renders the given view template for the current controller. For example, calling `render(:index)` in a `PostsController` will render `views/posts_controller/index.html.erb` (more on views below). Currently only HTML/ERB views are supported by Rubarb's `render` method. Rubarb is also smart enough to automatically render the given template for the current action if no render method is explicitly called.

__*N.B.:*__ You may only call one of `redirect_to`, `render_content`, or `render` per action. Calling one of these methods more than once, or calling more than one of them will result in a `Double Render Error`.

### Views
All views should be organized into a `/views` directory and views for a specific controller must live in a directory within `/views` named after that controller, e.g. `views/users_controller/`, so that the controller's `render` method can accurately locate the correct file to render.

### Cookies
Cookies can be set using two options: Session and Flash, both of which are hash-like objects that provide an easy interface using `#[]` and `#[]=` getter and setter methods. Session cookies will exist until the user ends their browser session. Flash cookies will exist for the current and the next request/response cycle, while Flash.now cookies will exist for the current request/response cycle only.

## Future Directions
* Package Rubarb into a RubyGem for easy distribution
* Integrate an ORM to allow for data persistence and more extensive Model interactions
