# frozen_string_literal: true


# Returns a hash which has background attr
class CSSHome
    def initialize(info)
      @info = info
      @cates = @info["cates"]
    end
  
    def call()
      @cates.map! do |c|
        if c["name"] == "食"
          c = c.merge!("css_progs"=>"eat_progs","css_img"=>"eat_image")
        elsif c['name'] == '衣'
          c = c.merge!("css_progs"=>"cloth_progs","css_img"=>"cloth_image")
        elsif c['name'] == '住'
          c = c.merge!("css_progs"=>"live_progs","css_img"=>"live_image")
        elsif c['name'] == '行'
          c = c.merge!("css_progs"=>"traffic_progs","css_img"=>"traffic_image")
        elsif c['name'] == '育'
          c = c.merge!("css_progs"=>"education_progs","css_img"=>"education_image")
        elsif c['name'] == '樂'
          c = c.merge!("css_progs"=>"fun_progs","css_img"=>"fun_image")
        end
      end
      @info['cates'] = @cates
      @info
    end
  end