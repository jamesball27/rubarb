require 'json'

class Flash

  def initialize(req)
    cookie = req.cookies["_rails_lite_app_flash"]
    
    @flash_now_data = cookie ? JSON.parse(cookie) : {}
    @flash_data = {}
  end

  def now
    flash_now_data
  end

  def store_flash(res)
    res.set_cookie(
      "_rails_lite_app_flash",
      { path: "/", value: flash_data.to_json }
    )
  end

  private

  attr_reader :flash_data, :flash_now_data

  def [](key)
    flash_now_data[key.to_s]
  end

  def []=(key, val)
    flash_data[key] = val
    flash_now_data[key] = val
  end

end
