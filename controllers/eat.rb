# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Howtosay API
  class App < Roda
    route('eat') do |routing|
      routing.on 'label' do
        routing.get do
          unless @current_account.nil?
            view 'writer/eat/label', layout: { template: '/layout/layout_task/main' } 
          else
            routing.redirect '../auth/login'
          end
        end
      end
      routing.on 'sentence' do
        routing.get do
          unless @current_account.nil?
            view 'writer/eat/sentence', layout: { template: '/layout/layout_task/main' } 
          else
            routing.redirect '../auth/login'
          end 
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