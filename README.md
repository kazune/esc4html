# esc4html

標準入力のテキストをHTML用にエスケープする、小さなフィルターコマンドです。

## Usage

パイプまたは入力リダイレクトでテキストを渡します。

```sh
printf '%s\n' '<p class="note">Tom & Jerry</p>' | ./esc4html
```

```text
&lt;p class=&quot;note&quot;&gt;Tom &amp; Jerry&lt;/p&gt;
```

ファイルを処理する場合も、引数ではなくリダイレクトを使用します。

```sh
./esc4html < in.txt > out.txt
```

コマンドライン引数は受け付けません。引数が指定された場合は、終了コード `2` で終了します。

## 変換規則

| 入力 | 出力 |
| --- | --- |
| `&` | `&amp;` |
| `<` | `&lt;` |
| `>` | `&gt;` |
| `"` | `&quot;` |
| `'` | `&#39;` |

構造を解析せず、入力を単純に置換します。そのため、既存の文字参照も二重にエスケープされます。例えば、`&amp;` は `&amp;amp;` になります。

HTMLのテキストとして埋め込む内容を対象としています。JavaScript、CSS、URLなど、別の文脈に対するエスケープや検証には使用できません。

## Requirements

- POSIX互換の `sh`
- `sed`

テストの実行には [Bats](https://github.com/bats-core/bats-core) が必要です。

## Test

```sh
make test
```
