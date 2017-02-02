class Admin::EventsController < ApplicationController

require 'addon_form'
  def index
    @events = Event.all.order(start_date: :desc)
  end
  def show
    @event = Event.find(params[:id])
  end
  def new
    @admin_event = Event.new
    1.times do
      addon = @admin_event.addons.build
      1.times { addon.choices.build }
    end
  end

  # POST /events
  # POST /events.json
  def create

    @admin_event = Event.new(event_params)

    respond_to do |format|
      if @admin_event.save
        format.html { redirect_to admin_events_url, notice: 'Event was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def destroy

    Event.find(params[:id]).update :archive => true

    return redirect_to admin_events_url, notice: 'Event was successfully deleted.'

  end
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:title, :start_date, :end_date, :start_time, :end_time, :base_price, :max_price, :seats,:content,addons_attributes: [:addon_type,:registration_type,:title,:_destroy,choices_attributes:[:title,:price,:range_from,:range_to,:_destroy]])
  end

end
