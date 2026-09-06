PREFIX ?= /usr/local
DESTDIR ?=
BINDIR ?= $(PREFIX)/bin
MAN1DIR ?= $(PREFIX)/share/man/man1

.PHONY: test lint check install uninstall

test:
	bats test

lint:
	shellcheck esc4html test/esc4html.bats
	shfmt -d -ln posix esc4html
	shfmt -d -ln bats test/esc4html.bats

check: lint test

install:
	install -d "$(DESTDIR)$(BINDIR)" "$(DESTDIR)$(MAN1DIR)"
	install -m 755 esc4html "$(DESTDIR)$(BINDIR)/esc4html"
	install -m 644 man/esc4html.1 "$(DESTDIR)$(MAN1DIR)/esc4html.1"

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)/esc4html" "$(DESTDIR)$(MAN1DIR)/esc4html.1"
