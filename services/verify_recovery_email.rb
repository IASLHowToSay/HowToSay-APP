# frozen_string_literal: true

require 'http'
# Encrypt recovery email data for sending email
module Howtosay
  class VerifyRecoveryEmail
    class VerifyRecoveryEmailError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(email)
      password_recovery_data = { email: email } 
      password_recovery_token = SecureMessage.encrypt(password_recovery_data)
      password_recovery_data['reset_url'] =
        "#{@config.APP_URL}/auth/resetpassword/#{password_recovery_token}"
      response = HTTP.post("#{@config.API_URL}/accounts/forgetpassword",
                           json: password_recovery_data)
      raise(VerifyRecoveryEmailError) unless response.code == 202
      response.parse
    end
  end
end
