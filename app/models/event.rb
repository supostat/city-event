class Event < ActiveRecord::Base

  has_many :addons , :dependent => :destroy
  has_one :registration
  has_many :registrations

  accepts_nested_attributes_for :addons , :reject_if => lambda { |a| a[:title].blank? },:allow_destroy => true
  validates_presence_of :title, :start_date, :end_date, :start_time, :end_time, :base_price, :max_price, :seats

  validates_numericality_of :base_price,
                            :greater_than_or_equal_to =>0,
                            :message => "invalid base price"

  validates_numericality_of :max_price,
                            :greater_than_or_equal_to =>0,
                            :message => "invalid max price"

  validates_numericality_of :seats, :only_integer =>true,
                            :greater_than_or_equal_to =>0,
                            :message => "invalid seats"
  attr_accessor :status

  scope :all, where('archive = ?', :false)

  scope :archived, where('archive = ?', :true)


  def status(current_user)
   if(current_user.nil?)
     "new"
   else
     registration =Registration.find_by_user_id_and_event_id(current_user.id,self.id)
     if(registration)
       if registration.amount_paid >= registration.amount_payable
         "registered"
       elsif registration.amount_paid < registration.amount_payable
         "pending"
       end
     else
       "new"
     end
   end

  end

  #def exportCSV(options = {})
  #
  #  registrations =self.registrations.where("amount_paid=amount_payable")
  #
  #  CSV.generate(options) do |csv|
  #   # csv << ['date','registration','guests']
  #   registrations.each do |r|
  #     #registration
  #     row =[r.created_at.strftime("%m/%d/%Y"),r.user.user_name]
  #     #guests
  #     r.registration_guests.each do  |guest|
  #       row += [guest.first,guest.last,guest.address.blank? ? '-' : guest.address,guest.city.blank? ? '-' : guest.city,guest.state.blank? ? '-' : guest.state]
  #     end
  #     #addons
  #     r.registration_addons.each do |addon|
  #       row += [getTitle(addon, false)]
  #     end
  #
  #     csv << row
  #   end
  #
  #
  #
  #  end
  #
  #end

  def exportCSV(options = {})
    event = self
    registrations =event.registrations.where("amount_paid=amount_payable")

    CSV.generate(options) do |csv|
       #Header
       csv << ['Date','Registration','Coupon','Total']+addons_headings(event, true)+['Guests']+addons_headings(event, false) #+['Guest Total']
       registrations.each do |r|
         #Date and registration Field
         row =[r.created_at.strftime("%m/%d/%Y"),r.user.user_name,r.coupon==''? ' ' : r.coupon+'('+"$%.2f" % r.coupon_amount+')',"$%.2f" % r.amount_payable]
         #addon values for registration specific Fields
         row += registration_specific_choices(event, r)


         #add guests
         price =0.00
         r.registration_guests.each.with_index do |guest,index|
           #addons place holders for registrant specific Fields
           row2 =[]
           if(index>0)
             row2 +=[' ',' ',' ',' ']
             row2 += addons_headings_placeholder(event, true)
           end
           row2  +=[guest.first+' '+guest.last]
           event.addons.where(:registration_type => false).each do |a|
               addon =guest.registration_addons.where(:addon_id => a.id).first
               if addon
                 row2.push(getTitle(addon, false))
               else
                 row2.push(' ')
               end
           end

           #Guest Total
           #a = RegistrationAddon.where(:registration_guest_id => guest.id).joins(:registration_choices).sum("choice_value*choice_price")
           #row2.push( a>0 ? "$ %.2f" % a : ' ')

           if(index==0)
             #First Row
             csv << row+row2
           else
             csv << row2
           end

         end


       end


    end

  end

  def addons_headings(event, state)
    result =[]
    event.addons.where(:registration_type => state).each do |a|
      result.push(a.title)
    end
    result
  end

  def addons_headings_placeholder(event, state)
    result =[]
    event.addons.where(:registration_type => state).each do |a|
      result.push('')
    end
    result
  end

  def registration_specific_choices(event, r)
    choices=[]
    event.addons.where(:registration_type => true).each do |a|
      addon =r.registration_addons.where(:addon_id => a.id).first
      choices.push(getTitle(addon, false))
    end
    choices
  end





  def getTitle(a, empty)

    case a.addon.addon_type
      when "Addons::Text"
        a.addon_value=='' ? ' ' : a.addon_value
      when "Addons::Dropdown"
        a.addon_value=='' ? ' ' : Choice.find_by_id(a.addon_value) ? Choice.find_by_id(a.addon_value).title : ' '
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
          empty ? "" : " "
        end
      else
        a.addon.addon_type
    end
  end
end
