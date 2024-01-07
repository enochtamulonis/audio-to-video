class ApplicationController < ActionController::Base
  before_action :current_guest_user
  
  def current_guest_user
    @current_guest_user ||= set_current_guest_user
  end

  private
  
  def set_current_guest_user
    if session[:current_guest_user_id].present?
      session[:current_guest_user_id]
    else
      session[:current_guest_user_id] = SecureRandom.hex(6)
    end
  end
end
