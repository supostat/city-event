require 'cart_encryption'
require 'rc_auth'
class HomeController < ApplicationController
  include CartEncryption
  include FoxySync

  skip_before_filter :verify_authenticity_token, :require_login

  # These pages shouldn't be accessible once the user has paid
  before_filter :redirect_when_paid, only: :summary

  # Redirect to upcoming events if already registered
  before_filter :redirect_when_already_registered, only: :registration

  layout "frontend"



  #display home page
  def index
    @city_user = CityUser.new

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
      @decrypted_city_data = RcAuth::decrypt_city_data(@raw_city_data, @raw_city_data_iv, TheCityEvents::THE_CITY_SECRET[0, 32])
    end

    json = @decrypted_city_data

    if not json.nil? and not json.empty?
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

      redirect_to upcoming_path

    end

  end


  #show upcoming page
  def upcoming

    if request.method == "POST"
      set_user_login
    end

    if current_user.nil?
      redirect_to root_path, notice: 'No city user selected!.'
    end



    title=''
    if params[:title].present?
      title =params[:title]
    end
    @events = Event.where("start_date > ? and lower(title) LIKE ? ", Time.now.strftime('%Y-%m-%d'),"%#{ title.downcase }%").paginate(:page => params[:page], :per_page => params[:limit]).order("start_date")

  end

  #show registration page
  def registration
    if request.method =="POST"
        #//////
    else
      @event = validate_event(params[:event_id])

      if @event.nil?
        redirect_to events_path, :notice => "Sorry, event has been passed."
        return
      end

      @registration = Registration.new(:event => @event)

      if current_user.nil?
        redirect_to upcoming_path, :notice => "Sorry, no city user."
        return
      end

      @registration.family_members = current_user.family_members.where('city_user_id != ?', current_user.user_id).all(:order => :city_user_id)

      @event.addons.order('id').collect do |addon|
        a= @registration.registration_addons.build(addon_id: addon.id)
        addon.choices.order('id').collect do |choice|
          a.registration_choices.build(choice_id: choice.id,choice_price: choice.price)
        end
      end

    end

  end

  #complete registration
  def create

    @registration = current_user.registrations.new(event_params)

    respond_to do |format|
      if @registration.save
        if @registration.amount_payable == 0.0
          format.html { redirect_to upcoming_url }
        else
          format.html { redirect_to event_registration_summary_url(:id => @registration.id) }
        end
      else
        @event =validate_event(event_params[:event_id])
        @registration.family_members = current_user.family_members.where('city_user_id != ?', current_user.user_id).all(:order => :city_user_id)
        format.html { render action: 'registration' }
      end
    end

  end
  #show summary page
  def summary
    @registration = Registration.find(params[:id])
    if @registration.amount_payable == @registration.amount_paid
      redirect_to upcoming_url,notice: 'Event was successfully registered.'
    end
  end

  private

  def set_user_login
    #Set Current City User
    user_id =   params[:city_user][:city_user_id]
    if user_id.split('(')[1]
      user_id = user_id.split('(')[1].gsub(')','')
    end


    @current_city_user = CityUser.find_by_city_user_id(user_id)

    if @current_city_user.kind_of?(NilClass)
      #redirect_to root_url
      return
    end

    session[:city_user_id] = @current_city_user.city_user_id

    user = User.find_by_user_id(@current_city_user.city_user_id.to_s)
    if (user.nil?)
      user =User.create_with_city_user(@current_city_user)
    end

    if user.nil?
      render :text => "Unknown Error Occurred"
    end

    cookies[:user_id] = user.id
    session[:user_id] = user.id

    #Set Current Logon  User
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end

  def validate_event(event_id)
    event_id = Event.find(event_id) #Get Event id from params and verify it
                                    #Avoid SQL Injection
    Event.where("id= ? and start_date >= ? ",event_id.id,Time.now.strftime('%Y-%m-%d')).order("start_date desc").first
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:registration).permit(:event_id,:amount_total,:amount_payable,:max_price,
                                         :registration_addons_attributes => [:addon_id,:addon_value,:registration_choices_attributes =>[:choice_id,:choice_value,:choice_price]],
                                         :registration_guests_attributes => [:city_user_id,:first,:last,:email,:primary_phone,:address,:city,:state,:coming,:registration_addons_attributes => [:addon_id,:addon_value,:registration_choices_attributes =>[:choice_id,:choice_value,:choice_price]]])


  end

end



