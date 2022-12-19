# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  def show?
    owner?
  end

  def create?
    owner?
  end

  def owner?
    record&.repository&.user == user
  end
end
