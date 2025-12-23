# OCX Standard v0.5 (Draft)

最終更新日: 2025-12-23 小木曽

## 目次
- [1. 目的と位置づけ](#1-目的と位置づけ)
- [2. 基本原則](#2-基本原則)
- [3. 名前空間と接頭辞運用](#3-名前空間と接頭辞運用)
- [4. 文書構造](#4-文書構造)
- [5. TEI 語彙サブセット](#5-tei-語彙サブセット)
- [6. 文境界](#6-文境界)
- [7. ルビ（フリガナ）](#7-ルビフリガナ)
- [8. 注記（解析対象外）](#8-注記解析対象外)
- [9. 解析制御](#9-解析制御)
- [10. 踊り字（odoriji）](#10-踊り字odoriji)
- [11. 割書（warigaki）](#11-割書warigaki)
- [12. 会話（speech）](#12-会話speech)
- [13. 解析入力生成規則（要約）](#13-解析入力生成規則要約)
- [14. 適合性（Conformance）](#14-適合性conformance)
- [15. 互換性と拡張](#15-互換性と拡張)
- [付録 A: 用語](#付録-a-用語)
- [付録 B: 実装者向けメモ](#付録-b-実装者向けメモ)

---

## 1. 目的と位置づけ

**OCX (Open Corpus eXtension)** は、日本語テキストを中心とする人文系資料を対象に、次を同時に満たすことを目的とした XML 規格です。

- 形態素解析・構文解析などの言語解析に適したテキスト表現
- 文字オフセット（character offsets）に基づく解析結果管理
- 原文表記（踊り字・割書・ルビ等）の保持

**OCX Standard** は、OCX mini（最小マークアップ）を包含しつつ、TEI 語彙の一部を制限付きで利用し、OCX 独自語彙で解析制御を明示します。  
本規格は **TEI 文書そのものではありません**（TEI の一部を借用しつつ、解析用途に最適化します）。

---

## 2. 基本原則

1. 本文に含まれる文字は、原則としてすべて解析対象とします。  
2. 解析対象外とする範囲は、**`ocx:skip`** によって明示します。  
3. 原文表記（踊り字・ルビなど）の情報は、解析用文字列と分離して保持します。  
4. XML 要素の交差を避け、実装可能性を優先します。  
5. 名前空間は OCX / TEI ともに接頭辞付きで記述し、**OCX 要素は常に `ocx:` 接頭辞**で識別できるようにします。

---

## 3. 名前空間と接頭辞運用

### 3.1 名前空間宣言

```xml
xmlns:ocx="https://openchj.github.io/ns/ocx"
xmlns:tei="http://www.tei-c.org/ns/1.0"
```

### 3.2 接頭辞の運用方針（重要）

- OCX 独自語彙（`ocx:*`）は **常に接頭辞付き**で記述します。
- OCX 文書が XHTML 等の文書に埋め込まれる場合、埋め込み先文書（例：XHTML 本文）の要素は **接頭辞なし（デフォルト名前空間）**で記述して構いません。
- ただし、その場合でも OCX 要素は必ず `ocx:` 接頭辞を付与します。

この方針により、(a) OCX 要素をテキスト処理で機械的に見分けやすくし、(b) 埋め込み先（XHTML 等）の既存ツールチェーンとの親和性を保ちます。

---

## 4. 文書構造

### 4.1 ルート要素 `ocx:doc`

```xml
<ocx:doc textID="…" corpusName="…" xmlns:ocx="https://openchj.github.io/ns/ocx">
  …
</ocx:doc>
```

| 属性 | 必須 | 内容 |
|---|---|---|
| `textID` | ○ | テキスト識別子 |
| `corpusName` | ○ | コーパス名 |

### 4.2 最小例（標準）

```xml
<ocx:doc textID="作品ID" corpusName="コーパス名"
         xmlns:ocx="https://openchj.github.io/ns/ocx"
         xmlns:tei="http://www.tei-c.org/ns/1.0">
  <tei:body>
    <tei:p>
      <tei:s>これは文です。</tei:s>
      <tei:s>これは二文目です。</tei:s>
    </tei:p>
  </tei:body>
</ocx:doc>
```

---

## 5. TEI 語彙サブセット

OCX Standard で使用を許可する TEI 要素は以下に限定します。

- `tei:front`, `tei:title`, `tei:body`
- `tei:div`, `tei:p`, `tei:s`
- `tei:pb`, `tei:lb`, `tei:g`
- `tei:quote`
- `tei:sp`, `tei:speaker`

### 5.1 制約

- `tei:note` は使用しません（注記は `ocx:comment` を使用）。
- `tei:quote` は **ブロック引用**として用い、`tei:s` の内部には置きません。
- `tei:sp` は会話（発話範囲）を表すために用います。
- `tei:speaker` は **原文に明示的な話者表示がある場合のみ**用います。
- 話者識別（原文にない補助情報）は `tei:sp@who` を推奨します。

---

## 6. 文境界

### 6.1 正規形（推奨）: `tei:s`

文は原則 `tei:s` で括ります。

```xml
<tei:s>……。</tei:s>
```

### 6.2 オプション: `ocx:eos`（文境界表示）

OCX mini 由来の `ocx:eos`（空要素）を、文境界表示のオプションとして許可します。

```xml
……。<ocx:eos/>
```

**制約（必須）**
- `ocx:eos` は `tei:s` の内部に置いてはなりません。

**推奨**
- 同一段落（`tei:p`）内で `tei:s` と `ocx:eos` を混在させない（段落単位で方式を統一）。

---

## 7. ルビ（フリガナ）

### 7.1 `ocx:r`

```xml
<ocx:r rt="よみ">表記</ocx:r>
```

- 要素内容（文字列）: 解析対象（表記）
- `@rt`: 読み（解析対象外）

---

## 8. 注記（解析対象外）

### 8.1 `ocx:comment`（空要素）

```xml
<ocx:comment text="注記内容"/>
```

- 注記は本文文字列に混ぜません。
- 解析入力生成時には除外されます。

---

## 9. 解析制御

OCX Standard は、解析制御を **2種類の範囲タグ**で表します。

### 9.1 `ocx:proc`（通常解析範囲）

```xml
<ocx:proc dic="Kindai-bungo" norm="kata2hira">…</ocx:proc>
```

| 属性 | 必須 | 内容 |
|---|---|---|
| `dic` | 任意 | 辞書指定（例: `Kindai-bungo`, `Kansai`） |
| `norm` | 任意 | 正規化規則（v1.0: `kata2hira`） |

**処理順**
1. `norm` を適用（指定がある場合）
2. `dic` 指定（なければ既定辞書）で通常解析

### 9.2 `ocx:skip`（解析対象外範囲）

```xml
<ocx:skip tokenize="single" pos="uri">https://example.org</ocx:skip>
```

| 属性 | 必須 | 内容 |
|---|---|---|
| `tokenize` | ○ | `single` / `space` |
| `pos` | ○ | 制限語彙（下記） |

`pos` 制限語彙（v1.0）

- `kanbun`（漢文）
- `foreign`（外国語）
- `uri`（URL・メールアドレス等）
- `code`（プログラムコード）
- `other`（その他）

`tokenize` の意味:

- `single`: 範囲全体を 1 短単位として扱う
- `space`: 空白で分割して短単位を生成する（各短単位に同一 `pos` を付与）

---

## 10. 踊り字（odoriji）

### 10.1 `ocx:odoriji`

踊り字（ゝゞヽヾ々〳〵 等）を、対応する文字へ展開した上で、原表記を保持します。

```xml
こ<ocx:odoriji orig="ゝ">こ</ocx:odoriji>ろ
人<ocx:odoriji orig="々">人</ocx:odoriji>
```

| 属性 | 必須 | 内容 |
|---|---|---|
| `orig` | ○ | 原表記の踊り字記号（制限語彙） |

`orig` 制限語彙（v1.0）:
`ゝ` `ゞ` `ヽ` `ヾ` `々` `〳〵` `〱` `〲`

解析入力生成では、`ocx:odoriji` の **要素内容のみ**を出力し、`@orig` は保持情報（解析対象外）とします。

---

## 11. 割書（warigaki）

### 11.1 `ocx:warigaki`（構造要素）

割書を表す構造要素です。v1.0 では属性を持ちません。

```xml
<ocx:warigaki>割書本文</ocx:warigaki>
```

### 11.2 解析制御（推奨）: `ocx:skip` を外側に付与

割書の解析上の扱いを変える場合、外側に `ocx:skip` を付与します（`ocx:skip` が親、`ocx:warigaki` が子）。

```xml
<ocx:skip tokenize="single" pos="other">
  <ocx:warigaki>（割書）</ocx:warigaki>
</ocx:skip>
```

### 11.3 割書内改行: `ocx:wbr`（空要素）

原文で割書の内部に改行がある場合、`tei:lb` ではなく `ocx:wbr` を用います。

```xml
<ocx:warigaki>第一行<ocx:wbr/>第二行</ocx:warigaki>
```

- `ocx:wbr` は **`ocx:warigaki` 内のみ**で使用します。
- 解析入力生成では `ocx:wbr` を **空白 1 個**に正規化します。

---

## 12. 会話（speech）

### 12.1 `tei:sp`（発話範囲）

会話の範囲（台詞・発話）を TEI の `tei:sp` で表します。

- 話者識別のため `tei:sp@who` を推奨します。
- 原文に話者名が明示されている場合のみ `tei:speaker` を用います。
- `tei:speaker` の文字列は解析入力生成時に除外します。

例（話者識別のみ）:

```xml
<tei:sp who="A">
  <tei:s>あの泥坊が羨しい。</tei:s>
</tei:sp>
```

例（原文に話者表示がある場合）:

```xml
<tei:sp who="A">
  <tei:speaker>男</tei:speaker>
  <tei:s>あの泥坊が羨しい。</tei:s>
</tei:sp>
```

---

## 13. 解析用テキスト生成規則（要約）

- `tei:s` の終端 → 文境界
- `ocx:eos` → 改行（LF 相当）
- `ocx:r` → 要素内容のみ出力（`@rt` は除外）
- `ocx:comment` → 除去
- `ocx:odoriji` → 要素内容のみ出力（`@orig` は除外）
- `ocx:proc` → `norm` 適用 → `dic` 指定解析
- `ocx:skip` → `tokenize` 規則で擬似トークン化し `pos` を付与
- `ocx:wbr` → 除去

---

## 14. 適合性（Conformance）

### 14.1 OCX Standard 準拠文書

OCX Standard 準拠と主張する文書は、少なくとも次を満たす必要があります。

- `ocx:doc` ルート、必須属性 `textID`, `corpusName`
- OCX 要素は常に `ocx:` 接頭辞付きで記述
- `ocx:skip` の `@tokenize` は `single|space` のいずれか
- `ocx:skip` の `@pos` は v1.0 制限語彙のいずれか
- `ocx:odoriji@orig` は制限語彙のいずれか
- `ocx:wbr` は `ocx:warigaki` 内にのみ出現
- `ocx:eos` は `tei:s` 内に出現しない
- `tei:speaker` は原文にある場合のみ使用（補助的な話者名付与には使用しない）

---

## 15. 互換性と拡張

- `pos` 値の追加
- `norm` 規則の追加
- TEI サブセットの拡張

はいずれも後方互換性を保つ形で追加します。

---

## 付録 A: 用語

- **擬似トークン化**: 形態素解析器にかけず、ルールで短単位化する処理（`ocx:skip`）。
- **文字オフセット**: 文字列上の位置（開始・終了）で注釈や解析結果を対応付ける方法。

---

## 付録 B: 実装者向けメモ

### B.1 スキーマ

本仕様に対応するスキーマは、将来次の形で同梱することを想定します。

- ODD（TEI カスタマイゼーション）
- XSD（検証用）

### B.2 埋め込み（XHTML 等）

OCX 要素は `ocx:` 接頭辞で記述し、埋め込み先文書（XHTML 等）は接頭辞なし（デフォルト名前空間）で記述して構いません。

例（概念）:

```xml
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:ocx="https://openchj.github.io/ns/ocx">
  <body>
    <ocx:doc textID="…" corpusName="…">
      …
    </ocx:doc>
  </body>
</html>
```
