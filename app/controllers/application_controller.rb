class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :set_locale 
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale]= I18n.locale 
  end
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_locale
  protect_from_forgery with: :null_session
 
  # private
  # def set_locale
  #   I18n.locale = params[:locale] || I18n.default_locale
  #   Rails.application.routes.default_url_options[:locale]= I18n.locale 
  # end
  protected
    def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password,:password_confirmation, :Organization_name, :designation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :Organization_name, :Organization_ID, :Individual_ID, :level, :designation, :role) }
    end
  # def after_sign_in_path_for(resource)
 #    home_index_path 
 #  end
  
  def after_sign_in_path_for(user)
    home_index_path
    # home_index_path(:control => 'new')
  end

  def after_sign_out_path_for(user)
    root_path
  end
end
