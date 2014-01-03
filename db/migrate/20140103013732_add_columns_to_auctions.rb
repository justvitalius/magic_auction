class AddColumnsToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :expire_date, :datetime
    add_column :auctions, :product_id, :integer
  end
end
