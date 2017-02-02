class RegistrationGuest < ActiveRecord::Base
  belongs_to :registration
  belongs_to :city_user

  attr_accessor :coming

  has_many :registration_addons , :dependent => :destroy
  accepts_nested_attributes_for :registration_addons ,:allow_destroy => true

  validates_presence_of :first

  def guest_name
    if self.city_user_id.blank?  #Handling Non City Users Address
      "#{self.first} #{self.last} #{self.address_info}"
    else
      "<a href='http://2rc.onthecity.org/users/#{self.city_user_id}' target='_blank'> #{self.first} #{self.last} </a> #{self.address_info} ".html_safe
    end

  end

  def address_info
    if self.city_user_id.blank?  #Handling Non City Users Address
      if !self.city.blank? and  !self.state.blank?
        "(#{self.city} , #{self.state})"
      else
        "(N/A)"
      end


    else
      info =Address.find_by_city_user_id(self.city_user_id)

      unless info.blank?
        if !info.city.blank? and  !info.state.blank?
          "(#{info.city} , #{info.state})"
        else
          "(N/A)"
        end
      else
        "(N/A)"
      end




    end

  end

  def address_details
    if self.city_user_id.blank? #Handling Non City Users Address
      "#{self.address}<br> email: #{self.email} <br> #{self.primary_phone}"
    else
      info =Address.find_by_city_user_id(self.city_user_id)
      unless info.blank?
        "#{info.street}  #{info.street2}"
      end
    end

  end

end
