class Admin::CategoriesController < Admin::ResourcesController

  def update
    update!{ categories_path }
  end

  def create
    create!{ categories_path }
  end

  protected
  def resource_params
    [params.require(:category).permit(:title, :parent_id, :image)] if params.has_key?(:category)
  end

end