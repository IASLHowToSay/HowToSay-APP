# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class SaveAnswer
  class InvalidSaveAnswer < StandardError; end

  def initialize(config)
    @config = config
  end

  def call(account_id, task_id, question_id, detail_id, sentence)
    
    message = { account_id: account_id,
                task_id: task_id,
                question_id: question_id,
                detail_id: detail_id,
                sentence: sentence
            }

    response = HTTP.post(
      "#{@config.API_URL}/rewrite/saveanswer",
      json: message
    )

    response.code == 201 ? response : (raise InvalidSaveAnswer)
    
  end
end