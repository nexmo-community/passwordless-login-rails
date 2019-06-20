require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PasswordlessLogin
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.




    config.x.auth.errors = {
      login_data_required: 'Your phone number is required.',
      login_pin_required: 'Invalid pin - please try again',
      session_inactive: 'Due to inactivity, your session has timed out. Please log back in to continue',
      login_required: 'You must log in before accessing that page'
    }

    # AUTH

    config.x.auth.session_expiry_secs = 60 * 60 * 24 # Sessions expire in 24 hours

    config.x.auth.messages = {
      already_logged_in: 'You are already logged in',
      pin_required: "Please enter the code you're received",
      login_welcome: 'You are now logged in. Welcome!',
      logout: 'See you soon!'
    }
    
  end
end
