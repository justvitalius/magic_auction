class AuctionsController < ApplicationController
  def show
    @auction = AuctionDecorator.decorate Auction.find(params[:id])
  end
end