require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'active_support/inflector'
require_relative './flash'

class ControllerBase

  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = req.params.merge(route_params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "Double Render Error" if already_built_response?

    res.status = 302
    res.location = url
    @already_built_response = true

    session.store_session(res)
    flash.store_flash(res)
  end

  def render_content(content, content_type)
    raise "Double Render Error" if already_built_response?

    res['Content-Type'] = content_type
    res.write(content)
    @already_built_response = true

    session.store_session(res)
    flash.store_flash(res)
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    path = "views/#{controller_name}/#{template_name}.html.erb"

    template = ERB.new(File.read(path)).result(binding)
    render_content(template, "text/html")
  end

  def session
    @session ||= Session.new(req)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end

  def flash
    @flash ||= Flash.new(req)
  end

end
