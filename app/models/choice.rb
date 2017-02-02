class Choice < ActiveRecord::Base
  belongs_to :addon

  #just for reporting
  has_many :registration_choices

  validates_numericality_of :price,
                            :greater_than_or_equal_to =>0,
                            :message => "invalid price"

  validates_numericality_of :range_from, :only_integer =>true,
                            :allow_blank => true,
                            :message => "invalid range_from"

  validates_numericality_of :range_to, :only_integer =>true,
                            :allow_blank => true,
                            :message => "invalid range_to"

  def full_title
    "#{title}-#{choice_price}"
  end
end
