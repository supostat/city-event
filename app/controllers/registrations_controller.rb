require 'cart_encryption'
class RegistrationsController < ApplicationController
  include CartEncryption
  include FoxySync
  before_filter :require_login

  def destroy

    registration = Registration.find(params[:id])

    if(registration.amount_paid == 0)
      registration.destroy
    end
      return redirect_to params[:redirect], notice: 'Registration was successfully deleted.'

    rescue ActionController::RedirectBackError
      return redirect_to root_path, notice: 'Registration was successfully deleted.'

  end

  def show
    @registration = Registration.find(params[:id])
  end

  def summary
    @registration = Registration.find(params[:id])
  end

  def verify_coupon

    @registration = Registration.find(params[:registration])

    coupon = params[:coupon]
    payable_amount = params[:amount]

    #Find auto generated coupons
    coupon_check = Coupon.find_by_coupon_and_redeemed_and_auto_expire(coupon, nil,1)
    if coupon_check.nil?
      #Is a custom coupon code, expire on date
      coupon_check = Coupon.find_by_coupon_and_auto_expire(coupon,0)
      if coupon_check.nil?
        @message = 'Invalid coupon code was entered, no discount applied!'
        @discount_amount = -1
        return :js
      end

      daysOut = ((coupon_check.expiry_date+2.day)-Time.zone.now).to_i / 1.day

      if daysOut>0
        if coupon_check.nil?
          @message = 'Invalid coupon code was entered, no discount applied'
          @discount_amount = -1
          return :js
        else
          if coupon_check.discount_type == 'Percent'
            @discount_amount = sprintf '%.2f', payable_amount.to_f - (coupon_check.amount.to_f/100 * payable_amount.to_f)

            if @discount_amount.to_f <= 0.00
              @discount_amount = "0.00"
              params[:coupon_redeem] = params[:coupon]
              redeem_coupon
            else
              @message = "Discount Applied"
            end

            @code_string = "#{@registration.id}_#{current_user.id}_#{coupon}"
            #generate the hash for price field if discount is applied
            @field_name = CartEncryption::cart_input_name('name', @registration.event.title, @code_string)
            @field_price = CartEncryption::cart_input_name('price', @discount_amount, @code_string)
            @field_code = CartEncryption::cart_input_name('code', @code_string, @code_string)

          elsif coupon_check.discount_type == 'Fixed'

            @discount_amount = sprintf '%.2f', (payable_amount.to_f - coupon_check.amount.to_f).round(2)

            if @discount_amount.to_f <= 0.00
              @discount_amount = "0.00"
              params[:coupon_redeem] = params[:coupon]
              redeem_coupon
            else
              @message = "Discount Applied"
            end

            @code_string = "#{@registration.id}_#{current_user.id}_#{coupon}"
            #generate the hash for price field if discount is applied
            @field_name = CartEncryption::cart_input_name('name', @registration.event.title, @code_string)
            @field_price = CartEncryption::cart_input_name('price', @discount_amount, @code_string)
            @field_code = CartEncryption::cart_input_name('code', @code_string, @code_string)


          end
        end
      else
        @message = 'Sorry! coupon has been expired, no discount applied'
        @discount_amount = -1
      end

    end


    respond_to do |format|
      format.js {}
    end
  end

  def redeem_coupon

    @registration = Registration.find(params[:registration])
    payable_amount = @registration.amount_payable
    puts "DEBUG payable_amount is #{payable_amount}"
    if (@registration.amount_paid<payable_amount)
      coupon=params[:coupon_redeem]
      puts "DEBUG Coupon is #{coupon}"
      coupon_check = Coupon.find_by_coupon_and_redeemed_and_auto_expire(coupon, nil,1)
      if coupon_check.nil?
        #Is a custom coupon code, expire on date
        coupon_check = Coupon.find_by_coupon_and_auto_expire(coupon,0)
        if !coupon_check.nil?
          daysOut = ((coupon_check.expiry_date+2.day)-Time.zone.now).to_i / 1.day
          if !(daysOut>0)
            @message = 'Coupon has been expired or invalid'
            return
          end
        end
      end

      discount_amount=0

      if coupon_check.nil?
        @message = 'Coupon already redeemed or invalid'
        #TODO     ???
      else
        if coupon_check.discount_type == 'Percent'
          puts "DEBUG percentage discount type"
          discount_amount = coupon_check.amount/100 * payable_amount
          puts "DEBUG coupon_check is #{coupon_check}"
          puts "DEBUG coupon_check.amount is #{coupon_check.amount}"
          puts "DEBUG discount_amount is #{discount_amount}"
        elsif coupon_check.discount_type == 'Fixed'
          puts "DEBUG fixed coupon type"
          if  coupon_check.amount <= payable_amount.to_f
            discount_amount = coupon_check.amount
            puts "DEBUG discount_amount is #{discount_amount}"
          else
            @message = 'Coupon amount is more then amount payable'
            puts 'DEBUG Coupon amount is more then amount payable'
            discount_amount = payable_amount.to_f
            #TODO     ???
          end
        end

        order_total =payable_amount-discount_amount

        puts "DEBUG discount_amount is #{discount_amount}, payable_amount is #{payable_amount} new total is #{order_total}"

        Payment.create(
            :customer_first_name => current_user.first,
            :customer_last_name => current_user.last,
            :customer_email => current_user.email,
            :registration_id => @registration.id,
            :user_id => current_user.id,
            :coupon => coupon,
            :order_total => order_total
        )

        @registration.update :coupon =>params[:coupon]
        @registration.update :coupon_amount => discount_amount
        @registration.update :amount_payable => order_total

        if (coupon)
          if(coupon_check.auto_expire==1)
            coupon_check.update :redeemed => 'Yes'
          end
        end

        @message = "Success"

      end
    else
      @message=  "Hurray somebody already paid for it"
    end


  end

end
