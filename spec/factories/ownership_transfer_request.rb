FactoryBot.define do
  factory :ownership_transfer_request do
    association :initiator
    association :recipient
    association :property
    requested_at { Time.zone.now - 1.day }
    transfer_key { Digest::SHA1.hexdigest('key') }
  end
end
