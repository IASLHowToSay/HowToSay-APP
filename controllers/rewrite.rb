# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Howtosay API
  class App < Roda
    route('rewrite') do |routing|
      routing.on String do |cate_id|
        # label
        routing.on 'label' do
          # GET rewrite/[cate_id]/label
          routing.get do
            unless @current_account.nil?
              info = GetLabelpage.new(App.config, @current_account["email"], cate_id).call()
              if info.nil?
                routing.redirect '../../'
              end
              lable_info = CSSBackground.new(info).call()
              view '/rewrite/label', layout: { template: '/layout/layout_task/main' },locals: { :label_info=> lable_info }  
            else
              routing.redirect '../../auth/login'
            end
          end

          routing.on 'skip' do
            # POST rewrite/[cate_id]/label/skip
            routing.post do
              account_id = @current_account["id"]
              task_id = routing.params['task_id']
              question_id = routing.params['question_id']
              response = SkipRewrite.new(App.config).call(account_id, task_id, question_id)
              routing.redirect 'label'
            end
          end
        end
        
        # sentence
        routing.on 'sentence' do
          # GET rewrite/[cate_id]/sentence
          routing.get do
            unless @current_account.nil?
              info = GetSentencepage.new(App.config, @current_account["email"], cate_id).call()
              if info.nil?
                routing.redirect '../../'
              end
              sentence_info = CSSBackground.new(info).call()
              view '/rewrite/sentence', layout: { template: '/layout/layout_task/main' },locals: { :sentence_info=> sentence_info }  
            else
              routing.redirect '../auth/login'
            end 
          end
          # POST rewrite/[cate_id]/sentence
          # 存到 good_question, good_detail, good_sentence
          routing.post do
            account_id = @current_account["id"]
            task_id = routing.params['task_id']
            question_id = routing.params['question_id']
            detail_id = routing.params['detail']
            sentence = routing.params['sentence']
            response = SaveRewrite.new(App.config).call(account_id, task_id, question_id, detail_id, sentence)
            routing.redirect 'label'
          end
        end
      end
    end
  end
end