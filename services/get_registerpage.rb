# frozen_string_literal: true

require 'http'

# Returns all projects belonging to an account
class GetRegisterpage
  def initialize(config)
    @config = config
  end

  def call()
    response = HTTP.get("#{@config.API_URL}/accounts/register")
    response.code == 200 ? response.parse : nil
  end
end
