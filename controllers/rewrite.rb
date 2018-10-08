# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Howtosay API
  class App < Roda
    route('rewrite') do |routing|
      routing.on String do |cate_id|
        # label
        routing.on 'label' do
          routing.get do
            unless @current_account.nil?
              info = GetLabelpage.new(App.config, @current_account["email"], cate_id).call()
              if info['task_id'].nil?
                routing.redirect '../../'
              end
              lable_info = DecideBackground.new(info).call()
              puts '------------'
              puts lable_info
              puts '------------'
              view '/rewrite/label', layout: { template: '/layout/layout_task/main' },locals: { :label_info=> lable_info }  
            else
              routing.redirect '../../auth/login'
            end
          end
        end
        
        # sentence
        routing.on 'sentence' do
          routing.get do
            unless @current_account.nil?
              info = GetSentencepage.new(App.config, @current_account["email"], 1).call()
              view 'writer/eat/sentence', layout: { template: '/layout/layout_task/main' },locals: { :sentence_info=> info }
            else
              routing.redirect '../auth/login'
            end 
          end
          # 存到 good_question, good_detail, good_sentence
          routing.post do
            account_id = @current_account["id"]
            task_id = routing.params['task_id']
            question_id = routing.params['question_id']
            detail_id = routing.params['detail']
            sentence = routing.params['sentence']
            response = SaveAnswer.new(App.config).call(account_id, task_id, question_id, detail_id, sentence)
            routing.redirect 'label'
          end
        end
        
        # grade
        routing.on 'grade' do
          routing.get do
            unless @current_account.nil?
              view 'grader/eat/grade', layout: { template: '/layout/layout_task/main' }
            else
              routing.redirect '../auth/login'
            end
          end
        end

      end
    end
  end
end