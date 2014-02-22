class Admin::ProductsController < Admin::ResourcesController

  def update
    update! { products_path }
  end

  def create
    create! { products_path }
  end

  protected
  def build_resource_params
    [params.fetch(:product, {}).permit(
         :title, :description, :price, :category_id,
         images_attributes: ['id', 'image', 'image_cache', 'product_id', '_destroy']
     )]
  end

end