class Admin::CouponsController < ApplicationController

  def index
    @coupons = Coupon.all
  end

  def create
    if params[:coupon].blank?
        params[:no_of_coupons].to_i.times do |n|
        random_number = (0...4).map { (65 + rand(26)).chr }.join
        Coupon.create(discount_type: params[:discount_type],amount: params[:amount],coupon: random_number,auto_expire: 1)
        end
    else
      if !params[:coupon].blank?
        Coupon.create(discount_type: params[:discount_type],amount: params[:amount],coupon: params[:coupon],expiry_date: params[:expiry_date],auto_expire: 0)
      end
    end
    @coupons = Coupon.all
    render action: 'index'
  end
end