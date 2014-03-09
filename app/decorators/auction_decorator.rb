class AuctionDecorator < Draper::Decorator
  delegate_all

  def link_to_make_bet opts = {}
    opts.merge!(remote: true, method: :post)
    if object.active?
      h.link_to 'сделать ставку', h.auction_bets_path(auction_id: object.id), opts
    end
  end
end