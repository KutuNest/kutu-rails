class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_account
  before_action :force_complete_registration

  before_action :protect_staging

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_member_session_path
  end

  protected
  def protect_staging
    authenticate_or_request_with_http_basic do |username, password|
      username == "play" && password == "kutu"
    end  
  end

  def set_current_account
    if member_signed_in?
      if params[:acc].present?
        @current_account = current_member.accounts.where(name: params[:acc]).first
      else
        @current_account = current_member.accounts.first
      end  
    end
  end

  def configure_permitted_parameters
    sign_up_attrs = [:username, :email, :password, :password_confirmation, :remember_me, :referrer_code]
    edit_attrs = [:username, :email, :password, :password_confirmation, :first_name, :last_name, :phone_number, :account_holder_name, :account_number, :bank_id, :sms_notification, :email_notification]
    devise_parameter_sanitizer.permit :sign_up, keys: sign_up_attrs
    devise_parameter_sanitizer.permit :account_update, keys: edit_attrs
  end

  def force_complete_registration
  	if member_signed_in? and !current_member.bank_info_completed?
      if !devise_controller? and !update_member_path?
  		  redirect_to complete_member_path(current_member)
      end
  	end
  end

  def update_member_path?
  	#TODO: separate with general account update
  	(params[:controller] == 'member' and params[:action] == 'update') or (params[:controller] == 'member' and params[:action] == 'complete')
  end

end
