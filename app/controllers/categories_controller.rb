class CategoriesController < ResourcesController
  respond_to :html



  protected
  def resource_params
    [params.require(:category).permit(:title, :ancestry, :image)] if params.has_key?(:category)
  end

end