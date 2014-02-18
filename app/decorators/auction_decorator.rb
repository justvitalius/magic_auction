class AuctionDecorator < Draper::Decorator
  delegate_all

  def link_to_make_bet
    if object.active?
      h.link_to 'сделать ставку', h.auction_bets_path(auction_id: object.id), remote: true, method: :post
    end
  end
end