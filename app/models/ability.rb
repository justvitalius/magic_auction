class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      (user.admin?) ? admin_abilities : user_abilities(user)
    else
      guest_abilities
    end
  end

  private

  def admin_abilities
    can :manage, :all
  end

  def user_abilities(user)
    can :read, Auction
    can :create, Bet
    can :manage, :profile
    cannot :manage, :admin # это свойство излишне,потому что запрещено все,что не разрешено.

    user.permissions.each do |p|
      begin
        can p.action.to_sym, p.subject.constantize, id: p.subject_id.to_i
      rescue NameError
        can p.action.to_sym, p.subject.to_sym
      end
    end
  end

  def guest_abilities
    can :read, Auction
  end

end
