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
    # в before_filter для create и update
    # if resource_params[:product_id].present?
    # pr = Product.find(resource_params[:product_id])
    # resource.product = pr
    # resource_params.delete(:product_attributes) очистить.
    create! do
      admin_auctions_path
    end
  end

  protected
  # TODO: как вот эти страшные проверки убрать. Тут бывает приходит предмет,а бывает не приходит и как бы это зарефакторить
  def resource_params
    if params.has_key?(:auction)
      if params[:auction].has_key?(:product_id) && !params[:auction][:product_id].empty?
        [params.require(:auction).permit(:title, :expire_date, :start_date, :product_id)]
      else
        # оставить только этот самый большой вариант
        [params.require(:auction).permit(
             :title, :expire_date, :start_date, :product_id,
             product_attributes: [:title, :description, :price, :category_id, :_destroy,
                              images_attributes: ['id', 'image', 'image_cache', 'product_id', '_destroy']]
         )]
      end
    end
  end

  # Need refactoring
  #def build_resource_params
  #  if params[:auction].has_key?(:product_id) && !params[:auction][:product_id].empty?
  #    [params.fetch(:auction, {}).permit(
  #         :title, :expire_date, :start_date, :product_id
  #     )]
  #  else
  #    [params.fetch(:auction, {}).permit(
  #         :title, :expire_date, :start_date, :product_id,
  #         product_attributes: [:title, :description, :price, :category_id, :_destroy,
  #                              images_attributes: ['id', 'image', 'image_cache', 'product_id', '_destroy']]
  #     )]
  #  end
  #end

end