class Coupon < ActiveRecord::Base
  validates_uniqueness_of :coupon
  validates :amount, presence: true
  validates :coupon, presence: true
  validates :discount_type, presence: true


  #coupon.expiry_date-Time.zone.now).to_i / 1.day
  def daysOut
    if(auto_expire==0)
      ((expiry_date+2.day)-Time.zone.now).to_i / 1.day
    end
  end


end
