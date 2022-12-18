# frozen_string_literal: true

class User < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :email, presence: true
  validates :token, presence: true

  def repo_names
    Rails.cache.fetch("##{cache_key_with_version}/repo_names", expires_in: 1.day) do
      github_api = ApplicationContainer['github_api']
      repos, status = github_api.repositories(self)
      result = repos.select { |repo| Repository.language.value?(repo[:language]&.downcase) }
                    .map { |repo| [repo[:name], repo[:id]] }
      [result, status]
    end
  end
end
