class User::FindForAuthenticate
  class << self
    def call(params)
      user = User.find_by(login: params[:login])

      if user && user.password_hash == Digest::MD5.hexdigest(params[:password])
        return user
      else
        return nil
      end
    end
  end
end
