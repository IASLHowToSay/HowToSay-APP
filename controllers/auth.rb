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
          account = CreateAccount.new(App.config).call(
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

      routing.on 'logout' do
        routing.get do
          # session[:current_account] = nil
          SecureSession.new(session).delete(:current_account)
          routing.redirect @login_route
        end
      end
    end
  end
end
