class UserSession < ApplicationRecord
  belongs_to :user

  before_create :set_auth_key
  before_create :set_expire_at

  EXPIRE_PERIOD = 1

  def expired?
    expire_at < Time.zone.now
  end

  private

  def set_auth_key
    self.auth_key = Digest::SHA1.hexdigest(
      user.login << (Time.zone.now + 15.minutes).to_i.to_s
    )
  end

  def set_expire_at
    self.expire_at = Time.zone.now + EXPIRE_PERIOD.day
  end
end
