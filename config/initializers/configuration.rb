#Replace everything below with your own info

#Initialize Configurations
  raw_config = File.read("#{Rails.root}/config/configuration.yml")
  APP_CONFIG = YAML.load(raw_config)


module TheCityEvents

  THE_CITY_APP_ID = APP_CONFIG[Rails.env]["THE_CITY_APP_ID"]
  THE_CITY_SECRET = APP_CONFIG[Rails.env]["THE_CITY_SECRET"]
  FOXY_API_KEY = APP_CONFIG[Rails.env]["FOXY_API_KEY"]
  FOXY_CART_URL = APP_CONFIG[Rails.env]["FOXY_CART_URL"]

  # Configure City Admin API
  THECITY_KEY = APP_CONFIG[Rails.env]["AdminApi_THECITY_KEY"]
  THECITY_TOKEN = APP_CONFIG[Rails.env]["AdminApi_THECITY_TOKEN"]


end

  TheCity::AdminApi.connect(TheCityEvents::THECITY_KEY, TheCityEvents::THECITY_TOKEN)


# Configure OmniAuth
Rails.application.config.middleware.use OmniAuth::Builder do

  APPID = APP_CONFIG[Rails.env]["THE_CITY_APP_ID"]
  SECRET= APP_CONFIG[Rails.env]["THE_CITY_SECRET"]

  provider :thecity, APPID, SECRET,
           :scope => 'user_basic user_extended',
           :subdomain => '2rc',
           :client_options =>{:ssl => {:ca_file =>"#{Rails.root}/private/cert.pem"}}

end





