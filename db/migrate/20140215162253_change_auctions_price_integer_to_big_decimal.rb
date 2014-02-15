class ChangeAuctionsPriceIntegerToBigDecimal < ActiveRecord::Migration
  def change
    add_column :auctions, :price, :decimal, precision: 8, scale: 2, default: 0
  end
end
