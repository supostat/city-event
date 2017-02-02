module EventsHelper

  def person_image(gender,imgDefault="no_image_male.jpg")
    image =imgDefault

    if gender == 'Male'
      image =imgDefault
    end

    if gender == 'Female'
        image =imgDefault
    end


    request.protocol+request.host_with_port+image_path(image)
  end

  #Function to choose which partial to render based on controller for Event Registration views
  def render_addon_form_helper(a, addon_form,type)
    if a.addon.registration_type==type
      partial = a.addon.addon_type.to_s.split("::").last.downcase
      #If using the outside-City controller ("Home") render one partial, otherwise use in-City partial
      if params[:controller]=='home'
        render partial: "home/addons/#{partial}", locals: { addon_form: addon_form, a: a }
      else
        render partial: "events/addons/#{partial}", locals: { addon_form: addon_form, a: a }
      end
    end
  end

  def fields_person_specific_options(f,registration)
     render(partial: "events/person_options", locals: { :f => f,:registration => registration,:person_id => "",:person_id_name=>"",:display_state => true })
  end

  def link_to_add_person_specific_options(f,registration,cssClass="left btn btn_mini",personTemplate='events/person',defaultAction=0)

    person =render(partial: personTemplate,locals: {:f => f,:registration => registration, :person_id => "{demo_id}",
                                                    :person_picture => person_image('no_image_male.jpg'),
                                                    :person_name =>  "{demo_name}",
                                                    :checked_state => true,
                                                    :display_state => true})

    fields =fields_person_specific_options(f,registration)

    if(cssClass=='plus')
      link_to  '', 'javascript:void(0);',
               :onclick => h("add_person_fields(this, \"#{registration}\", \"#{escape_javascript(fields)}\",\"#{escape_javascript(person)}\",#{defaultAction});"),
               :class => cssClass
    else
      link_to image_tag('add_icon.png', :border=>0,:alt=>'Add_icon', :style => 'margin-right: 3px; float: left;'), 'javascript:void(0);',
              :onclick => h("add_person_fields(this, \"#{registration}\", \"#{escape_javascript(fields)}\",\"#{escape_javascript(person)}\",#{defaultAction});"),
              :class => cssClass
    end




  end
  def link_to_toggle_person(f,registration,person_id,person_name)
    h("personCartToggle(this,\"#{person_id}\",\"#{person_name}\",\"#{registration}\",\"#{escape_javascript(fields_person_specific_options(f,registration))}\");")
  end

  def link_to_add_guest_specific_options(name,f,registration,cssClass="",guestPartial='events/guest')

    guest =render(partial: guestPartial,locals: { :f => f,:registration => registration})

    fields= render(partial: "events/person_options", locals: { :f => f,:registration => registration,:person_id => "{guest_id}",:person_id_name=>"{guest_name}",:display_state => true })


    link_to name, 'javascript:void(0);',
            :class => cssClass,
            :onclick => h("addGuest(\"#{registration}\", \"#{escape_javascript(fields)}\",\"#{escape_javascript(guest)}\");")

  end

  def add_choice_data_attributes(c)
    " data-title = #{c.choice.title}\ data-price = #{c.choice_price} "
  end
end
