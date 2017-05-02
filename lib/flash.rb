require 'json'

class Flash

  def initialize(req)
    cookie = req.cookies["_rails_lite_app_flash"]

    if cookie
      @flash_now_data = JSON.parse(cookie)
    else
      @flash_now_data = {}
    end

    @flash_data = {}
  end

  def [](key)
    @flash_now_data[key.to_s]
  end

  def []=(key, val)
    @flash_data[key] = val
    @flash_now_data[key] = val
  end

  def now
    @flash_now_data
  end

  def store_flash(res)
    res.set_cookie(
      "_rails_lite_app_flash", {
        path: "/",
        value: @flash_data.to_json
      })
  end
  
end
