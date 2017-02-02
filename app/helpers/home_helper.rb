module HomeHelper

  def eventLink(event)
    status = event.status(current_user)
    if status == 'new'
      link_to event.title,event_registration_path(event.id) ,:class => 'clickEvent'
    elsif status  == 'registered'
      link_to event.title,'#'
    elsif status  == 'pending'
      link_to event.title,event_registration_summary_path(Registration.find_by_user_id_and_event_id(current_user.id,event.id)), :class => 'clickEvent'
    end

  end

  def eventStatus(status)
    if status == 'new'
      '<div class="tag blue">Register</div>'
    elsif status  == 'registered'
      '<div class="tag green">Registered</div>'
    elsif status  == 'pending'
      '<div class="tag yellow">Pending, pay now</div>'
    end
  end

  def current_route
    Rails.application.routes.router.recognize(request) do |route, _|
      return route.name.to_sym
    end
  end

  def current_tab_name
    route = request.env['PATH_INFO']
    if route =='/'
      '<span class="title">1. User Lookup</span>'
    elsif route.include? '/upcoming-events'
        ' <span class="title">2. Upcoming Events</span>'
    elsif route.include? '/event_registration'
      ' <span class="title">3. Registration</span>'
    elsif route.include? '/event_registration_summary'
      ' <span class="title">4. Summary</span>'
    else
        ' '
    end
  end

  def remaining(date)
    intervals = [["day", 1], ["hour", 24]]

    elapsed = DateTime.now - date

    tense = elapsed > 0 ? "since" : "until"

    interval = 1.0

    parts = intervals.collect do |name, new_interval|
                interval /= new_interval

                number, elapsed = elapsed.abs.divmod(interval)
                if number >0
                  "#{number.to_i} #{name}#{"s" unless number == 1}"
                end
            end
    parts = parts.reject{ |e| e.nil? }
   "#{parts.join(", ")}, Register thru "
  end

end