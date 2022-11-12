install:
	bundle install --without production development
	yarn install

setup:
	cp -n .env.example .env || true
	bin/setup

test:
	bin/rails test

.PHONY: test
