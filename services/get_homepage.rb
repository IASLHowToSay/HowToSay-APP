# frozen_string_literal: true

require 'http'

# Returns all cates and user info
class GetHomepage
  def initialize(config, email)
    @config = config
    @email = email
  end

  def call()
    response = HTTP.get("#{@config.API_URL}/home/#{@email}")
    response.code == 200 ? response.parse : nil
  end
end
