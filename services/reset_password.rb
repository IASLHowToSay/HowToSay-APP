# frozen_string_literal: true

require 'http'
# Encrypt recovery email data for sending email
module Howtosay
  class ResetPassword
    class ResetPasswordError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(newpassword, token)
      new_account = SecureMessage.decrypt(token)
      new_account = new_account.merge!("password": newpassword)
      response = HTTP.post("#{@config.API_URL}/accounts/changepassword",
                           json: new_account)
      raise(ResetPasswordError) unless response.code == 201
      response.parse
    end
  end
end
