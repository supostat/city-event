class DatafeedsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_filter :verify_authenticity_token, :require_login

  def parsefeed
    require 'rc4'
    require 'nokogiri'

    api_key = TheCityEvents::FOXY_API_KEY

    decryptor = RC4.new(api_key)
    xml = decryptor.decrypt(CGI::unescape(params['FoxyData']))

    feed = Nokogiri::XML(xml)


    transaction  =feed.xpath('.//transaction')

    product_code = transaction.xpath('.//product_code').text

    prod_array = product_code.split('_')


    registration_id = prod_array[0]

    user_id = prod_array[1]

    if (prod_array[1])
      coupon = prod_array[2]
    else
      coupon = ''
    end



    Payment.create(:customer_first_name => transaction.xpath('.//customer_first_name').text,
                   :customer_last_name => transaction.xpath('.//customer_last_name').text,
                   :customer_address1 => transaction.xpath('.//customer_address1').text,
                   :customer_address2 => transaction.xpath('.//customer_address2').text,
                   :customer_city => transaction.xpath('.//customer_city').text,
                   :customer_state => transaction.xpath('.//customer_state').text,
                   :customer_postal_code => transaction.xpath('.//customer_postal_code').text,
                   :customer_country => transaction.xpath('.//customer_country').text,
                   :customer_phone => transaction.xpath('.//customer_phone').text,
                   :customer_email => transaction.xpath('.//customer_email').text,
                   :registration_id => registration_id,
                   :user_id => user_id,
                   :coupon => coupon,
                   :order_total => transaction.xpath('.//order_total').text)


    amount_paid = transaction.xpath('.//order_total').text

    registration = Registration.find(registration_id)

    if (coupon)

      coupon = Coupon.find_by_coupon(coupon)

      if coupon.discount_type == 'Percent'
        discount_amount = coupon.amount/100 * registration.amount_payable
      elsif coupon.discount_type == 'Fixed'
        if  coupon.amount <= registration.amount_payable.to_f
          discount_amount = coupon.amount
          puts "DEBUG discount_amount is #{discount_amount}"
        else
          puts 'DEBUG Coupon amount is more then amount payable'
          discount_amount = registration.amount_payable.to_f
          #TODO     ???
        end
      end

      registration.update :coupon => coupon.coupon
      registration.update :coupon_amount => discount_amount

      coupon.update :redeemed => 'Yes'
    end

    registration.update :amount_paid => amount_paid.to_f
    registration.update :amount_payable => registration.amount_payable - discount_amount

    #debug feed
    #path_to_file = 'public/feed.xml'
    #File.delete(path_to_file) if File.exist?(path_to_file)

    #s = render_to_string :xml => feed
    #File.open(path_to_file, 'w') { |f| f.write s }

    #render :text => 'success:'+product_code

  rescue Exception => e
    render :text => e.to_s

  end
end
