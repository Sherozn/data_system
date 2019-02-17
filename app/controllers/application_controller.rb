class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def check_login
	  @current_user ||= cookies[:auth_token] && Account.find_by(auth_token:cookies[:auth_token])
  end
  # helper_method :check_login
end
