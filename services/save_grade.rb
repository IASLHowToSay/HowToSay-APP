# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class SaveGrade
  class InvalidSaveGrade < StandardError; end

  def initialize(config)
    @config = config
  end

  def call(account_id, task_id, answers)
    
    good_answers = []

    answers.each do |key,value|
        item = {
            answer_id: key.to_i,
            grader_id: account_id,
            good: value==1 ? true : false
        }
        good_answers << item
    end
    
    message = {
               task_id: task_id,
               good_answers: good_answers
            }

    response = HTTP.post(
      "#{@config.API_URL}/grade/saveanswer",
      json: message
    )

    response.code == 201 ? response : (raise InvalidSaveGrade)
    
  end
end