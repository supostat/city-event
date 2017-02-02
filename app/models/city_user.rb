class CityUser < ActiveRecord::Base
  def self.pull_city_users
    if CityUser.all.count== 0

      total_pages= TheCity::UserList.new().total_pages

      if total_pages>0
        total_pages.times do |page|
          page +=1
          puts "********************* Processing Page No.  #{page} Of #{total_pages}"
          city_users_list= TheCity::UserList.new({:include_addresses => 'true', :page => page})
          city_users_list.each do |user|

            address = nil
            address = user.addresses.detect { |address| address.home_address? }
            address = user.addresses.first if address.nil?

            CityUser.create!(
                :primary_campus_id => (user.primary_campus_id unless user.primary_campus_id.blank?),
                :city_user_id => user.id,
                :first => user.first,
                :last => user.last,
                :gender => user.gender,
                :primary_campus_name => (user.primary_campus_name unless user.primary_campus_name.blank?),
                :full_name => "#{user.first} #{user.last} (#{user.id.to_s})",
                :staff  => user.staff ? user.staff : false,
                :active => user.active)

            unless address.nil?
              Address.create!(

                  :street => address.street,
                  :street2 => address.street2,
                  :zipcode => address.zipcode,
                  :city => address.city,
                  :state => address.state,
                  :location_type => address.location_type,

                  :latitude => address.latitude,
                  :longitude => address.longitude,

                  :city_address_id => address.id,
                  :city_user_id => user.id,
                  :privacy => address.privacy,
              )

            end

          end

        end
      end

    end
  end

  #Pulls all City users via the City Admin API and updates them OR adds them, as needed
  def self.update_city_users
    TheCity::AdminApi.connect(TheCityEvents::THECITY_KEY, TheCityEvents::THECITY_TOKEN)

    total_pages= TheCity::UserList.new().total_pages
    total_dups =  0

    if total_pages>0
      total_pages.times do |page|
        page +=1
        puts "********************* Processing Page No.  #{page} Of #{total_pages}"
        city_users_list= TheCity::UserList.new({:include_addresses => 'false', :page => page})
        city_users_list.each do |user|

          if user.primary_phone_type == 'Mobile'
            @phone = user.primary_phone
          elsif user.secondary_phone_type == 'Mobile'
            @phone = user.secondary_phone
          else
            @phone = nil
          end

          existing_city_users = CityUser.find_all_by_city_user_id(user.id)

          if existing_city_users.count == 0
            puts "Going to add #{user.first} #{user.last}"

            CityUser.create!(
                :primary_campus_id => (user.primary_campus_id unless user.primary_campus_id.blank?),
                :city_user_id => user.id,
                :first => user.first,
                :last => user.last,
                :gender => user.gender,
                :primary_campus_name => (user.primary_campus_name unless user.primary_campus_name.blank?),
                :full_name => "#{user.first} #{user.last} (#{user.id.to_s})",
                :staff  => user.staff,
                :email => user.email,
                :active => user.active)
          else

            # Keep this, since it's already loaded
            city_user = existing_city_users[0]

            # If we have duplicates, we'll delete all but the first item in the array. The users table 
            # references city_user_id anyways so it won't be a problem
            if existing_city_users.count > 1
              total_dups += 1
              name = "#{user.first} #{user.last}"
              puts "IMPORTANT: We have duplicate users for #{name} (#{user.id}). Fixing..."
              ids_to_delete = existing_city_users.drop(1).map(&:id)
              CityUser.where(id: ids_to_delete).destroy_all

              # Make sure any family members that have matched a duplicate city user id 
              # that we've removed (due to it being a duplicate) is updated to reference
              # the single existing city user id.
              FamilyMember.where(city_user_id: ids_to_delete).update_all(city_user_id: city_user.city_user_id)
            end

            puts "Going to update #{user.first} #{user.last} (if needed)"

            local_city_user = city_user
            local_city_user.primary_campus_id = user.primary_campus_id unless user.primary_campus_id.blank?
            local_city_user.city_user_id = user.id
            local_city_user.first = user.first
            local_city_user.last = user.last
            local_city_user.gender = user.gender
            local_city_user.primary_campus_name = (user.primary_campus_name unless user.primary_campus_name.blank?)
            local_city_user.full_name = "#{user.first} #{user.last} (#{user.id.to_s})"
            local_city_user.staff  = user.staff
            local_city_user.email = user.email
            local_city_user.active = user.active

            local_city_user.save

          end
        end
      end
    end
  end

end
