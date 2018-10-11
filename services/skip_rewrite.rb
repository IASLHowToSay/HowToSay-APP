# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class SkipRewrite
  class InvalidSkipRewrite < StandardError; end

  def initialize(config)
    @config = config
  end

  def call(account_id, task_id, question_id)
    
    message = { account_id: account_id,
                task_id: task_id,
                question_id: question_id
            }

    response = HTTP.post(
      "#{@config.API_URL}/rewrite/skip",
      json: message
    )

    response.code == 201 ? response : (raise InvalidSkipRewrite)
    
  end
end