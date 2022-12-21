# frozen_string_literal: true

class Repository::Check::Issue < ApplicationRecord
  belongs_to :repository_check, class_name: 'Repository::Check', counter_cache: true

  validates :message, presence: true
end
