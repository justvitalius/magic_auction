class Admin::BaseController < ApplicationController
  before_filter :authorization!

  helper_method :categories


  protected
  def authorization!
    authenticate_user!
    #unless current_user.admin?
    #  redirect_to root_path, flash: {notice: 'У вас нет прав доступа к этой странице'}
    #end
  end

  def categories
    @categories ||= Category.all
  end
end