class SessionsController < ApplicationController

  before_action :find_user_if_present, only: [:destroy]

  def new
  end

  def create
    if params[:msisdn].blank?
      redirect_to login_url, alert: Rails.configuration.x.auth.errors[:login_data_required]
      return
    end
    session[:msisdn] = params[:msisdn] unless params[:msisdn].blank?
    user = User.find_by(msisdn: session[:msisdn]) || User.create(msisdn: session[:msisdn])
    if user.blank?
      redirect_to login_url, alert: "Something went terribly wrong. Please try again!"
      return
    end
    user.disable_active_sessions
    new_session = Session.create(user: user, is_active: true, last_used_at: Time.zone.now)
    new_session.send_pin
    redirect_to pin_url, notice: Rails.configuration.x.auth.messages[:pin_required]
  end

  def pin
    redirect_to login_url and return if session[:msisdn].blank?
    user = User.find_by(msisdn: session[:msisdn])
    if user.blank?
      session[:msisdn] = nil
      session[:token] = nil
      redirect_to login_url and return
    end
    active_session = user.active_session
    if active_session.blank?
      session[:msisdn] = nil
      session[:token] = nil
      redirect_to login_url and return
    end
  end

  def pin_verify
    redirect_to login_url and return if session[:msisdn].blank?
    user = User.find_by(msisdn: session[:msisdn])
    if user.blank?
      session[:msisdn] = nil
      redirect_to login_url and return
    end

    active_session = user.active_session
    if active_session.blank?
      session[:msisdn] = nil
      redirect_to login_url and return
    end

    if params[:pin].blank? || params[:pin] != active_session.pin
      redirect_to pin_url, alert: Rails.configuration.x.auth.errors[:login_pin_required]
      return
    end
    session[:token] = active_session.session_token
    url_to_redirect_to = session[:login_return_to] || root_url
    redirect_to url_to_redirect_to, notice: Rails.configuration.x.auth.messages[:login_welcome]
  end



  def destroy
    @current_user.disable_active_sessions unless @current_user.blank?
    session[:msisdn] = nil
    session[:token] = nil
    redirect_to login_url, notice: Rails.configuration.x.auth.messages[:logout]
  end

end
