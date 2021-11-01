class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all 
    elsif user.leader_writer?
      can :read, Article
      can :update, Article
    elsif user.author?
      can :read, Article
      can :create, Article
      can :update, Article do |article|
        article.try(user) == user
      end
      can :destroy, Article do |article|
        article.try(:user) == user
      end
    end
  end
end