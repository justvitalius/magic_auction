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
    create! do
      puts @auction.product.inspect
      puts @auction.product_id.inspect
      puts @auction.valid?.to_s
      puts @auction.product.try(:valid?).to_s
      puts @auction.errors.inspect
      admin_auctions_path
    end
  end

  protected
  def resource_params
    if params.has_key?(:auction)
      if params[:auction].has_key?(:product_id) && !params[:auction][:product_id].empty?
        [params.require(:auction).permit(:title, :expire_date, :product_id)]
      else
        [params.require(:auction).permit(
             :title, :expire_date, :product_id,
             product_attributes: [:title, :description, :price, :category_id, :_destroy,
                              images_attributes: ['id', 'image', 'image_cache', 'product_id', '_destroy']]
         )]
      end
    end
  end

end