class AuctionDecorator < Draper::Decorator
  delegate_all

  def link_to_make_bet
    if object.active?
      h.link_to 'сделать ставку', h.new_bet_path(auction: object), remote: true
    end
  end
end