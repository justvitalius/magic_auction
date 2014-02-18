class BetsController < ApplicationController
  def create
    unless current_user
      redirect_to root_path, notice: 'зарегистрируйтесь, чтобы сделать ставку'
      return
    end

    auction = Auction.find(params[:auction_id])
    @bet = Bet.new(user: current_user, auction: auction)
    if @bet.save!
      respond_to do |format|
        format.html{ redirect_to :back, notice: 'ставка сделана' }
        format.js
      end
    else
      redirect_to :back, error: bet.errors.messages
    end
  end
end