class AddTimeStepAndPriceStepToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :time_step, :integer, default: 30
    add_column :auctions, :price_step, :decimal, precision: 8, scale: 2
  end
end
