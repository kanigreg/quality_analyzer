# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def show?
    owner?
  end

  def check?
    owner?
  end

  private

  def owner?
    record&.user_id == user.id
  end
end
