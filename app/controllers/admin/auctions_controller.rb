class Admin::AuctionsController < Admin::ResourcesController

  def new
    @products = Product.all
    new!
  end

  def edit
    @products = Product.all
    edit!
  end

  def update
    update!{ admin_auctions_path }
  end

  def create
    create!{ admin_auctions_path }
  end

  protected
  def resource_params
    if params.has_key?(:auction)
      if params[:auction].has_key?(:product_id)
        [params.require(:auction).permit(:title, :expire_date, :product_id)]
      else
        [params.require(:auction).permit(
             :title, :expire_date,
             product_params: [:title, :description, :price, :category_id,
                              images_attributes: ['id', 'image', 'image_cache', 'product_id', '_destroy']]
         )]
      end
    end
  end

end