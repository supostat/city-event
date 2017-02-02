module AddonsHelper
  def addon_choices_dropdown(addon_form, a)
    begin
      if a.registration_choices.first
        c=a.registration_choices.first
        htmlOutput=''
        addon_form.simple_fields_for "registration_choices_attributes[#{c.choice.id}]", c do |choice_form|
          htmlOutput+=choice_form.hidden_field :choice_id
          htmlOutput+=choice_form.hidden_field :choice_value, :value => "0"
          htmlOutput+=choice_form.hidden_field :choice_price
        end
        return htmlOutput.html_safe
      end
    rescue Exception => exc
      display_error('100', exc)
    end
  end

  def addon_choices_checkbox(addon_form, a)
    begin
      htmlOutput = '<ul data-control-type="check-box">'

        a.registration_choices.each do |c|
          htmlOutput += addon_form.hidden_field :addon_value, label: false


          addon_form.simple_fields_for "registration_choices_attributes[#{c.choice.id}]", c do |choice_form|
            htmlOutput +='<li class="grid-12-12">'
            htmlOutput += choice_form.input :choice_value, as: :boolean, input_html: {class: 'price-option',
                                                                                      :"control-type" => "checkbox",
                                                                                      :"data-type" => "choice_#{c.choice.id}",
                                                                                      :"data-value" => "1",
                                                                                      :"data-title" => c.choice.title,
                                                                                      :"data-price" => c.choice_price

            }, label: "#{c.choice.title } #{ c.choice.price > 0 ? ' - $%.2f' % c.choice.price : '' }", checked: :false
            htmlOutput += '</li>'
            htmlOutput += choice_form.input :choice_price, as: :hidden
            htmlOutput += choice_form.hidden_field :choice_id
          end
        end

      htmlOutput += '</ul>'
      return htmlOutput.html_safe
    rescue Exception => exc
      display_error('101', exc)
    end
  end

  def addon_choices_scale(addon_form, a)
    begin
      htmlOutput = '<ul data-control-type="scale">'
        a.registration_choices.each do |c|
          htmlOutput += addon_form.hidden_field :addon_value, label: false
          addon_form.simple_fields_for "registration_choices_attributes[#{c.choice.id}]", c do |choice_form|
            htmlOutput += '<li class="grid-12-12" >'
            include_blank = false
            if c.choice.range_from and c.choice.range_to
              if c.choice.range_from !=0
                include_blank="0"
              end
              range=c.choice.range_from..c.choice.range_to
            else
              range=[0]
            end

            htmlOutput += choice_form.input :choice_value, collection: (range).map { |a| [a, a, {"data-title" => c.choice.title}, {"data-price" => c.choice_price}, {:"data-value" => a}] }, input_html: {class: 'price-option', :"data-type" => "choice_#{c.choice.id}", :"control-type" => "dropdown"}, :include_blank => include_blank, label: "#{c.choice.title} – #{c.choice.price > 0 ? '$%.2f' % c.choice.price : '' }"
            htmlOutput +='</li>'
            htmlOutput += choice_form.input :choice_price, as: :hidden
            htmlOutput += choice_form.hidden_field :choice_id
          end
        end


      htmlOutput += '</ul>'
      return htmlOutput.html_safe
    rescue Exception => exc
      display_error('102', exc)
    end
  end

  def display_error(error_code, exc)
    "<br><div class='clear prettyprint'>An unhandled exception has occurred #{exc} Error code : #{error_code} </div>".html_safe
  end

end