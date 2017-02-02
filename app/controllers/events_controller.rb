class EventsController < ApplicationController


  def index

    @registered_events = current_user.events.where("amount_paid=amount_payable")
    @pending_registrations = current_user.events.where("amount_paid<>amount_payable")

    @up_coming_events= Event.where("start_date > ? and id NOT IN (?)",Time.now.strftime('%Y-%m-%d'),current_user.events.select("events.id").load).order("start_date desc").load

  end

  def show
    begin
      @event =current_user.events.find(params[:id])
    rescue
      redirect_to events_path, :notice => "Well, that wasn't supposed to happen."
    end

  end

  def register

    @event = validate_event(params[:id])

    if @event.nil?
      redirect_to events_path, :notice => "Sorry, event has been passed."
      return
    end

    @registration = Registration.new(:event => @event)

    @registration.family_members = current_user.family_members.where('city_user_id != ?', current_user.user_id).all(:order => :city_user_id)

    @event.addons.order('id').collect do |addon|
      a= @registration.registration_addons.build(addon_id: addon.id)
      addon.choices.order('id').collect do |choice|
        a.registration_choices.build(choice_id: choice.id,choice_price: choice.price)
      end
    end


  end

  #Creates a new event
  def create

    @registration = current_user.registrations.new(event_params)

    respond_to do |format|
      if @registration.save
        if @registration.amount_payable == 0.0
          format.html { redirect_to :controller => 'events', notice: 'Event was successfully registered.'  }
        else
          format.html { redirect_to :controller => 'registrations', :action => 'summary', :id => @registration.id,notice: 'Event was successfully registered.' }
        end

      else
        @event =validate_event(event_params[:event_id])
        @registration.family_members = current_user.family_members.where('city_user_id != ?', current_user.user_id).all(:order => :city_user_id)
        format.html { render action: 'register' }
      end
    end

  end


  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:registration).permit(:event_id,:amount_total,:amount_payable,:max_price,
                                         :registration_addons_attributes => [:addon_id,:addon_value,:registration_choices_attributes =>[:choice_id,:choice_value,:choice_price]],
                                         :registration_guests_attributes => [:city_user_id,:first,:last,:email,:primary_phone,:address,:city,:state,:coming,:registration_addons_attributes => [:addon_id,:addon_value,:registration_choices_attributes =>[:choice_id,:choice_value,:choice_price]]])


  end

  def validate_event(event_id)
    event_id = Event.find(event_id) #Get Event id from params and verify it
    #Avoid SQL Injection
    Event.where("id= ? and start_date >= ? ",event_id.id,Time.now.strftime('%Y-%m-%d')).order("start_date desc").first
  end
end
