<?xml version="1.0" encoding="UTF-8"?>
<!--
  OCX Standard v0.62β Schematron rules (ISO Schematron, XPath 1.0)
  https://openchj.github.io/ocx-standard

  Rules that the XSDs (ocx-standard.xsd, ocx-standard-tei.xsd) cannot
  express. Use after XSD validation, for both OCX-only documents and
  documents combined with TEI.
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            queryBinding="xslt" xml:lang="ja">

  <sch:title>OCX Standard v0.62β</sch:title>

  <sch:ns prefix="ocx" uri="https://openchj.github.io/ns/ocx"/>
  <sch:ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>

  <!-- 3.2, 3.3 接頭辞 -->
  <sch:pattern id="prefix">
    <sch:rule context="/*">
      <sch:assert test="not(//ocx:*[name() != local-name()] and //ocx:*[name() = local-name()])">
        接頭辞 ocx: を付けた書き方と省略した書き方を混在させてはなりません（3.3）。
      </sch:assert>
      <sch:assert test="not(//*[namespace-uri() != 'https://openchj.github.io/ns/ocx'] and //ocx:*[name() = local-name()])">
        OCX 以外の名前空間の要素を含む文書では、OCX 要素に接頭辞を付けなければなりません（3.2, 3.3）。
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!-- 15.1 文境界 -->
  <sch:pattern id="sentence-boundary">
    <sch:rule context="ocx:doc">
      <sch:assert test="not(ancestor::ocx:doc)">
        ocx:doc は入れ子にしてはなりません（4.1）。
      </sch:assert>
      <sch:assert test="not(preceding::ocx:doc[@textID = current()/@textID])">
        同じファイルの中で ocx:doc の textID を重複させてはなりません（4.1）。
      </sch:assert>
      <sch:assert test=".//tei:s or .//ocx:eos">
        文境界が示されていません。tei:s または ocx:eos で文境界を示します（6, 15.1）。
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!-- 5.2 使用しない TEI 要素 -->
  <sch:pattern id="tei-not-used">
    <sch:rule context="tei:*">
      <sch:assert test="not(self::tei:note or self::tei:ruby or self::tei:choice or self::tei:app or self::tei:lem or self::tei:rdg or self::tei:del or self::tei:subst or self::tei:fw)">
        <sch:name/> は使用しません（5.2）。
      </sch:assert>
      <sch:assert test="not(self::tei:sic or self::tei:corr or self::tei:supplied or self::tei:surplus)">
        <sch:name/> は使用せず、ocx:corr を用います（5.2）。
      </sch:assert>
      <sch:assert test="not(self::tei:orig or self::tei:reg)">
        <sch:name/> は使用せず、ocx:odoriji または ocx:vMark を用います（5.2）。
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!-- 5.2 tei:g -->
  <sch:pattern id="tei-g">
    <sch:rule context="tei:g">
      <sch:assert test="normalize-space(.) != ''">
        tei:g には代替文字（見当たらない場合は 〓）を要素内容として記述します（5.2）。
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!-- 6 文境界 -->
  <sch:pattern id="tei-s">
    <sch:rule context="tei:s">
      <sch:assert test="not(ancestor::tei:s)">
        tei:s は入れ子にしてはなりません（6.1）。
      </sch:assert>
    </sch:rule>
    <sch:rule context="ocx:eos">
      <sch:assert test="not(ancestor::tei:s) or (parent::tei:s and not(following-sibling::*) and not(following-sibling::text()[normalize-space() != '']))">
        ocx:eos は tei:s の内部では終端の直前にのみ置けます（6.2）。
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!-- 7.3 割書内改行 -->
  <sch:pattern id="wbr">
    <sch:rule context="ocx:wbr">
      <sch:assert test="ancestor::ocx:warigaki">
        ocx:wbr は ocx:warigaki の内部でのみ使用します（7.3）。
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!-- 8.1 ルビ -->
  <sch:pattern id="ruby">
    <sch:rule context="ocx:r">
      <sch:assert test="@rt or @lrt">
        ocx:r には @rt と @lrt の少なくとも一方が必要です（8.1）。
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!-- 13.2 解析制御の入れ子 -->
  <sch:pattern id="proc-skip">
    <sch:rule context="ocx:proc">
      <sch:assert test="not(ancestor::ocx:skip)">
        ocx:skip の内部に ocx:proc を置いてはなりません（13.2）。
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!-- 10.2 踊り字と濁点の入れ子 -->
  <sch:pattern id="odoriji-vmark">
    <sch:rule context="ocx:odoriji">
      <sch:assert test="not(ancestor::ocx:vMark)">
        ocx:odoriji と ocx:vMark を入れ子にする場合は ocx:odoriji を外側にします（10.2）。
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!-- 11.1 誤字・脱字・衍字 -->
  <sch:pattern id="corr">
    <sch:rule context="ocx:corr">
      <sch:assert test="@orig != '' or node()">
        ocx:corr の要素内容と @orig の両方が空であってはなりません（11.1）。
      </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
