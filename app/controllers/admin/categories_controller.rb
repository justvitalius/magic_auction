class Admin::CategoriesController < Admin::ResourcesController

  def update
    update!{ categories_path }
  end

  def create
    create!{ categories_path }
  end

  protected
  def build_resource_params
    [params.fetch(:widget, {}).permit(
         :title, :parent_id, :image
     )]
  end

end