class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :cart_count

  def authenticate_admin_user!
    authenticate_user!
    redirect_to root_path, alert: "Unauthorized Access!" unless current_user.admin?
  end

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  def cart_count
    if session[:cart].present?
      session[:cart].sum { |item| item[:quantity].to_i }
    else
      0
    end
  end

  private

  def initialize_cart
    session[:cart] ||= []
  end
end
