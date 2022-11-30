# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  has_many :issues, dependent: :destroy,
                    inverse_of: :repository_check,
                    foreign_key: :repository_check_id,
                    class_name: 'Repository::Check::Issue'

  aasm :state do
    state :checking, initial: true
    state :finished
    state :failed

    event :mark_as_failed do
      transitions from: :checking, to: :failed
    end

    event :mark_as_finished do
      transitions from: :checking, to: :finished
    end
  end
end
