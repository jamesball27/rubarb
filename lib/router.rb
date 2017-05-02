require_relative 'route.rb'

class Router

  def initialize
    @routes = []
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  def run(req, res)
    route = match(req)

    if route
      route.run(req, res)
    else
      res.status = 404
      res.write("The route you were looking for could not be found")
    end
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  private

  attr_reader :routes

  def add_route(pattern, method, controller_class, action_name)
    routes << Route.new(pattern, method, controller_class, action_name)
  end

  def match(req)
    routes.find { |route| route.matches?(req) }
  end

end
