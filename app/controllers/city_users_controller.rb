class CityUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token , :require_login

  #autocomplete_for :city_user, :full_name

 #John Smith: email@*******.com | ***-***-2285
  autocomplete_for :city_user, :full_name, :query_proc => Proc.new { |q| "LOWER(%{field}) LIKE '%%%%#{q.gsub(' ','%%%%')}%%%%'"} do |items| 
    items.map{|item|
      "#{item.first} #{item.last} : #{item.email? ? item.email.gsub!(/@.{4}/, '@****') : 'email@*******.com'} (#{item.city_user_id})"
    }.join("\n")
  end

end
