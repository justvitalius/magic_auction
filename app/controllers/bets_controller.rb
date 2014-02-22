class BetsController < ApplicationController
  def create
    # not working with comet
    #unless current_user
    #  redirect_to root_path, notice: 'зарегистрируйтесь, чтобы сделать ставку'
    #  return
    #end

    auction = Auction.find(params[:auction_id])
    @bet = Bet.new(user: current_user, auction: auction)
    if @bet.save!
      respond_to do |format|
        format.html { redirect_to :back, notice: 'ставка сделана' }
        format.js {
          PrivatePub.publish_to '/auctions/updates', auction_id: @bet.auction.id, auction_finish_date: @bet.auction.finish_date.try(:strftime, '%d:%M:%Y').to_s, auction_price: @bet.auction.price.to_s
          render nothing: true
        }
      end
    else
      redirect_to :back, error: bet.errors.messages
    end
  end
end