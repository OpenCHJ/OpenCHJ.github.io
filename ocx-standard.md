# OCX Standard v0.6β

最終更新日: 2026-10-21 小木曽

TEI を使わずに OCX Standard の文書を作る手順は、[OCX Standard の作り方（TEI を使わない場合）](ocx-standard-guide.md) を参照してください。

## 目次
- [1. 目的と位置づけ](#1-目的と位置づけ)
- [2. 基本原則](#2-基本原則)
- [3. 名前空間と接頭辞運用](#3-名前空間と接頭辞運用)
- [4. 文書構造](#4-文書構造)
- [5. TEI 語彙の利用](#5-tei-語彙の利用)
- [6. 文境界](#6-文境界)
- [7. 割書（warigaki）](#7-割書warigaki)
- [8. ルビ（フリガナ）](#8-ルビフリガナ)
- [9. 踊り字（odoriji）](#9-踊り字odoriji)
- [10. 濁点付与（vMark）](#10-濁点付与vmark)
- [11. 誤字・脱字・衍字（corr）](#11-誤字脱字衍字corr)
- [12. 注記](#12-注記)
- [13. 解析制御](#13-解析制御)
- [14. 解析入力生成規則（要約）](#14-解析入力生成規則要約)
- [15. 適合性（Conformance）](#15-適合性conformance)
- [16. 互換性と拡張](#16-互換性と拡張)
- [付録 A: 用語](#付録-a-用語)
- [付録 B: 実装者向けメモ](#付録-b-実装者向けメモ)
- [付録 C: TEI ガイドラインとの対応と相違点](#付録-c-tei-ガイドラインとの対応と相違点)

---

## 1. 目的と位置づけ

**OCX (Open CHJ XML)** は、日本語テキストを中心とする人文系資料を対象に、次を同時に満たすことを目的とした XML 規格です。

- 形態素解析・構文解析などの言語解析に適したテキスト表現
- 文字オフセット（character offsets）に基づく解析結果管理
- 原文表記（割書・ルビ・踊り字等）の保持

**OCX Standard** は、OCX mini（最小マークアップ）を包含しつつ、TEI 語彙を利用し、OCX 独自語彙で解析制御を明示します。  
本規格は **TEI 文書そのものではありません**（TEI の語彙を借用しつつ、解析用途に最適化します）。TEI ガイドラインとの対応と相違点は [付録 C](#付録-c-tei-ガイドラインとの対応と相違点) にまとめています。

### 1.1 OCX mini との関係

OCX mini の要素（`ocx:doc`, `ocx:eos`, `ocx:r`, `ocx:comment`）は、OCX Standard でも同じ意味で使用できます。`ocx:` 接頭辞付きで記述された OCX mini 準拠文書は、そのまま OCX Standard 準拠文書です。

- 文境界は、OCX Standard では `tei:s` または `ocx:eos` で表します（[6章](#6-文境界)）。OCX mini の `ocx:eos` による文境界はそのまま有効です。
- ただし、OCX mini で認めている **デフォルト名前空間による接頭辞の省略**（`<doc>`, `<eos/>` など）は OCX Standard では認めません。接頭辞を省略した OCX mini 文書は、`ocx:` 接頭辞付きに書き換えることで OCX Standard 準拠となります。

---

## 2. 基本原則

1. 本文に含まれる文字は、原則としてすべて解析対象とします。  
2. 形態素解析を行わない範囲（解析対象外）は、**`ocx:skip`** によって明示します。解析対象外の範囲も本文文字列としては残り、規則による擬似トークン化で短単位と品詞（`pos`）が与えられます（[13.2](#132-ocxskip解析対象外範囲)）。  
3. 原文表記（ルビ・踊り字など）や注記の情報は、属性値として本文文字列と分離して保持します。属性値は解析用テキストに含めません。  
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

例（XHTML への埋め込み）:

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

### 4.2 解析対象範囲

解析対象となるのは **`ocx:doc` の内部のみ**です。`tei:front`, `tei:back` などの要素も、`ocx:doc` の内部にあれば解析対象になります。埋め込み先文書（XHTML の `head` など）のうち `ocx:doc` の外にある部分は解析対象になりません。

書誌情報などのヘッダー（`tei:teiHeader` や XHTML の `head` など）は、`ocx:doc` の **外** に置きます。`ocx:doc` の内部に置くと、その文字列が解析対象になります。

### 4.3 最小例（標準）

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

## 5. TEI 語彙の利用

OCX Standard は TEI 語彙を **閉じたサブセットとしては限定しません**。OCX の原則（[2章](#2-基本原則)：本文中の文字は原則としてすべて解析対象となり、読み・注記などを本文文字列に混ぜない）を破らない TEI 要素は使用できます。TEI ガイドラインとの相違点は [付録 C](#付録-c-tei-ガイドラインとの対応と相違点) を参照してください。

### 5.1 よく用いる TEI 要素

次の要素は OCX Standard でよく用いる TEI 要素です（これに限定するものではありません）。

- `tei:front`, `tei:body`, `tei:back`
- `tei:div`, `tei:p`, `tei:s`
- `tei:head`
- `tei:sp`, `tei:speaker`, `tei:said`
- `tei:pb`, `tei:lb`, `tei:g`

このうち OCX Standard が解析上の意味を与えるのは `tei:s`（文境界、[6章](#6-文境界)）のみです。その他の TEI 要素は、上記の一覧にないものも含め、解析入力生成ではタグを無視し、要素内容の文字列を通常の本文として扱います。

- `tei:speaker`（話者表示）や `tei:head`（見出し）の文字列も解析対象です。解析から除きたい情報は、本文に書かずに属性値（例: `tei:sp@who`）に記録します。
- `tei:foreign` などで外国語であることを示しても、形態素解析の対象のままです。形態素解析を行わない場合は `ocx:skip`（`pos="foreign"`）で囲みます（[13.2](#132-ocxskip解析対象外範囲)）。
- `tei:w`, `tei:pc` などで語や句読点の単位を示しても、タグは無視されるため解析結果には反映されません（単位への分割は形態素解析が行います）。
- `tei:add`（加筆）の要素内容は、通常の本文として解析対象になります。

### 5.2 使用しない TEI 要素と制約

次の要素は OCX の原則と両立しないため使用しません。

- `tei:note` は使用しません（注記は `ocx:comment` を使用し、本文に注釈が入り込むのを避ける）。
- `tei:ruby` は使用しません（ルビは `ocx:r` を使用し、本文に振り仮名が入り込むのを避ける）。
- `tei:choice` は使用しません（本文は解析対象となる一つにしぼる）。
- `tei:app`, `tei:lem`, `tei:rdg`（校異）は使用しません（本文は解析対象となる一つにしぼる）。本文には採用した読みだけを書き、異文は `ocx:comment` に記録します。
- `tei:del`（原文で削除された文字）、`tei:subst`（置き換え）は使用しません。削除された文字は `ocx:comment` に記録し、加筆された文字は本文として（必要なら `tei:add` で）記述します。
- `tei:fw`（柱・ノンブル・丁付けなどの版面の文字）は使用しません。記録する場合は `ocx:comment` に記録するか、本文に残して `ocx:skip`（`pos="other"`）で囲みます。

次の要素は OCX の要素と役割が重なるため使用せず、OCX の要素を用います。

| TEI | 代わりに用いる OCX 要素 |
|---|---|
| `tei:sic`, `tei:corr`, `tei:supplied`, `tei:surplus` | `ocx:corr`（[11章](#11-誤字脱字衍字corr)） |
| `tei:orig`, `tei:reg` | `ocx:odoriji`（[9章](#9-踊り字odoriji)）, `ocx:vMark`（[10章](#10-濁点付与vmark)） |

その他の制約:

- `tei:g`（外字）には、代替文字を **要素内容として必ず** 記述します。空の `tei:g` は解析用テキストに文字が残らず、文字オフセットがずれる原因になります。適当な代替文字が見当たらない場合は、`〓`（げた記号）を用います。

```xml
<tei:g ref="#gaiji01">吉</tei:g>
<tei:g ref="#gaiji02">〓</tei:g>
```

---

## 6. 文境界

### 6.1 正規形（推奨）: `tei:s`

文は原則 `tei:s` で括ります。`tei:s` の終端は文境界であり、解析入力生成では改行 1 文字になります。

```xml
<tei:s>……。</tei:s>
```

`tei:s` は入れ子にしてはなりません（`tei:s` の中に `tei:s` を置かない。TEI と同じ）。

### 6.2 `ocx:eos`（文境界表示）

OCX mini 由来の `ocx:eos`（空要素）も文境界の表示として使用できます。`tei:s` と `ocx:eos` のどちらを用いても OCX Standard 準拠です。

```xml
……。<ocx:eos/>
```

`ocx:eos` も解析入力生成では改行 1 文字になります。

**制約（必須）**
- `ocx:eos` は `tei:s` の内部に置いてはなりません。

**推奨**
- 同一段落（`tei:p`）内で `tei:s` と `ocx:eos` を混在させない（段落単位で方式を統一）。

---

## 7. 割書（warigaki）

### 7.1 `ocx:warigaki`（構造要素）

割書を表す構造要素です。属性を持ちません。

```xml
<ocx:warigaki>割書本文</ocx:warigaki>
```

### 7.2 解析制御（推奨）: `ocx:skip` を外側に付与

割書の解析上の扱いを変える場合、外側に `ocx:skip`（[13.2](#132-ocxskip解析対象外範囲)）を付与します（`ocx:skip` が親、`ocx:warigaki` が子）。

```xml
<ocx:skip tokenize="single" pos="other">
  <ocx:warigaki>（割書）</ocx:warigaki>
</ocx:skip>
```

### 7.3 割書内改行: `ocx:wbr`（空要素）

原文で割書の内部に改行がある場合、`tei:lb` ではなく `ocx:wbr` を用います。

```xml
<ocx:warigaki>第一行<ocx:wbr/>第二行</ocx:warigaki>
```

- `ocx:wbr` は **`ocx:warigaki` 内のみ**で使用します。
- 解析入力生成では `ocx:wbr` は除去されます。

---

## 8. ルビ（フリガナ）

### 8.1 `ocx:r`

```xml
<ocx:r rt="よみ">表記</ocx:r>
```

要素内容（文字列）は表記であり、解析対象です。

| 属性 | 必須 | 内容 |
|---|---|---|
| `rt` | △ | ふりがな（右側、または通常の位置） |
| `lrt` | △ | 左側についたふりがな |

△: `@rt` と `@lrt` のうち少なくとも一方が必要です。`@lrt` だけを持つ場合も認めます。いずれも属性値のため、解析用テキストには含めません。

```xml
<ocx:r rt="よみ" lrt="いみ">表記</ocx:r>
<ocx:r lrt="いみ">表記</ocx:r>
```

---

## 9. 踊り字（odoriji）

### 9.1 `ocx:odoriji`

踊り字（ゝゞヽヾ々〳〵 等）を、対応する文字へ展開した上で、原表記を保持します。

```xml
こ<ocx:odoriji orig="ゝ">こ</ocx:odoriji>ろ
人<ocx:odoriji orig="々">人</ocx:odoriji>
```

| 属性 | 必須 | 内容 |
|---|---|---|
| `orig` | ○ | 原表記の踊り字記号（制限語彙） |

`orig` 制限語彙:
`ゝ` `ゞ` `ヽ` `ヾ` `〻` `々` `〳〵` `〱` `〲`

解析入力生成では、`ocx:odoriji` の **要素内容のみ**を出力し、`@orig` は保持情報（解析用テキストに含めない）とします。

`々` について: 解析処理では `々` を自動展開しません（`人々` は `人々` のまま解析されます）。`ocx:odoriji` で展開した記述（上の `人<ocx:odoriji orig="々">人</ocx:odoriji>`）も許容します。

踊り字の展開に濁点の補いを伴う場合は、`ocx:odoriji` を外側、`ocx:vMark` を内側にします（[10章](#10-濁点付与vmark)）。

---

## 10. 濁点付与（vMark）

### 10.1 `ocx:vMark`（濁点）

原文に付与されていなかった濁点を補った場合、濁点を補った文字を `ocx:vMark` で括って表します。要素内容は **1 文字**です（複数の文字に濁点を補う場合は、1 文字ずつ `ocx:vMark` で括ります）。原表記は、要素内容から濁点を除いた文字です。

例:

```xml
<tei:s>智に働け<ocx:vMark>ば</ocx:vMark>角が立つ。情に棹させば流される。意地を通せば窮屈だ。とかくに人の世は住みにくい。</tei:s>
```

解析入力生成では、`ocx:vMark` の **要素内容（濁点を補った文字）**を出力します。

### 10.2 踊り字との組み合わせ

踊り字の展開に濁点の補いを伴う場合は、`ocx:odoriji` を外側、`ocx:vMark` を内側にします（逆の入れ子は用いません）。

例（原文「かゝみ」を「かがみ」として扱う場合）:

```xml
か<ocx:odoriji orig="ゝ"><ocx:vMark>が</ocx:vMark></ocx:odoriji>み
```

---

## 11. 誤字・脱字・衍字（corr）

### 11.1 `ocx:corr`（誤字・脱字・衍字の修正）

原文に対する修正を `ocx:corr` で表し、修正後の文字を要素内容とします。修正前の文字は `ocx:corr@orig` に保存します。

- 衍字を処理した場合（原文の余分な文字を削除した場合）は空要素になります。
- 脱字を処理した場合（原文にない文字を補った場合）は `@orig` の値が空文字列になります。
- 要素内容と `@orig` の両方が空であってはなりません。
- 誤字・脱字・衍字の別は、要素内容と `@orig` が空かどうかで判別できるため、種別を示す属性は設けません。

（`tei:corr` とは仕様が異なります。）

| 属性 | 必須 | 内容 |
|---|---|---|
| `orig` | ○ | 原表記（修正前の文字列。脱字の場合は空文字列） |

例:

```xml
<tei:s>智に<ocx:corr orig="動">働</ocx:corr>けば角が立つ。情に<ocx:corr orig="竿">棹</ocx:corr>させば流される。
意地を通せば<ocx:corr orig="ば"/>窮屈だ。とかく<ocx:corr orig="">に</ocx:corr>人の世は住みにくい。</tei:s>
```

解析入力生成では、`ocx:corr` の **要素内容のみ**を出力し、`@orig` は保持情報（解析用テキストに含めない）とします。

---

## 12. 注記

### 12.1 `ocx:comment`（空要素）

```xml
<ocx:comment text="注記内容"/>
```

- 注記は `@text` 属性に記述し、本文文字列に混ぜません。
- 空要素であるため本文の文字数・オフセットに影響せず、解析入力生成時には除去されます。

---

## 13. 解析制御

OCX Standard は、形態素解析の制御を **2種類の範囲タグ**で表します。

### 13.1 `ocx:proc`（解析範囲の特殊処理）

```xml
<ocx:proc dic="Kindai-bungo" norm="kata2hira">…</ocx:proc>
```

| 属性 | 必須 | 内容 |
|---|---|---|
| `dic` | 任意 | 形態素解析に用いる辞書（制限語彙、下記） |
| `norm` | 任意 | 解析前に適用する正規化規則（制限語彙、下記） |

**処理順**
1. `norm` を適用（指定がある場合）
2. `dic` で指定した辞書（指定がなければ既定辞書の現代書き言葉UniDic）で通常解析

`dic` 制限語彙

- `Kindai-bungo`　近代文語UniDicで解析
- `Chuko-wabun`　中古和文UniDicで解析
- `Kansai`　関西方言UniDicで解析

`norm` 制限語彙

- `kata2hira`　カタカナをひらがなに置き換えてから解析

### 13.2 `ocx:skip`（解析対象外範囲）

```xml
<ocx:skip tokenize="single" pos="uri">https://example.org</ocx:skip>
```

| 属性 | 必須 | 内容 |
|---|---|---|
| `tokenize` | ○ | `single` / `space` |
| `pos` | ○ | 制限語彙（下記） |

`tokenize` の意味:

- `single`: 範囲全体を 1 短単位として扱う
- `space`: 全角スペース（U+3000）で分割して短単位を生成する（各短単位に同一 `pos` を付与）

`pos` 制限語彙

- `kanbun`（漢文）
- `foreign`（外国語）
- `uri`（URL・メールアドレス等）
- `code`（プログラムコード）
- `other`（その他）

---

## 14. 解析入力生成規則（要約）

- 対象範囲 → `ocx:doc` の内部のみ
- `tei:s` の終端 → 文境界（改行 1 文字）
- `ocx:eos` → 文境界（改行 1 文字）
- 原文データ中の改行 → 除去（改行が残るのは文境界のみ）
- 全角スペース → 本文文字として保持
- TEI 要素・埋め込み先の要素（`tei:speaker`, `tei:head`, `tei:g` などを含む） → タグを無視し、要素内容を通常の本文として出力
- `ocx:warigaki` → 要素内容を通常の本文として出力
- `ocx:wbr` → 除去
- `ocx:r` → 要素内容のみ出力（`@rt`, `@lrt` は除外）
- `ocx:odoriji` → 要素内容のみ出力（`@orig` は除外）
- `ocx:vMark` → 要素内容のみ出力
- `ocx:corr` → 要素内容のみ出力（`@orig` は除外）
- `ocx:comment` → 除去
- `ocx:proc` → `norm` 適用 → `dic` 指定解析
- `ocx:skip` → `tokenize` 規則で擬似トークン化し `pos` を付与
- 属性値 → 出力しない

---

## 15. 適合性（Conformance）

### 15.1 OCX Standard 準拠文書

OCX Standard 準拠と主張する文書は、少なくとも次を満たす必要があります。

- `ocx:doc` ルート、必須属性 `textID`, `corpusName`
- OCX 要素は常に `ocx:` 接頭辞付きで記述（デフォルト名前空間による省略は不可）
- 文境界を `tei:s` または `ocx:eos` で示す
- [5.2](#52-使用しない-tei-要素と制約) で使用しないとした TEI 要素を用いない
- `tei:s` は入れ子にしない
- `tei:g` は要素内容（代替文字）を持つ
- `ocx:eos` は `tei:s` 内に出現しない
- `ocx:wbr` は `ocx:warigaki` 内にのみ出現
- `ocx:r` は `@rt` と `@lrt` の少なくとも一方を持つ
- `ocx:odoriji@orig` は制限語彙のいずれか
- `ocx:vMark` の要素内容は 1 文字
- `ocx:odoriji` と `ocx:vMark` を入れ子にする場合は `ocx:odoriji` が外側
- `ocx:corr` は `@orig` を持ち、要素内容と `@orig` の両方が空ではない
- `ocx:proc` の `@dic`, `@norm` は制限語彙のいずれか
- `ocx:skip` の `@tokenize` は `single|space` のいずれか
- `ocx:skip` の `@pos` は制限語彙のいずれか

---

## 16. 互換性と拡張

- `dic` 値の追加
- `norm` 規則の追加
- `pos` 値の追加
- OCX が解析上の意味を与える TEI 要素の追加

はいずれも後方互換性を保つ形で追加します。

---

## 付録 A: 用語

- **文字オフセット**: 文字列上の位置（開始・終了）で注釈や解析結果を対応付ける方法。
- **解析対象外**: 形態素解析を行わないこと（`ocx:skip`）。文字は本文文字列として残り、擬似トークン化される。
- **擬似トークン化**: 形態素解析器にかけず、ルールで短単位化する処理（`ocx:skip`）。

---

## 付録 B: 実装者向けメモ

### B.1 スキーマ

本仕様に対応するスキーマは、将来次の形で同梱することを想定します。

- ODD（TEI カスタマイゼーション）
- XSD（検証用）

TEI 要素は閉じたサブセットとして限定しないため（[5章](#5-tei-語彙の利用)）、スキーマでは OCX 要素を厳密に検証し、TEI 要素は緩やかに（lax に）許容することを想定します。

TEI のスキーマ（TEI All など）で検証する場合、`ocx:*` 要素は TEI の名前空間外の要素としてエラーになります。ODD で `https://openchj.github.io/ns/ocx` 名前空間の要素を許可するカスタマイズが必要です（[付録 C.6](#c6-tei-スキーマで検証する場合)）。

---

## 付録 C: TEI ガイドラインとの対応と相違点

この付録は、TEI に慣れた利用者や、OCX 文書を TEI 文書に変換する実装者のための参考情報です（規範ではありません）。

### C.1 文書構造

TEI 文書は `tei:TEI` > `tei:teiHeader` + `tei:text` > `tei:front` / `tei:body` / `tei:back` という構造をとります。OCX では `ocx:doc` がルートとなり、その直下に `tei:body` などを置きます。`teiHeader` に相当する書誌情報は OCX の対象外で、`ocx:doc` の `@textID`, `@corpusName` のみを持ちます。

| OCX | TEI |
|---|---|
| `ocx:doc` | `tei:TEI` / `tei:text` |
| `ocx:doc@textID` | `tei:TEI@xml:id` または `tei:idno` |

### C.2 使用しない TEI 要素と代わりの OCX 要素

| TEI | OCX | 理由 |
|---|---|---|
| `tei:note` | `ocx:comment` | 注記の文字列を本文に入れないため |
| `tei:ruby` / `tei:rb` / `tei:rt` | `ocx:r` | ふりがなの文字列を本文に入れないため |
| `tei:choice` + `tei:sic` / `tei:corr` | `ocx:corr` | 本文を解析対象となる一つにしぼるため |
| `tei:choice` + `tei:orig` / `tei:reg` | `ocx:odoriji`, `ocx:vMark` | 同上 |
| `tei:app` / `tei:lem` / `tei:rdg` | `ocx:comment`（異文を記録） | 同上 |
| `tei:del`, `tei:subst` | `ocx:comment`（削除された文字を記録） | 削除された文字を本文に入れないため |
| `tei:fw` | `ocx:comment` または `ocx:skip` | 版面の文字を本文として解析しないため |
| `tei:sic`, `tei:corr`, `tei:supplied`, `tei:surplus` | `ocx:corr` | 書き方を一つにそろえるため |
| `tei:orig`, `tei:reg` | `ocx:odoriji`, `ocx:vMark` | 同上 |

### C.3 意味がずれる点・名前が重なる点

- **`@who`**: TEI では `#A` のような URI 参照（`tei:particDesc` の人物などを指す）ですが、OCX では話者名などの任意の文字列を認めます。
- **`ocx:corr` と `tei:corr`**: `tei:corr` は `tei:choice` の中で訂正後の文字列を示す要素ですが、`ocx:corr` は単独で用い、訂正前の文字列を `@orig` に持ちます。
- **`@orig` と `tei:orig`**: OCX の `@orig` 属性（原表記）は、TEI の `tei:orig` 要素とは別のものです。

### C.4 TEI の書き方と OCX での扱いが異なる点

- **外字 `tei:g`**: TEI では `<tei:g ref="#gaiji01"/>` のような空要素も使えますが、OCX では代替文字（見当たらない場合は `〓`）を要素内容として必ず記述します（[5.2](#52-使用しない-tei-要素と制約)）。
- **外国語 `tei:foreign`**: TEI で外国語を示しても、OCX では形態素解析の対象のままです。形態素解析を行わない場合は `ocx:skip` で囲みます。

### C.5 TEI への変換の目安

| OCX | TEI での表現例 |
|---|---|
| `<ocx:r rt="よみ">表記</ocx:r>` | `<tei:ruby><tei:rb>表記</tei:rb><tei:rt>よみ</tei:rt></tei:ruby>` |
| `<ocx:r lrt="いみ">表記</ocx:r>` | `<tei:ruby><tei:rb>表記</tei:rb><tei:rt place="left">いみ</tei:rt></tei:ruby>` |
| `<ocx:comment text="注記"/>` | `<tei:note>注記</tei:note>` |
| `<ocx:corr orig="動">働</ocx:corr>`（誤字） | `<tei:choice><tei:sic>動</tei:sic><tei:corr>働</tei:corr></tei:choice>` |
| `<ocx:corr orig="ば"/>`（衍字） | `<tei:surplus>ば</tei:surplus>` |
| `<ocx:corr orig="">に</ocx:corr>`（脱字） | `<tei:supplied reason="omitted">に</tei:supplied>` |
| `<ocx:odoriji orig="ゝ">こ</ocx:odoriji>` | `<tei:choice><tei:orig>ゝ</tei:orig><tei:reg>こ</tei:reg></tei:choice>` |
| `<ocx:vMark>ば</ocx:vMark>` | `<tei:choice><tei:orig>は</tei:orig><tei:reg>ば</tei:reg></tei:choice>` |
| `<ocx:warigaki>…</ocx:warigaki>` | `<tei:seg type="warigaki">…</tei:seg>` など |
| `<ocx:wbr/>` | `<tei:lb/>` |
| `<ocx:eos/>` | `tei:s` による文の括り |
| `ocx:proc`, `ocx:skip` | 対応する TEI 要素なし（`ocx:skip pos="foreign"` は `tei:foreign` に近い） |

### C.6 TEI スキーマで検証する場合

OCX 文書の `tei:*` 部分を TEI のスキーマで検証する場合は、ODD で次のカスタマイズを行います。

- `https://openchj.github.io/ns/ocx` 名前空間の要素を、TEI 要素の内容として許可する
- `@who` で任意の文字列を値として許可する（OCX の `@who` の扱いに合わせる場合）
