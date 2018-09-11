class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: Proc.new {|c| c.request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  def after_sign_in_path_for(resource)
  	if current_user.is_admin?
    	admin_dashboard_path || root_path
  	else
  		stored_location_for(resource) || super
  	end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:photo])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name,:photo])
  end
end
