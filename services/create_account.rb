# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class CreateAccount
  class InvalidAccount < StandardError; end

  def initialize(config)
    @config = config
  end

  def call(name:, email:, password:, organization_id:, teacher:)
    

    message = { name: name,
                email: email,
                password: password,
                organization_id: organization_id,
                teacher: teacher
            }

    response = HTTP.post(
      "#{@config.API_URL}/accounts",
      json: message
    )

    raise InvalidAccount unless response.code == 201
  end
end