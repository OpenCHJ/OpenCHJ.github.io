# [OpenCHJ 中納言](https://chunagon.ninjal.ac.jp/open-chj/) 更新履歴

------

## ver. 2026.5
虎寛本狂言集・上代歌謡（仏足石歌・歌経標式例歌）・青空文庫所収小説等13作品を追加

- [虎寛本狂言集 /チーム瑞京](https://github.com/yuho-k/OpenCHJ-Torahiro) https://github.com/yuho-k/OpenCHJ-Torahiro
- [上代歌謡（仏足石歌・歌経標式例歌）](https://github.com/togiso/OpenCHJ-JodaiKayo) https://github.com/togiso/OpenCHJ-JodaiKayo
- [青空文庫（国語教科書所収小説等13作品）](https://github.com/togiso/OpenCHJ-Aozora) https://github.com/togiso/OpenCHJ-Aozora

| サブコーパス名                                       | 短単位数   | 記号を除いた短単位数 |
|--------------------------------------------------|-------:|---------:|
| 虎寛本狂言集                           | 337450 | 286124 |
| 上代歌謡（仏足石歌・歌経標式例歌）                           | 1114 | 1101 |
| 青空文庫（国語教科書所収小説等13作品）                          | 55637 | 47865 |

------

## ver. 2025.11  
短単位版「関西弁コーパス」を追加

-  [短単位版「関西弁コーパス」ver. 1.0](https://doi.org/10.15084/0002000585) https://doi.org/10.15084/0002000585

| サブコーパス名                                       | 短単位数   | 記号を除いた短単位数 |
|--------------------------------------------------|-------:|---------:|
| 短単位版「関西弁コーパス」                           | 1710852 | 1420826 |

------

## ver. 2025.03  
最初の公開

- [源氏物語（渋谷栄一版）](https://github.com/togiso/OpenCHJ-Genji) https://github.com/togiso/OpenCHJ-Genji
- [青空文庫（国語教科書所収小説6作品）](https://github.com/togiso/OpenCHJ-Aozora) https://github.com/togiso/OpenCHJ-Aozora
- [速記叢書講談演説集](https://github.com/togiso/OpenCHJ-Sokkikoudan) https://github.com/togiso/OpenCHJ-Sokkikoudan


| サブコーパス名                                       | 短単位数   | 記号を除いた短単位数 |
|--------------------------------------------------|-------:|---------:|
| 源氏物語（渋谷栄一版）                            | 536012 | 445847   |
| 青空文庫（国語教科書所収小説6作品）              | 26311  | 22458    |
| 速記叢書講談演説集                                | 100944 | 95675    |

------

## OpenCHJ XML（OCX）文書定義の更新履歴

### 2026.11
- [形態論情報データの形式](ocx-morph.md)（ドラフト）を公開
- OCX Standard: 仕様にない要素・属性は処理せず、タグを取り去るだけとすること、制限語彙にない属性値は既定値で処理することを明記（[14.1](ocx-standard.md#141-解析用テキスト)）
- OCX Standard: `ocx:proc` の中の `ocx:skip` は `ocx:skip` を優先し、`ocx:skip` の中に `ocx:proc` は置けないこと、`ocx:skip` は入れ子にできないことを明記（[13.2](ocx-standard.md#132-ocxskip解析対象外範囲)）
- OCX Standard: OCX の要素と TEI の語彙の使い分けの方針を明記（[5.3](ocx-standard.md#53-ocx-の要素と-tei-の語彙の使い分け)）。作り方ページに「OCX の要素で表せない情報が必要になったら」を追加
- OCX Standard: 原本の一つのファイルに複数の `ocx:doc` を置けることを明記（[4.1](ocx-standard.md#41-本文コンテナ-ocxdoc)）
- OCX Standard に、原本と解析用 XML の区別、文字コード、文字オフセットの数え方、`ocx:doc` の `version` 属性を追加。`tei:s` の終端直前の `ocx:eos` を一つの文境界として扱うよう変更（[付録 D.3](ocx-standard.md#d3-解析入力生成の明確化)）
- [OCX Standard](ocx-standard.md) を v0.62β に更新
- `ocx:proc` の入れ子の規則を定め、外側の正規化を取り消す `norm="none"` を追加（[OCX Standard 13.1](ocx-standard.md#131-ocxproc解析範囲の特殊処理)）
- TEI と組み合わせる文書用の XSD（[ocx-standard-tei.xsd](https://openchj.github.io/schema/ocx/standard/0.6/ocx-standard-tei.xsd)）と、XSD で表現できない規則を検証する Schematron（[ocx-standard.sch](https://openchj.github.io/schema/ocx/standard/0.6/ocx-standard.sch)）を公開

### 2026.10
- [OCX Standard v0.6β](ocx-standard.md) を公開（v0.5 からの変更点は [付録 D](ocx-standard.md#付録-d-v05-からの変更点)）
  - `ocx:corr`（誤字・脱字・衍字）と `ocx:vMark`（濁点の補い）を追加
  - OCX の要素だけで書く文書で接頭辞 `ocx:` の省略を認め、OCX mini 準拠文書がそのまま OCX Standard 準拠文書となるようにした
  - `ocx:proc@dic` で指定できる辞書を、Web茶まめで利用できる UniDic に拡張
  - TEI 語彙を閉じたサブセットとして限定しない方針とし、TEI ガイドラインとの対応と相違点を付録にまとめた
- [OCX Standard の作り方（TEI を使わない場合）](ocx-standard-guide.md) を公開
- OCX の要素だけで書く文書用の XSD（[ocx-standard.xsd](https://openchj.github.io/schema/ocx/standard/0.6/ocx-standard.xsd)）を公開

### 2025.12
- [OCX mini](ocx-mini.md)（ドラフト）と XSD・ODD、[OCX Standard v0.5](ocx-standard_v05.md)（ドラフト）を公開

------

| [TOP](index.md) | [更新履歴](history.md) | [整備中の資料・作品](ongoing.md) | [語数について](wc.md) |
