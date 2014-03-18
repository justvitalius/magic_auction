class Admin::BaseController < ApplicationController
  before_action  :authenticate_user!

  # используем либо первый либо второй метод.
  # первый если кастомное имя защиты.
  # второй если просто включем общий cancan
  #before_action :authorize_resource
  authorize_resource


  helper_method :categories


  protected

  def categories
    @categories ||= Category.all
  end

  def authorize_resource
    authorize! :manage, :admin
  end
end