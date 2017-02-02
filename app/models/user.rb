class User < ActiveRecord::Base
  has_many :family_members
  has_many :registrations
  has_many :events, :through => :registrations

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.token = auth["credentials"]["token"]

      user.gender = auth["info"]["global_user"]["gender"]
      user.global_user_id = auth["info"]["global_user"]["id"]

      user.first = auth["info"]["user"]["first"]
      user.last = auth["info"]["user"]["last"]
      user.email = auth["info"]["user"]["email"]
      user.user_id = auth["info"]["user"]["id"]
      user.account_id = auth["info"]["user"]["account_id"]
      user.profile_picture =auth["info"]["user"]["profile_picture"]
      user.staff = auth["info"]["user"]["staff"]

    end

  end

  def self.create_with_token(data,me)

    create! do |user|

      user.token = data['oauth_token']
      user.account_id = data['account_id']
      user.global_user_id = data['global_user_id']
      user.user_id = data['user_id']
      user.subdomain = data['subdomain']

      user.first = me.first
      user.last = me.last
      user.email = me.email
      user.gender = me.gender
      user.staff = me.staff
      user.profile_picture = ''

    end

  end

  def self.create_with_city_user(city_user)

    create! do |user|

      user.user_id = city_user.city_user_id

      user.first = city_user.first
      user.last = city_user.last
      user.email = city_user.email
      user.gender = city_user.gender
      user.staff = city_user.staff
      user.profile_picture = ''

    end

  end

  def find_by_full_name(q)
    self.where("concat(first,' ',last,' ','(',user_id,')') = ?", "#{q}")
  end

  # Returns true if the user has paid for the vent
  def has_paid_registration?(registration_id)
    Payment.where(
        user_id: self.id,
        registration_id: registration_id
    ).any?
  end

  def has_already_registered?(event_id)
    self.registrations.find_by(event_id: event_id).present?
  end

  def user_name
    [first,last].join(' ')
  end
end
