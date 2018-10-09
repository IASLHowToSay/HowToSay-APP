# frozen_string_literal: true


# Returns a hash which has background attr
class DecideBackground
  def initialize(info)
    @info = info
    @cate = info["question"]["cate"]["name"]
  end

  def call()
    if @cate == "食"
      @info["background"] = "eat_background"
    elsif @cate == "衣"
      @info["background"] = "cloth_background"
    elsif @cate == "住"
      @info["background"] = "live_background"
    elsif @cate == "行"
      @info["background"] = "traffic_background"
    elsif @cate == "育"
      @info["background"] = "education_background"
    elsif @cate == "樂"
      @info["background"] = "fun_background"
    end
    @info
  end
end