class Route

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    (req.path =~ pattern) && (http_method == req.request_method.downcase.to_sym)
  end

  def run(req, res)
    match_data = pattern.match(req.path)

    route_params = {}
    match_data.names.each do |name|
      route_params[name] = match_data[name]
    end

    controller = controller_class.new(req, res, route_params)
    controller.invoke_action(action_name)
  end

  private

  attr_reader :pattern, :http_method, :controller_class, :action_name

end
