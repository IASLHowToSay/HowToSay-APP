# frozen_string_literal: true

require 'http'

# Returns grade page
class GetGradepage
  def initialize(config, email, cate_id)
    @config = config
    @email = email
    @cate_id = cate_id
  end

  def call()
    response = HTTP.get("#{@config.API_URL}/grade/#{@email}/#{@cate_id}")
    puts response.parse
    response.code == 200 ? response.parse : nil
  end
end
