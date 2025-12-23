# OCX Standard v0.5 (Draft)

20251223 小木曽

## 1. 目的と位置づけ

**OCX (Open Corpus eXtension)** は、日本語テキストを中心とする人文系資料を対象に、

- 形態素解析・構文解析などの言語解析に適したテキスト表現
- 文字オフセットに基づく解析結果管理
- 原文表記（踊り字・割書・ルビ等）の保持

を同時に満たすことを目的とした XML 規格である。

**OCX Standard** は、

- OCX mini（最小マークアップ）を包含し
- TEI 語彙の一部を制限付きで利用し
- OCX 独自語彙によって解析制御を明示する

という立場を取る。

本規格は **TEI 文書そのものではない**。

---

## 2. 基本原則

1. 本文に含まれる文字は、原則としてすべて解析対象とする  
2. 解析対象外とする範囲は、OCX 独自要素で明示する  
3. 原文表記の情報は、解析用文字列と分離して保持する  
4. XML 要素の交差を避け、実装可能性を優先する  
5. 名前空間は OCX / TEI ともに接頭辞付きで記述する  

---

## 3. 名前空間

```xml
xmlns:ocx="https://openchj.github.io/ns/ocx"
xmlns:tei="http://www.tei-c.org/ns/1.0"
```

デフォルト名前空間は使用しない。

### 名前空間接頭辞の運用方針

- OCX 独自語彙（`ocx:*`）は **常に名前空間接頭辞付き**で記述する。
- OCX 文書が XHTML 等の文書に埋め込まれる場合、
  埋め込み先文書（例：XHTML 本文）の要素は **接頭辞なし（デフォルト名前空間）**で記述してよい。
- ただし、その場合でも OCX 要素は必ず `ocx:` 接頭辞を付与する。

この方針により、
- OCX 要素と埋め込み先文書の要素を視覚的に明確に区別できる
- テキスト処理・正規表現処理において OCX 要素を容易に識別できる

ことを意図する。

---

## 4. 文書構造

### 4.1 ルート要素

```xml
<ocx:doc textID="…" corpusName="…">
  …
</ocx:doc>
```

| 属性 | 必須 | 内容 |
|---|---|---|
| textID | ○ | テキスト識別子 |
| corpusName | ○ | コーパス名 |

---

## 5. TEI 語彙サブセット（Standard）

```
tei:front
tei:title
tei:body
tei:div
tei:p
tei:s
tei:pb
tei:lb
tei:g
tei:quote
tei:sp
tei:speaker
```

制約：

- `tei:note` は使用しない  
- `tei:quote` はブロック引用のみ  
- `tei:speaker` は原文にある場合のみ使用  

---

## 6. 文境界

- 正規形：`tei:s`
- オプション：`ocx:eos`

---

## 7. ルビ

```xml
<ocx:r rt="よみ">表記</ocx:r>
```

---

## 8. 注記

```xml
<ocx:comment text="注記"/>
```

---

## 9. 解析制御

### 9.1 ocx:proc

```xml
<ocx:proc dic="Kindai-bungo" norm="kata2hira">…</ocx:proc>
```

### 9.2 ocx:skip

```xml
<ocx:skip tokenize="single" pos="kanbun">…</ocx:skip>
```

pos 値：
- kanbun
- foreign
- uri
- code
- other

---

## 10. 踊り字

```xml
人<ocx:odoriji orig="々">人</ocx:odoriji>
```

orig 値：ゝ ゞ ヽ ヾ 々 〳〵 〱 〲

---

## 11. 割書

```xml
<ocx:warigaki>割書本文</ocx:warigaki>
```

解析制御が必要な場合：

```xml
<ocx:skip tokenize="single" pos="other">
  <ocx:warigaki>割書本文</ocx:warigaki>
</ocx:skip>
```

### 割書内改行

```xml
<ocx:warigaki>第一行<ocx:wbr/>第二行</ocx:warigaki>
```

---

## 12. 解析入力生成ルール（要約）

- `tei:s` → 文境界  
- `ocx:eos` → 文境界  
- `ocx:r` → 内容のみ  
- `ocx:comment` → 除外  
- `ocx:odoriji` → 内容のみ  
- `ocx:proc` → 正規化 → 辞書解析  
- `ocx:skip` → 擬似トークン化（特殊品詞として解析）  
- `ocx:wbr` → 除外  

---

## 13. OCX mini との関係

OCX Standard は OCX mini を包含する。

---

## 14. 拡張

後方互換性を保って拡張する。

---

## 15. 総括

OCX Standard は、人文系資料の解析と原文忠実性を両立させるための実務志向の規格である。
