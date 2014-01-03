class AuctionsController < ResourcesController
  respond_to :html
  actions :all, :except => [ :show ]

  def update
    update!{ products_path }
  end

  def create
    create!{ products_path }
  end

  protected
  def resource_params
    [params.require(:auction).permit(:title, :expire_date, :product_id)] if params.has_key?(:auction)
  end

end