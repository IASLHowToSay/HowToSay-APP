# frozen_string_literal: true

require 'http'
# Encrypt recovery email data for sending email
module Howtosay
  class VerifyRecoveryEmail
    class VerifyRecoveryEmailError < StandardError; end
    class UnAvilableAccountError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(email)
      password_recovery_data = { email: email } 
      password_recovery_token = SecureMessage.encrypt(password_recovery_data)
      password_recovery_data['reset_url'] =
        "#{@config.MACHINE_URL}/auth/resetpassword/#{password_recovery_token}"
      response = HTTP.post("#{@config.API_URL}/accounts/forgetpassword",
                           json: password_recovery_data)
      raise(VerifyRecoveryEmailError) if response.code == 500
      raise(UnAvilableAccountError) if response.code == 404
      response.parse
    end
  end
end
