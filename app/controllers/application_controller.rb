class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do
    path = request.referer.present?? request.referer : root_path
    flash[:error] = 'У вас нет прав доступа к запрошенной странице'
    redirect_to path
  end
end
