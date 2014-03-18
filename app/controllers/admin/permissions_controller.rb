class Admin::PermissionsController < Admin::ResourcesController
  belongs_to :user

  helper_method :all_permissions

  def create
    permission = Permission.find(params[:permission_id])
    parent.permissions << permission
    redirect_to admin_user_permissions_path(user_id: parent)
  end

  def destroy
    user_permission = UserPermission.where(user: parent, permission_id: params[:id]).first
    user_permission.destroy if user_permission.present?
    redirect_to admin_user_permissions_path(user_id: parent)
  end


  protected

  def all_permissions
    @all_permissions ||= Permission.all
  end

end