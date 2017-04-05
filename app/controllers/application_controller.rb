class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #before_action :force_complete_registration

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_member_session_path
  end

  protected

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
