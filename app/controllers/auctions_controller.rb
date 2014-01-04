class AuctionsController < ResourcesController
  respond_to :html
  actions :all, :except => [ :show ]

  before_filter :authenticate_user!

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