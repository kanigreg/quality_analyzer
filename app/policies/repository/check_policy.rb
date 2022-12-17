# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  def create?
    record&.repository&.user == user
  end
end
