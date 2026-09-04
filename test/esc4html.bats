#!/usr/bin/env bats

# `run --separate-stderr` requires Bats 1.5.0 or later.
bats_require_minimum_version 1.5.0

setup() {
	ESC4HTML="$BATS_TEST_DIRNAME/../esc4html"
}

assert_escape() {
	run "$ESC4HTML" <<<"$1"

	[ "$status" -eq 0 ]
	[ "$output" = "$2" ]
}

@test "escapes ampersand" {
	assert_escape '&' '&amp;'
}

@test "escapes less-than sign" {
	assert_escape '<' '&lt;'
}

@test "escapes greater-than sign" {
	assert_escape '>' '&gt;'
}

@test "escapes double quote" {
	assert_escape '"' '&quot;'
}

@test "escapes apostrophe" {
	assert_escape "'" '&#39;'
}

@test "escapes special characters mixed with ordinary text" {
	run "$ESC4HTML" <<<'<p title="Tom & Jerry'"'"'s">hello</p>'

	[ "$status" -eq 0 ]
	[ "$output" = '&lt;p title=&quot;Tom &amp; Jerry&#39;s&quot;&gt;hello&lt;/p&gt;' ]
}

@test "double-escapes an existing entity" {
	run "$ESC4HTML" <<<'&amp;'

	[ "$status" -eq 0 ]
	[ "$output" = '&amp;amp;' ]
}

@test "accepts empty input" {
	run "$ESC4HTML" </dev/null

	[ "$status" -eq 0 ]
	[ -z "$output" ]
}

@test "preserves ordinary multiline text" {
	run "$ESC4HTML" <<'EOF'
first line
second line
EOF

	[ "$status" -eq 0 ]
	[ "$output" = $'first line\nsecond line' ]
}

@test "preserves non-ASCII text" {
	run "$ESC4HTML" <<<'Café 日本語 😀'

	[ "$status" -eq 0 ]
	[ "$output" = 'Café 日本語 😀' ]
}

@test "rejects one or more arguments without writing to stdout" {
	run --separate-stderr "$ESC4HTML" input.txt <<<'<input>'

	[ "$status" -eq 2 ]
	[ -z "$output" ]
	[ "$stderr" = 'Usage: esc4html' ]

	run --separate-stderr "$ESC4HTML" first.txt second.txt <<<'<input>'

	[ "$status" -eq 2 ]
	[ -z "$output" ]
	[ "$stderr" = 'Usage: esc4html' ]
}

@test "rejects a sed-style option argument" {
	run --separate-stderr "$ESC4HTML" -n <<<'<input>'

	[ "$status" -eq 2 ]
	[ -z "$output" ]
	[ "$stderr" = 'Usage: esc4html' ]
}
