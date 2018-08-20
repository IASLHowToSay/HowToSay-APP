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
          routing.redirect '/' unless session[:current_account].nil?
          view "auth/login", layout: { template: '/layout/layout_auth/main' }
        end

        # POST /auth/login
        routing.post do
          logged_in_account = AuthenticateAccount.new(App.config).call(
            email: routing.params['email'],
            password: routing.params['password'])
          # 得到 account 後 將account存於 session 就此創建 session
          SecureSession.new(session).set(:current_account, logged_in_account)
          #session[:current_account] = logged_in_account
          # flash[:notice] = "Welcome back #{session[:current_account]['name']}!"
          routing.redirect '/'
        rescue StandardError
          flash[:error] = '無法登入'
          routing.redirect @login_route
        end
      end

      routing.is 'register' do
        routing.get do
          view "auth/register", layout: { template: '/layout/layout_auth/main' }    
        end

        routing.post do
          account = CreateAccount.new(App.config).call(
            name: routing.params['name'],
            email: routing.params['email'],
            password: routing.params['password'],
            organization_id: routing.params['organization_id'],
            teacher: routing.params['teacher'])
          flash[:notice] = "恭喜 #{routing.params['name']} 註冊成功!"
          routing.redirect 'login'
        rescue StandardError
          flash[:error] = '無法註冊'
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
