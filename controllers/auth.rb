# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Credence API
  class App < Roda
    route('auth') do |routing|
      @login_route = '/auth/login'
      
      routing.is 'login' do

        # GET /auth/login
        routing.get do
          routing.redirect '/' unless @current_account.nil?
          view "auth/login", layout: { template: '/layout/layout_auth/main' }
        end

        # POST /auth/login
        routing.post do
          logged_in_account = AuthenticateAccount.new(App.config).call(
            email: routing.params['email'],
            password: routing.params['password'])
          SecureSession.new(session).set(:current_account, logged_in_account)
          routing.redirect '/'
        rescue AuthenticateAccount::UnauthorizedError => error
          @logger.warn("用戶 #{routing.params['email']} #{error.message}")
          @logger.close
          flash[:error] = error.message
          routing.redirect @login_route
        rescue StandardError => error
          @logger.warn("程式錯誤 #{error.message}")
          @logger.close
          flash[:error] = error.message
          routing.redirect @login_route
        end
      end

      routing.is 'register' do
        
        # GET /auth/register
        routing.get do
          info = GetRegisterpage.new(App.config).call()
          view "auth/register", layout: { template: '/layout/layout_auth/main' },locals: { :register_info=> info }    
        end
        
        # POST /auth/register
        routing.post do

          CreateAccount.new(App.config).call(
            name: routing.params['name'],
            email: routing.params['email'],
            password: routing.params['password'],
            organization_id: routing.params['organization_id'],
            teacher: routing.params['teacher'])
          
          flash[:notice] = "恭喜 #{routing.params['name']} 註冊成功!"

          @logger.info("用戶 #{routing.params['email']} 註冊成功!")
          @logger.close

          routing.redirect 'login'
        
        rescue CreateAccount::InvalidAccount => error
          
          @logger.warn("#{error.message}")
          @logger.close

          flash[:error] = error.message

          routing.redirect 'register'
        end
      end

      routing.is 'forgetpassword' do
        # GET /auth/forgetpassword
        routing.get do
          view "auth/forget_password", layout: { template: '/layout/layout_auth/main' }
        end
        
        # POST /auth/forgetpassword
        routing.post do
          email = routing.params['email']
          response_data = VerifyRecoveryEmail.new(App.config).call(email)
          flash[:notice] = response_data['message']
          routing.redirect '/'
        rescue StandardError => error
          puts "ERROR SENDING RECOVERY EMAIL: #{error.inspect}"
          # puts error.backtrace
          flash[:error] = ' 信箱寄送失敗'
          routing.redirect 'forgetpassword'
        end

      end

      routing.on 'resetpassword' do
        routing.on String do |password_recovery_token| 
          # GET /auth/resetpassword/[password_recovery_token]
          routing.get do
            flash[:notice] = '請填入新的密碼'
            info = {token: password_recovery_token}
            view "auth/reset_password", layout: { template: '/layout/layout_auth/main' },locals: { :token_info=> info }
          end
          # POST /auth/resetpassword/[password_recovery_token]
          routing.post do
            newpassword = routing.params['newpassword']
            token = routing.params['token']
            ResetPassword.new(App.config).call(newpassword, token)
            flash[:notice] = '更新密碼成功！'
            routing.redirect '/'
          rescue StandardError => error
            flash[:error] = ' 更新密碼失敗'
            routing.redirect '../forgetpassword'
          end
        end
      end

      routing.on 'logout' do
        routing.get do
          SecureSession.new(session).delete(:current_account)
          routing.redirect @login_route
        end
      end
    end
  end
end
