class ApplicationController < ActionController::Base

  def find_user_if_present
    @current_session = Session.find_by(session_token: session[:token]) if session[:token]
    @current_user = @current_session.user unless @current_session
  end
  
  def authenticate_user!
    @current_session = Session.find_by(session_token: session[:token]) if session[:token]
    unless @current_session && @current_session.user
      session[:token] = nil
      session[:login_return_to] = request.fullpath
      redirect_to login_path, alert: Rails.configuration.x.auth.errors[:login_required]
      return
    end
    if @current_session.expired?
      @current_session.deactivate!
      session[:token] = nil
      session[:login_return_to] = request.fullpath
      redirect_to login_path, alert: Rails.configuration.x.auth.errors[:session_inactive]
    end
    @current_session.update_usage
    @current_user = @current_session.user
  end

end
