class Registration < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  attr_accessor :family_members
  attr_accessor :city_users

  attr_accessor :selected_family_members
  attr_accessor :person

  validates_presence_of :event_id


  has_many :registration_addons , :dependent => :destroy

  #just for reporting
  has_many :registration_choices, :through => :registration_addons



  accepts_nested_attributes_for :registration_addons ,:allow_destroy => true

  has_many :registration_guests , :dependent => :destroy
  accepts_nested_attributes_for :registration_guests ,:reject_if => lambda { |a| a[:coming].nil? },:allow_destroy => true



  def summary
   sql= "SELECT choices.title,sum(registration_choices.choice_value*registration_choices.choice_price)
    FROM registration_choices
    INNER JOIN choices ON (registration_choices.choice_id=choices.id)
    INNER JOIN registration_addons ON (registration_addons.id=registration_choices.registration_addon_id)
    WHERE registration_addons.registration_id=#{self.id}
    Group By choices.title,choices.created_at
    HAVING sum(registration_choices.choice_value*registration_choices.choice_price) > 0
    Order by choices.created_at
   "
   #puts sql
   ActiveRecord::Base.connection.select_all sql
  end
end
