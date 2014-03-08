class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_resource

  def show
    @user = current_user
  end

  private

  def authorize_resource
    authorize! :manage, :profile
  end
end