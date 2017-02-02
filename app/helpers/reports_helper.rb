module ReportsHelper

  def choices(event)
    #summary
    choice_ids = event.registrations.joins(:registration_addons).joins(:registration_choices).select("registration_choices.id").group("registration_choices.id")

    Choice.joins(:registration_choices).select("title,sum(choice_value) as choice_value").group("title").where("registration_choices.id IN(?)", choice_ids)

  end

  def addons_headings_placeholder(event, state)
    result=""
    event.addons.where(:registration_type => state).each do |a|
      result += "<td></td>"
    end
    result
  end

  def addons_headings(event, state)
    result=""
    event.addons.where(:registration_type => state).each do |a|
      result += "<th>#{a.title}</th>"
    end
    result
  end

  def guests(r)
    result="<table class='with_no_borders'>"
    r.registration_guests.each do |guest|
      result +="<tr style='border: 0 !important;'><td id='guest_info'><div class='guest-detail'> #{guest.address_details.blank? ? '' : "<a id='#{guest.id}' href='#' onclick='return false;'> <i class='toggle-icon'></i></a>" }  #{guest.guest_name} <div id='address_detail' class='hide'>#{guest.address_details}</div> </div></td></tr>"
    end
    result +="</table>"


  end

  def registration_specific_choices(event, r)
    choices=""
    event.addons.where(:registration_type => true).each do |a|
      addon =r.registration_addons.where(:addon_id => a.id).first
      choices += "<td>#{ getTitle(addon, false)} </td>"
    end
    choices
  end

  def addons_values(event, r)
    choices=""
    event.addons.where(:registration_type => false).each do |a|
      choices = choices+ "<td>#{registrant_specific_choices(a.id, r).html_safe}</td>"
    end
    choices
  end

  def registrant_specific_choices(id, r)
    result="<table class='with_no_borders'>"
    r.registration_guests.each do |guest|
      addon =guest.registration_addons.where(:addon_id => id).first
      if addon
        result += "<tr style='border: 0 !important;'><td>#{ getTitle(addon, false)} </td></tr>"
      end

    end
    result +="</table>"
  end

  def getTitle(a, empty)

    case a.addon.addon_type
      when "Addons::Text"
        a.addon_value=='' ? '-' : a.addon_value
      when "Addons::Dropdown"
        a.addon_value=='' ? '-' : Choice.find_by_id(a.addon_value).title
      when "Addons::Checkbox"
        choices = a.registration_choices.where(:choice_value => 1)
        if choices.count>0
          choices.map { |c| c.choice.title }.join ','
        else
          "-"
        end
      when "Addons::Scale"
        choices = a.registration_choices
        if choices.count>0
          choices.map { |c| "#{c.choice.title}-#{c.choice_value.nil? ? 0 : c.choice_value }" }.join ' | '
        else
          empty ? "" : "-"
        end
      else
        a.addon.addon_type
    end
  end

  def getChoices(addon)
    result=""

    if choices.count>0
      begin
        result += "#{ choices.map { |c| c.choice.title }.join ','}"
      rescue Exception => ex
        result += "0"
      end
    else
      result += "-"
    end
    result
  end

  def guest_row_totals(event, r)
    result="<table class='with_no_borders' id='guest_row_totals'>"
    price =0.00
    r.registration_guests.each do |guest|
      a = RegistrationAddon.where(:registration_guest_id => guest.id).joins(:registration_choices).sum("choice_value*choice_price")
      result +="<tr style='border: 0 !important;'><td>#{a>0 ? "$ %.2f" % a : '-'} </td></tr>"
    end
    result +="</table>"
  end

  def total_dynamic_cols(event)
    event.addons.count()
  end

  def addon_rows(event)
    result=""
    event.addons.where("addon_type != 'Addons::Text'").each do |a|
      result+="<tr><td style='text-align: center;vertical-align: middle !important;'>#{a.title}</td><td style='padding: 0px 0px;'>#{choice_row(a)}</td></tr>"
    end
    result
  end

  def choice_row(addon)

    result="<table class='with_stripe_and_borders' style='margin: -1px;width: 101%;' id='choice_row'>"
    if addon.addon_type == 'Addons::Dropdown'
      result+= drop_down_choice_row(addon)
    else
      addon.choices.each do |c|
        choice_value= RegistrationAddon.joins(:registration).joins(:registration_choices).where(" amount_paid=amount_payable AND addon_id=? AND choice_id=? ", addon, c).sum("choice_value")
        if choice_value>0
          result+="<tr><td>#{c.title}</td><td style='text-align: right;width: 65px;'>#{choice_value}</td></tr>"
        end
      end
    end

    result+="</table>"

  end

  def drop_down_choice_row(addon)
    result=""
    choices = addon.event.registrations.joins(:registration_addons).select("registration_addons.addon_value as choice_id,count(*) as choice_value").where("amount_paid=amount_payable AND addon_id=?", addon).group("addon_value")
    choices.each do |c|
      choice = Choice.find_by_id(c.choice_id)
      if !choice.nil?
        result+="<tr><td>#{choice.title}</td><td style='text-align: right;width: 65px;'>#{c.choice_value}</td></tr>"
      end
    end
    result
  end

end
