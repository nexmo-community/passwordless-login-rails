class User < ApplicationRecord
  has_many :sessions

  validates :msisdn, presence: { message: 'is required' }, length: { maximum: 20 }, uniqueness: true

  def disable_active_sessions
    self.sessions.active.each do |session|
      session.deactivate!
    end
  end

  def active_session
    return self.sessions.active.last
  end

end
