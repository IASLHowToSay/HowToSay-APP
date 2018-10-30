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
          c = c.merge!("css_progs"=>"eat_progs","css_img"=>"eat_image","img"=>"/home/eaticon.png","flag"=>"eat_flag")
        elsif c['name'] == '衣'
          c = c.merge!("css_progs"=>"cloth_progs","css_img"=>"cloth_image","img"=>"/home/clothicon.png","flag"=>"cloth_flag")
        elsif c['name'] == '住'
          c = c.merge!("css_progs"=>"live_progs","css_img"=>"live_image","img"=>"/home/liveicon.png","flag"=>"live_flag")
        elsif c['name'] == '行'
          c = c.merge!("css_progs"=>"traffic_progs","css_img"=>"traffic_image","img"=>"/home/trafficicon.png","flag"=>"traffic_flag")
        elsif c['name'] == '育'
          c = c.merge!("css_progs"=>"education_progs","css_img"=>"education_image","img"=>"/home/educationicon.png","flag"=>"education_flag")
        elsif c['name'] == '樂'
          c = c.merge!("css_progs"=>"fun_progs","css_img"=>"fun_image","img"=>"/home/funicon.png","flag"=>"fun_flag")
        end
      end
      @info['cates'] = @cates
      @info
    end
  end