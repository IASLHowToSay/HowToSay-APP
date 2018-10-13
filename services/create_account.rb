# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class CreateAccount
  class InvalidAccount < StandardError;

    def initialize(email, response)
      @response = response.parse
      @email = email
    end

    def message()
      if "#{@response['message']}".include? "ConstraintException"
        "用戶 #{@email} 已被註冊！請使用其他 email"
      else
        "系統目前維修中，請見諒"
      end
    end
  end

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

    raise InvalidAccount.new(email,response) unless response.code == 201
    
  end
end