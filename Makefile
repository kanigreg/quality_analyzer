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

.PHONY: test
