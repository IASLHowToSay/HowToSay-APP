# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Credence API
  class App < Roda
    route('traffic') do |routing|
      routing.on 'grade' do
        routing.get do
          view :traffic_grade
        end
      end
    end
  end
end