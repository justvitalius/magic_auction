Auction.delete_all
User.delete_all


FactoryGirl.create(:user)
FactoryGirl.create(:admin)
10.times{ FactoryGirl.create(:auction) }