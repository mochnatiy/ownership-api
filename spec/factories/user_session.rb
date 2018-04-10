FactoryBot.define do
  factory :user_session do
    association :user
    auth_key { Digest::SHA1.hexdigest('token') }
    expire_at { Time.zone.now + 1.day }
  end
end
