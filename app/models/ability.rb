# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.is_a?(Admin)
      can :manage, :all
    else
      can :manage, :all
      cannot :manage, [:rails_admin, :dashboard]
    end
  end
end
