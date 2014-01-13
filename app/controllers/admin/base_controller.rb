class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!

  helper_method :categories

  def categories
    @categories ||= Category.all
  end
end