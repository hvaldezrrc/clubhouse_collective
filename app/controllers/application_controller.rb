class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def authenticate_admin_user!
    authenticate_user!
    redirect_to root_path, alert: "Unauthorized Access!" unless current_user.admin?
  end

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end
end
