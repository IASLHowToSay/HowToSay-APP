# frozen_string_literal: true

require 'http'

module Howtosay
  # Returns an authenticated user, or nil
  class AuthenticateAccount
    class UnauthorizedError < StandardError;
      def message
        '帳號或密碼有錯誤！'
      end
    end

    def initialize(config)
      @config = config
    end

    def call(email:, password:)
      response = HTTP.post("#{@config.API_URL}/accounts/authenticate",
                           json: { email:email, password:password })
      raise(UnauthorizedError) unless response.code == 200
      response.parse
    end
  end
end