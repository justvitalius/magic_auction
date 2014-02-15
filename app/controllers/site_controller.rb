class SiteController < ApplicationController
  def index
    @current_auctions = AuctionsDecorator.decorate Auction.active, with: AuctionDecorator
    @ended_auctions = AuctionsDecorator.decorate Auction.inactive, with: AuctionDecorator
  end
end