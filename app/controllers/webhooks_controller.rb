class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token, :require_login

  def createCityUser
    begin

    CityUser.create!(
        :primary_campus_id => params[:primary_campus_id],
        :city_user_id => params[:id],
        :first => params[:first],
        :last => params[:last],
        :gender => params[:gender],
        :primary_campus_name => params[:primary_campus_name],
        :full_name => "#{params[:first]} #{params[:last]} (#{params[:id].to_s})",
        :active => params[:active])

        render  :json => {
            :status => 200,
            :message => "user created"
        }
    rescue Exception => exc
      logger.error("Action: createCityUser, Error: #{exc.message}")
    end
  end


end
