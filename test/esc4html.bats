#!/usr/bin/env bats

setup() {
    ESC4HTML="$BATS_TEST_DIRNAME/../esc4html"
}

@test "escapes HTML special characters from standard input" {
    input=$'&<>"\''

    run "$ESC4HTML" <<< "$input"

    [ "$status" -eq 0 ]
    [ "$output" = '&amp;&lt;&gt;&quot;&#39;' ]
}

@test "preserves ordinary multiline text" {
    run "$ESC4HTML" <<'EOF'
plain text
日本語
EOF

    [ "$status" -eq 0 ]
    [ "$output" = $'plain text\n日本語' ]
}

@test "double-escapes an existing entity" {
    run "$ESC4HTML" <<< '&amp;'

    [ "$status" -eq 0 ]
    [ "$output" = '&amp;amp;' ]
}

@test "rejects file and option arguments" {
    run "$ESC4HTML" input.txt

    [ "$status" -eq 2 ]
    [ "$output" = 'Usage: esc4html' ]

    run "$ESC4HTML" -n

    [ "$status" -eq 2 ]
    [ "$output" = 'Usage: esc4html' ]
}
