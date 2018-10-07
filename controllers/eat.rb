# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Howtosay API
  class App < Roda
    route('eat') do |routing|
      routing.on 'label' do
        routing.get do
          unless @current_account.nil?
            info = GetLabelpage.new(App.config, @current_account["email"], 1).call()
            view 'writer/eat/label', layout: { template: '/layout/layout_task/main' },locals: { :label_info=> info }  
          else
            routing.redirect '../auth/login'
          end
        end
        # routing.post do
        #   writer_id = routing.params['writer_id']
        #   question_id = routing.params['question_id']
        #   good = routing.params['good']
        #   response = CollectGoodquestion.new(App.config, writer_id, question_id, good).call()
        #   if response.code == 201
        #     routing.redirect 'sentence'
        #   else
        #     puts 'label post error'
        #   end
        # end
      end
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
          question_id = routing.params['question_id']
          detail_id = routing.params['detail']
          sentence = routing.params['sentence']
          response = SaveAnswer.new(App.config).call(account_id, question_id, detail_id, sentence)
        end
      end
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