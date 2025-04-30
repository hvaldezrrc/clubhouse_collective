class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, address_attributes: [ :street, :city, :postal_code, :province_id ] ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username, address_attributes: [ :street, :city, :postal_code, :province_id, :id ] ])
  end

  private

  def initialize_cart
    session[:cart] ||= []
  end
end
