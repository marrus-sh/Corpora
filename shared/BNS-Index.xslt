<!DOCTYPE stylesheet [
	<!ENTITY NCName "http://www.w3.org/2001/XMLSchema#NCName">
	<!ENTITY gYearMonth "http://www.w3.org/2001/XMLSchema#gYearMonth">
	<!ENTITY integer "http://www.w3.org/2001/XMLSchema#integer">
	<!ENTITY date "http://www.w3.org/2001/XMLSchema#date">
]>
<!--
⁌ Branching Notational System Index X·S·L Transformation (BNS-Index.xslt)

§ Usage :—

Requires both X·S·L·T 1.0 and E·X·S·L·T Common support.  C·S·S features require at least Firefox 76 / Safari 14.1 / Chrome 89.  Stick the following at the beginning of your X·M·L file :—

	<?xml-stylesheet type="text/xsl" href="/path/to/BNS-Index.xslt"?>

§§ Configuration (in the file which links to this stylesheet) :—

• The first <html:link rel="index" type="application/rdf+xml"> element with an @href attribute is used to source the R·D·F for the index.

• The @lang attribute on the document element is used to prioritize titles from fetched resources.

• Exactly one <html:nav id="BNS-Index"> must be supplied; the index will be placed in here!

• Feel free to add your own <html:style> elements or other content.

§§ Index RDF Format :—

• A basic index file looks like this:

	<Index
		xmlns="https://go.KIBI.family/Ontologies/BNS/#"
		xmlns:bns="https://go.KIBI.family/Ontologies/BNS/#"
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	>
		<indexes rdf:resource="../:bns/#thing"/>
		<fullTitle xml:lang="en">My Index</fullTitle>
		<selects rdf:parseType="Resource">
			<branch rdf:resource="/path/to/branch/"/>
		</selects>
	</Index>

It is important that the @rdf:resource property of the <bns:indexes> element be dereferencable to an actual B·N·S corpus—branch information will be pulled from here.

§ Disclaimer :—

To the extent possible under law, kibigo! has waived all copyright and related or neighboring rights to this file via a CC0 1.0 Universal Public Domain Dedication.  See ‹ https://creativecommons.org/publicdomain/zero/1.0/ › for more information.

THIS FILE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THIS FILE, THE USE OF THIS FILE, OR OTHER DEALINGS IN THIS FILE.
-->
<stylesheet
	id="transform"
	version="1.0"
	xmlns="http://www.w3.org/1999/XSL/Transform"
	xmlns:bns="https://go.KIBI.family/Ontologies/BNS/#"
	xmlns:dc="http://purl.org/dc/terms/"
	xmlns:dcmitype="http://purl.org/dc/dcmitype/"
	xmlns:exsl="http://exslt.org/common"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:svg="http://www.w3.org/2000/svg"
>
	<import href="./BNS-Helpers.xslt"/>
	<variable name="index_rdf" select="//html:link[@rel='index'][@type='application/rdf+xml']/@href[1]"/>
	<variable name="corpus_base" select="document($index_rdf)//bns:indexes"/>
	<variable name="corpus_rdf">
		<variable name="nohash">
			<choose>
				<when test="contains(document($index_rdf)//bns:indexes/@rdf:resource, '#')">
					<value-of select="substring-before(document($index_rdf)//bns:indexes/@rdf:resource, '#')"/>
				</when>
				<otherwise>
					<value-of select="document($index_rdf)//bns:indexes/@rdf:resource"/>
				</otherwise>
			</choose>
		</variable>
		<choose>
			<when test="document($nohash, document($index_rdf)//bns:indexes)//bns:Corpus">
				<value-of select="$nohash"/>
			</when>
			<otherwise>
				<call-template name="resolve">
					<with-param name="uri" select="document($nohash, $corpus_base)//html:link[@rel='alternate'][@type='application/rdf+xml']/@href[1]"/>
					<with-param name="base" select="$nohash"/>
				</call-template>
			</otherwise>
		</choose>
	</variable>
	<template match="html:head">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<call-template name="helper-css"/>
			<html:style>
#BNS-Index--Wrapper{ Display: Grid; Position: Relative; Grid: Auto-Flow / Max-Content Max-Content; Justify-Content: Center; Color: Var(--Text); Background: Var(--Canvas); Z-Index: 0 }
#BNS-Index{ Display: Grid; Box-Sizing: Border-Box; Margin: 1REM; Border: .5REM Var(--Magic) Solid; Padding-Block: 1REM; Padding-Inline: 1REM; Block-Size: Calc(100VH - 2REM); Inline-Size: Max(18REM, 20VW); Grid: Max-Content 1FR Max-Content / Auto-Flow; Background: Var(--Background); Box-Shadow: 0 0 .5REM Var(--Shade); Text-Align: Center }
#BNS-Index ol{ Margin: 0; Padding: 0; Overflow: Auto }
#BNS-Index li{ Display: Block; Margin-Block: .25REM }
#BNS-Index li>strong{ Display: Block; Margin-Block: 0 1REM; Color: Var(--Bold); Font-Size: 1.5EM }
#BNS-Index li li>strong{ Font-Size: 1.25EM }
#BNS-Index li li li>strong{ Font-Size: 1.125EM }
#BNS-Index li li li li>strong{ Font-Size: 1EM }
#BNS-Index li>a{ Display: Block; Border: Thin Var(--Fade) Dashed; Padding: .5REM; Background: Var(--Background) }
#BNS-Index li>a[data-current]{ Background: Var(--Canvas) }
#BNS-Index li>a>cite{ Font: Inherit; Color: Var(--Attn) }
#BNS-Index li>a:Hover>cite{ Color: Inherit }
#BNS-Index li>a>cite::before{ Content: "“" }
#BNS-Index li>a>cite::after{ Content: "”" }
#BNS-Index footer{ Margin-Block: .5REM 0; Border-Block-Start: Thin Var(--Fade) Dashed; Padding-Block: .5REM 0 }
#BNS-Index~article{ Display: Grid; Box-Sizing: Border-Box; Position: Absolute; Inset: 0; Margin-Inline-Start: Calc(Max(18REM, 20VW) + 2REM); Border: Var(--Shade) Groove; Grid: Max-Content Auto / Auto-Flow; Overflow: Auto; Background: Var(--Background); Box-Shadow: 0 0 .5REM Var(--Shade); Opacity: 1; Visibility: Visible; Transition: Opacity 1S, Visibility .5S; Z-Index: -1 }
#BNS-Index~article[hidden]{ Display: Grid; Opacity: 0; Visibility: Hidden }
#BNS-Index~article>header{ Padding-Block: .5REM; Border-Block-End: Var(--Shade) Outset; Font-Size: 1.25REM; Text-Align: Center }
#BNS-Index~article>header>p{ Display: Flex; Margin: 0; Flex-Flow: Row Wrap; Align-Items: Center; Justify-Content: Center; White-Space: Pre-Wrap }
#BNS-Index~article>header>p>span{ Color: Var(--Magic) }
#BNS-Index~div.SPACER{ Inline-Size: 0; Transition: Ease-In-Out Inline-Size 1S; Z-Index: -2 }
#BNS-Index~article:Not([hidden])~div.SPACER{ Inline-Size: Calc(100VW - Max(18REM, 20VW) - 2REM) }
h1{ Margin-Block: 0 .5REM; Border: Var(--Shade) Solid; Padding-Block: .125EM; Color: Var(--Background); Background: Var(--Magic); Font-Size: 2EM; Font-Weight: Normal; Font-Variant: Small-Caps }
h1>*:Any-Link{ Color: Inherit }
h1>*:Any-Link:Hover{ Color: Var(--Canvas) }
h2{ Margin: 0; Font-Size: 2REM; Font-Weight: Normal; Color: Var(--Bold) }
h2>cite{ Font: Inherit; Color: Var(--Attn) }
h2>cite::before{ Content: "“" }
h2>cite::after{ Content: "”" }
h2>sub>span{ Color: Var(--Magic) }
			</html:style>
			<call-template name="helper-js"/>
			<html:script>
const updatePanels= () => {
  if ( 1 >= location.hash.length ) {
    for ( const link of document.querySelectorAll("#BNS-Index li>a") ) {
      link.removeAttribute("data-current")
    }
    for ( const panel of document.querySelectorAll("#BNS-Index~article") ) {
      panel.hidden= true
  } }
  else {
    const anchor= decodeURIComponent(location.hash.substring(1))
    const element= document.getElementById(anchor)
    if ( !element || !element.matches("#BNS-Index~article") )
      return
    else {
      for ( const link of document.querySelectorAll("#BNS-Index li>a") ) {
        link[
          link.hash == location.hash ? "setAttribute"
          : "removeAttribute"
        ]("data-current", "")
      }
      for ( const panel of document.querySelectorAll("#BNS-Index~article") ) {
        if ( !(panel.hidden= panel != element) )
          displayMediaIn(panel)
} } } }
window.addEventListener("load", updatePanels)
window.addEventListener
  ( "hashchange"
  , event => (updatePanels(), event.preventDefault()) )
			</html:script>
			<apply-templates/>
		</copy>
	</template>
	<template match="html:title">
		<copy>
			<value-of select="document($index_rdf)//bns:Index/bns:fullTitle"/>
		</copy>
	</template>
	<template name="branchlistitem">
		<param name="parent" select="false()"/>
		<param name="as"/>
		<variable name="passthrough" select="$parent and (bns:includes/bns:Concept or bns:includes/bns:Version or bns:includes/bns:Draft)"/>
		<variable name="descriptor">
			<choose>
				<when test="$as">
					<value-of select="$as"/>
				</when>
				<otherwise>
					<value-of select="@rdf:about"/>
				</otherwise>
			</choose>
		</variable>
		<variable name="tag">
			<choose>
				<when test="$parent">strong</when>
				<otherwise>a</otherwise>
			</choose>
		</variable>
		<choose>
			<when test="$passthrough">
				<for-each select="bns:includes/*[bns:index/@rdf:datatype='&integer;']">
					<sort select="bns:index" data-type="number"/>
					<call-template name="branchlist">
						<with-param name="as" select="$descriptor"/>
					</call-template>
				</for-each>
				<for-each select="bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
					<sort select="bns:index" lang="en" case-order="upper-first"/>
					<call-template name="branchlist">
						<with-param name="as" select="$descriptor"/>
					</call-template>
				</for-each>
			</when>
			<otherwise>
				<html:li>
					<attribute name="value">
						<choose>
							<when test="document($corpus_rdf, $corpus_base)//*[@rdf:about=string($descriptor)]/bns:index[@rdf:datatype='&integer;']">
								<value-of select="document($corpus_rdf, $corpus_base)//*[@rdf:about=string($descriptor)]/bns:index"/>
							</when>
							<otherwise>
								<text>0</text>
							</otherwise>
						</choose>
					</attribute>
					<element name="html:{$tag}">
						<if test="not($parent)">
							<attribute name="href">
								<text>#</text>
								<call-template name="anchor"/>
							</attribute>
						</if>
						<for-each select="document($corpus_rdf, $corpus_base)//*[@rdf:about=string($descriptor)]">
							<call-template name="namedformat"/>
							<if test="bns:fullTitle">
								<text> – </text>
								<html:cite>
									<apply-templates select="bns:fullTitle[1]" mode="contents"/>
								</html:cite>
							</if>
						</for-each>
					</element>
					<if test="$parent">
						<html:ol>
							<for-each select="bns:includes/*[bns:index/@rdf:datatype='&integer;']">
								<sort select="bns:index" data-type="number"/>
								<call-template name="branchlist"/>
							</for-each>
							<for-each select="bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
								<sort select="bns:index" lang="en" case-order="upper-first"/>
								<call-template name="branchlist"/>
							</for-each>
						</html:ol>
					</if>
				</html:li>
			</otherwise>
		</choose>
	</template>
	<template name="branchlist">
		<param name="as"/>
		<choose>
			<when test="bns:hasProject">
				<html:ol>
					<for-each select="bns:hasProject/*">
						<sort select="bns:index" data-type="number"/>
						<for-each select="bns:includes/*[bns:index/@rdf:datatype='&integer;']">
							<sort select="bns:index" data-type="number"/>
							<call-template name="branchlist"/>
						</for-each>
						<for-each select="bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
							<sort select="bns:index" lang="en" case-order="upper-first"/>
							<call-template name="branchlist"/>
						</for-each>
					</for-each>
				</html:ol>
			</when>
			<when test="document($index_rdf)//bns:branch[@rdf:resource=current()/@rdf:about]">
				<call-template name="branchlistitem">
					<with-param name="as" select="$as"/>
				</call-template>
			</when>
			<otherwise>
				<variable name="included">
					<for-each select=".//bns:includes/*">
						<if test="document($index_rdf)//bns:branch[@rdf:resource=current()/@rdf:about]">.</if>
					</for-each>
				</variable>
				<if test="string($included)!=''">
					<call-template name="branchlistitem">
						<with-param name="parent" select="true()"/>
						<with-param name="as" select="$as"/>
					</call-template>
				</if>
			</otherwise>
		</choose>
	</template>
	<template match="html:nav[@id='BNS-Index']">
		<html:div id="BNS-Index--Wrapper">
			<copy>
				<for-each select="@*">
					<copy/>
				</for-each>
				<for-each select="document($index_rdf)//bns:Index[1]">
					<if test="bns:hasCover/*">
						<html:div class="COVER">
							<choose>
								<when test="bns:hasCover/*[1][../@rdf:parseType='Resource']">
									<apply-templates select="bns:hasCover/*[1]/.." mode="contents"/>
								</when>
								<otherwise>
									<apply-templates select="bns:hasCover/*[1]" mode="contents"/>
								</otherwise>
							</choose>
						</html:div>
					</if>
					<html:h1>
						<html:a href="#">
							<apply-templates select="bns:fullTitle[1]" mode="contents"/>
						</html:a>
					</html:h1>
				</for-each>
				<for-each select="document($corpus_rdf, $corpus_base)//bns:Corpus">
					<call-template name="branchlist"/>
				</for-each>
				<html:footer>
					<html:a href="{document($index_rdf)//bns:Index/bns:indexes/@rdf:resource}">View full corpus</html:a>
				</html:footer>
			</copy>
			<for-each select="document($corpus_rdf, $corpus_base)//bns:includes/*">
				<if test="document($index_rdf)//bns:branch[@rdf:resource=current()/@rdf:about]">
					<html:article hidden="">
						<attribute name="id">
							<call-template name="anchor"/>
						</attribute>
						<html:header>
							<html:p>
								<for-each select="ancestor-or-self::*[self::bns:Project or self::bns:Book or self::bns:Volume or self::bns:Arc or self::bns:Side or self::bns:Chapter or self::bns:Section or self::bns:Verse][position()!=1]">
									<if test="position()!=1">
										<text> ∷ </text>
									</if>
									<choose>
										<when test="bns:fullTitle">
											<html:ruby>
												<apply-templates select="bns:fullTitle[1]" mode="contents"/>
												<html:rp> (</html:rp>
												<html:rt>
													<call-template name="namedformat"/>
												</html:rt>
												<html:rp>)</html:rp>
											</html:ruby>
										</when>
										<otherwise>
											<call-template name="namedformat"/>
										</otherwise>
									</choose>
								</for-each>
							</html:p>
							<html:h2>
								<for-each select="ancestor-or-self::*[self::bns:Project or self::bns:Book or self::bns:Volume or self::bns:Arc or self::bns:Side or self::bns:Chapter or self::bns:Section or self::bns:Verse][1]">
									<call-template name="namedformat"/>
									<if test="bns:fullTitle">
										<text> – </text>
										<html:cite>
											<apply-templates select="bns:fullTitle[1]" mode="contents"/>
										</html:cite>
									</if>
								</for-each>
							</html:h2>
						</html:header>
						<apply-templates select="." mode="files"/>
					</html:article>
				</if>
			</for-each>
			<html:div class="SPACER"/>
		</html:div>
	</template>
</stylesheet>
