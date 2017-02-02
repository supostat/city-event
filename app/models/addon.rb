class Addon < ActiveRecord::Base
  belongs_to :event
  has_many :choices,:dependent => :destroy
  accepts_nested_attributes_for :choices , :reject_if => lambda { |a| a[:title].blank? },:allow_destroy => true
  validates_presence_of :addon_type
end
