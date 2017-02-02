class Admin::ReportsController < ApplicationController
  def summary
    @event =Event.find(params[:id])
  end

  def detail
    @event =Event.find(params[:id])
    @registrations = @event.registrations.where("amount_paid>=amount_payable")

    respond_to do |format|
      format.html
      format.csv { send_data  @event.exportCSV }
      format.xls { send_data @event.exportCSV(col_sep: "\t") }
    end


  end
end
