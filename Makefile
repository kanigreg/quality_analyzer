install:
	bundle install --without production development
	yarn install

lint:
	bundle exec rubocop
	bundle exec slim-lint app/views

setup:
	cp -n .env.example .env || true
	bin/setup

test:
	bin/rails test

.PHONY: test
