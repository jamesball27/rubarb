require 'json'

class Session

  def initialize(req)
    cookie = req.cookies["_rubarb_app"]

    @session_data = cookie ? JSON.parse(cookie) : {}
  end

  def [](key)
    session_data[key]
  end

  def []=(key, val)
    session_data[key] = val
  end

  def store_session(res)
    res.set_cookie(
      "_rails_lite_app",
      { path: "/", value: session_data.to_json}
    )
  end

  private

  attr_reader :session_data

end
