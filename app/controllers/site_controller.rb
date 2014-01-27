class SiteController < ApplicationController
  def index
    @current_auctions = Auction.active
    @ended_auctions = Auction.inactive
  end
end