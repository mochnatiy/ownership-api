FactoryBot.define do
  factory :user do
    login 'johnsmith'
    password_hash { Digest::MD5.hexdigest('password') }
    password 'password'
  end
end
