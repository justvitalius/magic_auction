class Admin::AuctionsController < Admin::ResourcesController

  def update
    update!{ auctions_path }
  end

  def create
    create!{ auctions_path }
  end

  protected
  def resource_params
    [params.require(:auction).permit(:title, :expire_date, :product_id)] if params.has_key?(:auction)
  end

end