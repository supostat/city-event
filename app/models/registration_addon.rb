class RegistrationAddon < ActiveRecord::Base
  belongs_to :registration
  belongs_to :registration_guest
  belongs_to :addon

  before_save :update_registration

  has_many :registration_choices , :dependent => :destroy



  accepts_nested_attributes_for :registration_choices ,:allow_destroy => true

  def update_registration
    self.registration_id=Registration.last.id
  end
end
