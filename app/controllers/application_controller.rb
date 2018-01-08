class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :current_user_from_api?

  def current_user_from_api?
    request.headers["API"].present?
  end
end
