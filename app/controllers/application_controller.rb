class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= @active_session.user
  end

  def check_token
    @active_session = UserSession.find_by(auth_key: params[:auth_key])

    render status: 422, json: {
      success: false, error: 'Invalid auth key'
    } and return if @active_session.nil?

    if @active_session.expired?
      @active_session.destroy

      render status: 422, json: {
        success: false, error: 'Your session is expired, please authenticate'
      } and return
    end
  end
end
