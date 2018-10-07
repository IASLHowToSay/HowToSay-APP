# frozen_string_literal: true

require 'http'

# Returns all projects belonging to an account
class GetLabelpage
  def initialize(config, email, cate_id)
    @config = config
    @email = email
    @cate_id = cate_id
  end

  def call()
    response = HTTP.get("#{@config.API_URL}/rewrite/#{@email}/#{@cate_id}/label")
    puts response.parse
    response.code == 200 ? response.parse : nil
  end
end
