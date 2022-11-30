# frozen_string_literal: true

class Repository::Check::Issue < ApplicationRecord
  belongs_to :repository_check, class_name: 'Repository::Check'

  validates :message, presence: true
end
