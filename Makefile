install:
	bundle install --without production development
	yarn install

build:
	yarn build
	yarn build:css

lint:
	bundle exec rubocop
	bundle exec slim-lint app/views

setup:
	cp -n .env.example .env || true
	bin/setup

test:
	bin/rails test

start:
	bin/rails s -b '0.0.0.0'

.PHONY: test
