class HomeController < ApplicationController
  def index
    redirect_to dashboard_path if member_signed_in?
  end

  def setting
    @member = current_member
  end

  def support
  end

end
