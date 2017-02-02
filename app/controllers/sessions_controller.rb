require 'rc_auth'

class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :require_login

  before_filter :set_city_data

  def pull_family_members(user)

    city_user = TheCity::User.load_by_id(current_user.user_id)
    # puts "ADD CHECK FOR FAMILY"
    begin
      # we are finding memebrs on each login, web hook will not work yet
      if !city_user.family.empty?
        city_user.family.each do |row|
          user.family_members.find_or_create_by_city_user_id(:city_user_id => row.user_id,
                                                             :email => row.email,
                                                             :name => row.name,
                                                             :family_role => row.family_role,
                                                             :active => row.active,
                                                             :full_name => "#{row.name} (#{row.user_id.to_s})")
        end
      end
    rescue Exception => exc
      #nothing to do
    end

  end


  def create
    auth = request.env["omniauth.auth"]

    user = User.find_by_provider_and_uid(auth["provider"], "#{auth["uid"]}") || User.create_with_omniauth(auth)
    session[:user_id] = user.id

    if !user.nil?
      pull_family_members(user)

      #Delayed job applied
      delayed_jobs

      redirect_to events_path, :notice => "Signed in!"
      return
    else
      redirect_to "/auth/failure", :notice => "Invalid authentication!"
    end

  end

  def adminLogin

    #check if browser cookie not set
    if browser_cookie_not_set
      return
    end

    cityLogin('admin')
  end

  def clientLogin


    #check if browser cookie not set
    if browser_cookie_not_set
      return
    end

    cityLogin('client')

  end

  def cityLogin(userType)
    begin

      json = @decrypted_city_data

      if not json.empty?
        data = JSON.restore(json)

        user = User.find_by_user_id(data['user_id'].to_s)
        if (user.nil?)
          client = TheCity::User.load_by_id(data['user_id'])
          user =User.create_with_token(data, client)
        end
        cookies[:user_id] = user.id
        session[:user_id] = user.id
        #Set Current Logon  User
        @current_user = User.find(session[:user_id]) if session[:user_id]

        if !user.nil?

          pull_family_members(user)

          #Delayed job applied
          delayed_jobs


          if (userType=="admin")
            redirect_to "/admin", :notice => "Admin Signed in!"
          else
            redirect_to upcoming_path, :notice => "User Signed in!"
          end

        end
      else
        redirect_to "/auth/thecity", :notice => "Invalid login"
      end

    rescue Exception => e

      logger.error "sessions_controller::cityLogin => exception #{e.class.name} : #{e.message}"

      #check if browser cookie not set
      if browser_cookie_not_set
        return
      end

    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to "/auth/thecity", :notice => "Signed out!"
  end

  def safari_cookie
    cookies.permanent[:safari_cookie] = "true"
    cookies[:city_data] = params[:city_data]
    cookies[:city_data_iv] = params[:city_data_iv]
  end

  private

  def set_city_data

    if params.key?(:city_data)
      @raw_city_data = params[:city_data]
      @raw_city_data_iv = params[:city_data_iv]
    elsif cookies[:city_data].present?
      @raw_city_data = cookies[:city_data]
      @raw_city_data_iv = cookies[:city_data_iv]
    else
      @raw_city_data = nil
      @raw_city_data_iv = nil
    end

    if @raw_city_data.present? and @raw_city_data_iv.present?
      @decrypted_city_data = RcAuth::decrypt_city_data(params['city_data'], params['city_data_iv'], TheCityEvents::THE_CITY_SECRET[0, 32])
    end

  end

  def browser_cookie_not_set
    browser = Browser.new(:ua => request.env['HTTP_USER_AGENT'], :accept_language => "en-us")

    if browser.safari? and cookies[:safari_cookie].blank?
      render :template => "sessions/safari_link"
      true
    else
      false
    end

  end

  private

  def delayed_jobs
    if CityUser.all.count== 0
      CityUser.delay.pull_city_users
    end
  end
end