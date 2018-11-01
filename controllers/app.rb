# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'logger'

module Howtosay
  # Base class for HowToSay Web Application
  class App < Roda
   
    plugin :render, engine: 'slim', views: 'views', layout: 'layout/layout_home/main'
    plugin :assets, css: ['hts.auth.css','hts.home.css','hts.task.css'], path: 'assets'
    # adds a r.public routing method to serve static files from a directory.
    plugin :public, root: 'public'
    plugin :multi_route
    plugin :flash

    # ONE_YEAR = 12*30*24*60*60

    # use Rack::Session::Cookie,
    #     expire_after: ONE_YEAR,
    #     secret: Howtosay::App.config.SESSION_SECRET

    route do |routing|
      # routing begins
      #@current_account = session[:current_account]
      
      @logger = Logger.new('howtosay.log', 'daily')
      @logger.level = Logger::DEBUG

      @current_account = SecureSession.new(session).get(:current_account)

      routing.public
      routing.assets
      # 若 routing 的地方不在此file跑到 routing.multi_route 就會接到別的file去
      routing.multi_route

      # GET /
      routing.root do
        if @current_account
          @logger.info("用戶 #{@current_account["email"]} 登入")
          info = GetHomepage.new(App.config,@current_account["email"]).call()
          home_info = CSSHome.new(info).call()
          view 'home', locals: { :home_info=> home_info }
        else
          routing.redirect 'auth/login'
        end
      end
    end
  end
end