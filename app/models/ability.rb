class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      (user.admin?) ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    cannot :read, Auction
    can :create, Bet
    can :manage, :profile
    cannot :manage, :admin # это свойство излишне,потому что запрещено все,что не разрешено.
  end

  def guest_abilities
    can :read, Auction
  end

end
