class Bet < ActiveRecord::Base

  belongs_to :auction, dependent: :destroy
  belongs_to :user, dependent: :destroy

  validates :auction_id, presence: true
  validates :user_id, presence: true

  validate :auction_active?

  after_create :update_auction

  private

  def update_auction
    auction.increase_price
    auction.increase_finish_date
  end

  def auction_active?
    errors.add(:auction, 'Auction is not active!') unless auction.try(:active?)
  end

end
