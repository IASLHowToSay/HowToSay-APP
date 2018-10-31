# frozen_string_literal: true


# Returns a hash which has background attr
class CSSBackground
  def initialize(info)
    @info = info
    @cate = info["question"]["cate"]["name"]
  end

  def call()
    if @cate == "食"
      @info["background"] = "/eatBG.png"
      @info["color"] = "#f18c1c"
    elsif @cate == "衣"
      @info["background"] = "/clothBG.png"
      @info["color"] = "#d24f3a"
    elsif @cate == "住"
      @info["background"] = "/liveBG.png"
      @info["color"] = "#f5d1b2"
    elsif @cate == "行"
      @info["background"] = "/trafficBG.png"
      @info["color"] = "#82b344"
    elsif @cate == "育"
      @info["background"] = "/educationBG.png"
      @info["color"] = "#26978f"
    elsif @cate == "樂"
      @info["background"] = "/funBG.png"
      @info["color"] = "#4d4d4d"
    end
    @info
  end
end