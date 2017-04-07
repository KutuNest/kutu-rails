class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #before_action :force_complete_registration

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_member_session_path
  end

  protected
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me, :referrer_code]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def force_complete_registration
  	if member_signed_in? and !current_member.bank_information_completed? and !devise_controller? and !update_member_path?
  		redirect_to complete_member_path
  	end
  end

  def update_member_path?
  	#TODO: separate with general account update
  	(params[:controller] == 'member' and params[:action] == 'update') or (params[:controller] == 'member' and params[:action] == 'complete')
  end

end
