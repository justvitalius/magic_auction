class Admin::UsersController < Admin::ResourcesController

  def update
    update! { users_path }
  end

  def create
    create! { users_path }
  end

  protected
  def build_resource_params
    [params.fetch(:user, {}).permit(:email)]
  end

end