require 'openssl'
module CartEncryption
  def self.cart_input_name(name, value, code)
    "#{name.to_s}||#{OpenSSL::HMAC.hexdigest 'sha256', TheCityEvents::FOXY_API_KEY, code.to_s + name.to_s + value.to_s}"
  end
end