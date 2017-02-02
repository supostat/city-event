require 'base64'
require 'openssl'
require 'uri'

module RcAuth
	def self.decrypt_city_data(city_data, city_data_iv, secret)
		if !city_data.nil?
			string_to_decrypt = Base64.urlsafe_decode64(city_data)
			iv = Base64.urlsafe_decode64(city_data_iv)
			return city_decrypt(string_to_decrypt, secret, iv)
		else
			return {}
		end
	end

	def self.city_decrypt(encrypted_data, key, iv, cipher_type = "AES-256-CBC")
		aes = OpenSSL::Cipher::Cipher.new(cipher_type)
		aes.decrypt
		aes.key = key
		aes.iv = iv if iv != nil
		aes.update(encrypted_data) + aes.final
	end
end
