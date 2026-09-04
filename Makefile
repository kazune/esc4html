.PHONY: test lint check

test:
	bats test

lint:
	shellcheck esc4html test/esc4html.bats
	shfmt -d -ln posix esc4html
	shfmt -d -ln bats test/esc4html.bats

check: lint test
