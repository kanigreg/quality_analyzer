# frozen_string_literal: true

class User < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :email, presence: true
  validates :token, presence: true

  def repo_names
    Rails.cache.fetch("##{cache_key_with_version}/repo_names", expires_in: 1.day) do
      repos, status = GithubApi.repositories(self)
      result = repos.select { |repo| Repository::ALLOWED_LANGUAGES.include?(repo[:language]&.downcase) }
                    .map { |repo| [repo[:name], repo[:id]] }
      [result, status]
    end
  end
end
