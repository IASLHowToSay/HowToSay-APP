 # frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Howtosay API
  class App < Roda
    route('grade') do |routing|
      routing.on String do |cate_id|

        routing.get do
          unless @current_account.nil?
            info = GetGradepage.new(App.config, @current_account["email"], cate_id).call()
            if info.nil?
              routing.redirect '/'
            end
            grade_info = CSSBackground.new(info).call()
            view 'grade/grade', layout: { template: '/layout/layout_task/main' },locals: { :grade_info=> grade_info }
          else
            routing.redirect '../../auth/login'
          end
        end
       
        # 存到 good_question, good_detail, good_sentence
        routing.post do
          account_id = @current_account["id"]
          cate_id = routing.params["cate_id"]
          task_id = routing.params['task_id']
          answer_size = routing.params['answer_size'].to_i
          @answers = {}
          answer_size.times do |i|
            answer_id, related = routing.params["answer#{i+1}"].split(':')
            @answers[answer_id] = related.to_i
          end
          SaveGrade.new(App.config).call(account_id, task_id, @answers)
          routing.redirect "/grade/#{cate_id}"
        end
      end
    end
  end
end