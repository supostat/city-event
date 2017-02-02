class ApplicationController < ActionController::Base
  helper :registration
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :current_city_user

  before_filter :allow_iframe_requests  , :require_login

  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end

  def failure

  end

  # This checks to see if the user has paid for the event. If so, it will redirect
  # to the upcoming events page
  def redirect_when_paid
    if request.method == "GET"
      if current_user && current_user.has_paid_registration?(params["id"])
        redirect_to upcoming_path
      end
    end
  end

  def redirect_when_already_registered
    if request.method == "GET"
      if current_user && current_user.has_already_registered?(params["event_id"])
        redirect_to upcoming_path
      end
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  #Pulls the copy of the City User based on the local copy and the current user session
  def current_city_user
    session[:city_user_id]=@current_user.user_id  if @current_user
    @current_city_user ||= CityUser.find_by_city_user_id(session[:city_user_id]) if session[:city_user_id]
  end

  def require_login
    unless current_user
      redirect_to "/auth/thecity"
    end
  end




end
