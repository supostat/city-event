require File.expand_path('../boot', __FILE__)

require 'csv'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module TheCityEvents

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    #not working
    #config.action_dispatch.default_headers[:'X-Frame-Options'] = "ALLOW-FROM https://2rc.onthecity.org/"

    config.time_zone = 'Eastern Time (US & Canada)'
    config.middleware.insert_before ActionDispatch::Session::CookieStore, Rack::P3p

  end
end


