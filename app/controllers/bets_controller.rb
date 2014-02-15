class BetsController < ApplicationController
  def new
    unless current_user
      redirect_to root_path, notice: 'зарегистрируйтесь, чтобы сделать ставку'
      return
    end

    auction = Auction.find(params[:auction])
    bet = Bet.new(user: current_user, auction: auction)
    if bet.save!
      redirect_to :back, notice: 'ставка сделана'
    else
      redirect_to :back, error: bet.errors.messages
    end
  end
end