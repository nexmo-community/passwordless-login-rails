require 'nexmo'

class Session < ApplicationRecord
  belongs_to :user

  scope :active, -> { where('is_active = ? AND last_used_at >= ?', true, Rails.configuration.x.auth.session_expiry_secs.seconds.ago).order('last_used_at DESC') }
  scope :inactive, -> { where('is_active = ? OR last_used_at < ?', false, Rails.configuration.x.auth.session_expiry_secs.seconds.ago) }
  scope :expired, -> { where('last_used_at < ?', Rails.configuration.x.auth.session_expiry_secs.seconds.ago) }

  before_validation :generate_token
  def generate_token
    self.pin = ReadableToken.generate if pin.blank?
    self.session_token = SecureRandom.uuid if session_token.blank?
  end



  # PROPERTIES
  def expired?
    !is_active || !last_used_at || (last_used_at < Rails.configuration.x.auth.session_expiry_secs.seconds.ago)
  end

  # OPERATIONS

  def send_pin
    return if Rails.env.test?
    client = Nexmo::Client.new(api_key: ENV["NEXMO_API_KEY"], api_secret: ENV["NEXMO_API_SECRET"])
    puts "Your login code is: #{self.pin}"
    response = client.sms.send(from: "PwdLess", to: self.user.msisdn, text: "Your login code is: #{self.pin}")
    # puts response.error_text
    return response.messages.first.status == '0'
  end


  def update_usage
    update(last_used_at: Time.zone.now)
  end

  def deactivate!
    update(is_active: false)
  end

end
