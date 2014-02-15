class AddFinishDateToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :finish_date, :datetime
  end
end
