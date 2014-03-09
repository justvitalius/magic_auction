class Admin::BaseController < ApplicationController
  before_action  :authenticate_user!
  before_action :authorize_resource


  helper_method :categories


  protected

  def categories
    @categories ||= Category.all
  end

  def authorize_resource
    authorize! :manage, :admin
  end
end