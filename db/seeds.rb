Auction.delete_all
User.delete_all


FactoryGirl.create(:user)
FactoryGirl.create(:admin)
10.times { FactoryGirl.create(:auction) }

# Import permissions
[
    { title: 'Управление категориями', action: :manage, subject: 'Category'},
    { title: 'Управление продуктами', action: :manage, subject: 'Product'}
].each do |permission|
  title = permission.delete(:title)
  p = Permission.where(permission).first
  p.present? ? p.update(title: title) : Permission.create!(permission.merge(title: title))
end

puts 'permission import done'
# end of Import permissions


