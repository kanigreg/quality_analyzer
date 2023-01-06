# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :storage, -> { StorageStub }
  else
    register :storage, -> { Storage }
  end
end
