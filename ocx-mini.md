# OCX mini 文書定義

Draft 2025/12/20 小木曽

## 1. OCX mini とは何か

OCX mini は、OpenCHJに収録するために、文学作品・史料・資料テキストを\
**形態素解析・検索しやすい形でアノテーションするための、最小限のマークアップ方式**です。

最大の特徴は次の2点です。

1.  **本文に現れるテキストはすべて解析対象になる**
2.  **解析に不要な情報（読み・注記・書誌情報）は本文から分離する**

これにより、

-   解析結果を形態論情報データベース[^1]上で（文字オフセットで関連付けて）管理できる
-   メタ情報・ふりがな・コメントなどコーパス本文に不要な情報を解析対象とせず、そのままコーパスに入れられる
-   XHTML 文書にも、プレーンテキストにも同じ方法で利用できる

[^1]: https://doi.org/10.5715/jnlp.21.301

という利点があります。

テキストファイルの **文字エンコーディングは UTF-8 を強く推奨**します。文字集合はJIS X 0213:2004または JIS X 0208:1990を推奨します。


## 2. 文書の書き方（2つの使い方）

OCX mini は、次の **2通りの形**で使えます。

### (A) プレーンテキストの最小マークアップ

テキストそのものを `<ocx:doc>` で囲み、  
必要な場所にだけタグを挿入します。

この形式は、

- 元のテキスト構造をほとんど変えない
- 人手で修正・校訂しやすい
- 将来、XHTML や TEI に変換しやすい

という点で、研究用途に向いています。

#### サンプル
- ソース
``` txt
素朴《そぼく》な琴《こと》
この明るさのなかへ
ひとつの素朴な琴をおけば
秋の美くしさに耐えかね
琴はしずかに鳴りいだすだろう
```

- ocx mini アノテーション
``` xml
<ocx:doc textID="八木重吉　貧しき信徒" corpusName="青空文庫">
<ocx:r rt="そぼく">素朴</ocx:r>な<ocx:r rt="こと">琴</ocx:r><ocx:eos/>
この明るさのなかへ
ひとつの素朴な琴をおけば
秋の美くしさに耐えかね
琴はしずかに鳴りいだすだろう<ocx:eos/>
</ocx:doc>
```

なお、スキーマを用いてXMLファイルの検証する場合は冒頭のocx:docタグを
``` xml
<ocx:doc textID="八木重吉　貧しき信徒" corpusName="青空文庫"
    xmlns:ocx="https://openchj.github.io/ns/ocx"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="https://openchj.github.io/ns/ocx
	https://openchj.github.io/schema/ocx/mini/1.0/ocx-mini.xsd">
```
のようにしてください。

### (B) XHTML 文書への埋め込み

既存の XHTML（青空文庫HTMLなど）に、\
本文部分（body要素以下）にだけ `<ocx:doc>` を追加する方法です。

``` xml
<body>
  <ocx:doc textID="坂本竜馬 船中八策" corpusName="青空文庫">
   <div> 一、天下の政権を朝廷に奉還せしめ、政令宜しく朝廷より出づべき事。<ocx:eos/><br/></div>
   <div> 一、上下議政局を設け、議員を置きて万機を参賛せしめ、万機宜しく公議に決すべき事。<ocx:eos/></div>
  </ocx:doc>
</body>
```

この場合でも、**解析対象は `<ocx:doc>` の中だけ**です。\
`<head>` のタイトルやメタ情報は解析対象になりません。`<div class="bibliographical_information">`以下も囲まないようにすれば解析対象になりません。


#### サンプル
- ソース：青空文庫 船中八策（新字新仮名） https://www.aozora.gr.jp/cards/000908/files/4254_16911.html

  - 青空文庫は文字エンコーディングがShift_JISだが、UTF-8で保存し直すことを強く推奨（ `<?xml version="1.0" encoding="Shift_JIS"?>` を削除し、 `<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS" />` を削除ないし無効化しておく。）

``` xml
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" >
<head>
	<!-- meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS" / -->
	<meta http-equiv="content-style-type" content="text/css" />
	<link rel="stylesheet" type="text/css" href="../../default.css" />
	<title>坂本竜馬 船中八策</title>
	<link rel="DC.Schema" href="http://purl.org/dc/elements/1.1/" />
	<meta name="DC.Creator" content="坂本竜馬" />
	<meta name="DC.Publisher" content="青空文庫" />
</head>
<body>
<ocx:doc textID="坂本竜馬 船中八策" corpusName="青空文庫" xmlns:ocx="https://openchj.github.io/ns/ocx"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="https://openchj.github.io/ns/ocx https://openchj.github.io/schema/ocx/mini/1.0/ocx-mini.xsd">
<h1 class="title">船中八策</h1>
<h2 class="author">坂本竜馬</h2>
<div class="main_text">
<br />
<br />
<br />
<div class="burasage" style="margin-left: 1em; text-indent: -1em;">一、天下の政権を朝廷に奉還せしめ、政令宜しく朝廷より出づべき事。<ocx:eos/></div>
<div class="burasage" style="margin-left: 1em; text-indent: -1em;">一、上下議政局を設け、議員を置きて万機を参賛せしめ、万機宜しく公議に決すべき事。<ocx:eos/></div>
<div class="burasage" style="margin-left: 1em; text-indent: -1em;">一、有材の公卿・諸侯<ocx:r rt="および">及</ocx:r>天下の人材を顧問に備へ、官爵を賜ひ、宜しく従来有名無実の官を除くべき事。<ocx:eos/></div>
<div class="burasage" style="margin-left: 1em; text-indent: -1em;">一、外国の交際広く公議を採り、<ocx:r rt="あらた">新</ocx:r>に至当の規約を立つべき事。<ocx:eos/></div>
<div class="burasage" style="margin-left: 1em; text-indent: -1em;">一、古来の律令を折衷し、新に無窮の大典を撰定すべき事。<ocx:eos/></div>
<div class="burasage" style="margin-left: 1em; text-indent: -1em;">一、海軍宜しく拡張すべき事。<ocx:eos/></div>
<div class="burasage" style="margin-left: 1em; text-indent: -1em;">一、御親兵を置き、帝都を守衛せしむべき事。<ocx:eos/></div>
<div class="burasage" style="margin-left: 1em; text-indent: -1em;">一、金銀物貨宜しく外国と平均の法を設くべき事。<ocx:eos/></div>
<div class="jisage_1" style="margin-left: 1em">
　以上八策は、方今天下の形勢を察し、之を<ocx:r rt="うだい">宇内</ocx:r>万国に徴するに、之を捨てて他に済時の急務あるべし。<ocx:eos/>
<ocx:r rt="いやしく">苟</ocx:r>も此数策を断行せば、皇運を挽回し、国勢を拡張し、万国と並立するも亦敢て<ocx:r rt="かた">難</ocx:r>しとせず。<ocx:eos/>
<ocx:r rt="ふし">伏</ocx:r>て<ocx:r rt="ねがは">願</ocx:r>くは公明正大の道理に<ocx:r rt="もとづ">基</ocx:r>き、一大英断を以て天下と更始一新せん。<ocx:eos/><br />
</div>
<br />
<br />
<br />
</div>
</ocx:doc>
<div class="bibliographical_information">
<hr />
<br />
底本：「日本の思想　20　幕末思想集」筑摩書房
<br />
　　　1969（昭和44）年7月5日初版第1刷発行<br />
　　　1975（昭和50）年4月15日初版第4刷発行<br />
底本の親本：「坂本竜馬関係文書」<br />
入力：志田火路司<br />
校正：土屋隆<br />
2004年11月6日作成<br />
青空文庫作成ファイル：<br />
このファイルは、インターネットの図書館、<a href="http://www.aozora.gr.jp/">青空文庫（http://www.aozora.gr.jp/）</a>で作られました。入力、校正、制作にあたったのは、ボランティアの皆さんです。<br />
<br />
<br />
</div>
<div class="notation_notes">
<hr />
<br />
●表記について<br />
<ul>
	<li>このファイルは W3C 勧告 XHTML1.1 にそった形式で作成されています。</li>
</ul>
</div>
</body>
</html>

```

## 3. OCX mini の基本原則（重要）

### 3.1 本文原則

> `<ocx:doc>` の中に書かれた文字は、\
> **すべて形態素解析の対象になる**

つまり、

-   本文中に注記文を書いてはいけない
-   読み仮名を本文文字として入れてはいけない

という考え方を取ります。

------------------------------------------------------------------------

### 3.2 文は必ず区切る

OCX mini では、**文の終わりを必ず明示**します。

-   文末には必ず `<ocx:eos/>` を置く
-   これは**解析上の文境界マーカー**として機能します。

``` xml
これは文です。<ocx:eos/>
これも文です。<ocx:eos/>
```

作業途中で付け忘れがあっても構いませんが、\
**最終的に「OCX mini 準拠」とする文書では必須**です。

------------------------------------------------------------------------

## 4. 使えるタグ（4つだけ）

OCX mini で使う独自タグは **4つだけ**です。

------------------------------------------------------------------------

### 4.1 `<ocx:doc>`（本文コンテナ）

本文全体を囲む要素です。

-   `textID`：作品や資料の識別子
-   `corpusName`：コーパス名（例：青空文庫）

``` xml
<ocx:doc textID="..." corpusName="...">
  （本文）
</ocx:doc>
```

------------------------------------------------------------------------

### 4.2 `<ocx:eos/>`（文末マーカー）

文の終わりを示す **空のタグ**です。

``` xml
……であった。<ocx:eos/>
```

-   解析時には **改行1文字**として扱われます
-   見た目には何も表示されません

------------------------------------------------------------------------

### 4.3 `<ocx:r>`（ルビ＝ふりがな）

漢字などに読みを付けたいときに使います。

``` xml
<ocx:r rt="うらやま">羨</ocx:r>しい
```

-   要素の中身：本文に出る文字
-   `rt` 属性：読み（解析対象外）

**読みは本文文字列には含まれません。**

------------------------------------------------------------------------

### 4.4 `<ocx:note/>`（注記）

本文に出したくない注記を残すためのタグです。

``` xml
<ocx:note text="外字を通用字に改めた"/>
```

-   注記文は属性に書く
-   本文の文字数・オフセットに影響しない

------------------------------------------------------------------------

## 5. 解析用テキストの作り方（概念的説明）

OCX mini 文書から形態素解析用テキストを作るときは：

1.  `<ocx:doc>` の中の文字だけを集める
3.  `<ocx:eos/>` を **改行1文字**に置き換える
4.  `<ocx:r>` は中身の文字だけを使う
2.  半角の空白や改行、タブ文字は削除する （残っていてもいいが解析時には除去される）

これにより、

-   文単位で安定した解析
-   文字オフセットがずれない
-   注記や読みが邪魔をしない

という状態が得られます。

------------------------------------------------------------------------

## 6. OCX standard との関係

OCX mini は **OCX standard のサブセット**です。


------------------------------------------------------------------------

## 7. まとめ

-   本文文字はしっかり校正し、全角スペースや記号を含めていっさい変更しない（本文の文字が今後の全ての処理の起点になります）
-   文は必ず `<ocx:eos/>` で切る
-   読み・注記は **本文に混ぜない**
-   プレーンテキストにも XHTML にも使える
-   TEI への変換を考慮して設計されている

