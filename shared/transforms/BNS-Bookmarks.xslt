<!DOCTYPE stylesheet [
	<!ENTITY NCName "http://www.w3.org/2001/XMLSchema#NCName">
	<!ENTITY gYearMonth "http://www.w3.org/2001/XMLSchema#gYearMonth">
	<!ENTITY integer "http://www.w3.org/2001/XMLSchema#integer">
	<!ENTITY date "http://www.w3.org/2001/XMLSchema#date">
]>
<!--
⁌ Branching Notational System Bookmarks X·S·L Transformation (BNS-Bookmarks.xslt)

§ Usage :—

Requires both X·S·L·T 1.0 and E·X·S·L·T Common support.  C·S·S features require at least Firefox 76 / Safari 14.1 / Chrome 89.  Stick the following at the beginning of your X·M·L file :—

	<?xml-stylesheet type="text/xsl" href="/path/to/BNS-Bookmarks.xslt"?>

§§ Configuration (in the file which links to this stylesheet) :—

• The first <html:link rel="alternate" type="application/rdf+xml"> element with an @href attribute is used to source the R·D·F for the bookmarks.

• Exactly one <html:div id="BNS-Bookmarks"> must be supplied; the bookmarks will be placed in here!

• Feel free to add your own <html:style> elements or other content.

§§ Things to be sure to define :—

• <bns:fullTitle> is used for titles of branches.  <bns:shortTitle> takes preference in limited situations (navigational lists).

• <bns:description> is used for branch summaries.  Note that this is an object property; it should point to a thing.

• <bns:contents> gives the contents of a thing, most importantly the thing pointed by <bns:description>.  X·M·L contents are supported with @rdf:parseType='Literal'.

• @xml:lang or @rdf:datatype every time you specify a literal.

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
	<variable name="rdf" select="//html:link[@rel='alternate'][@type='application/rdf+xml']/@href[1]"/>
	<template name="anchor">
		<choose>
			<when test="owl:sameAs[starts-with(@rdf:resource, './#') or starts-with(@rdf:resource, '#')]">
				<value-of select="substring-after(owl:sameAs[starts-with(@rdf:resource, './#') or starts-with(@rdf:resource, '#')][1]/@rdf:resource, '#')"/>
			</when>
			<otherwise>
				<value-of select="@rdf:about"/>
			</otherwise>
		</choose>
	</template>
	<template name="tagname">
		<choose>
			<when test="bns:contents">
				<apply-templates select="." mode="contents"/>
			</when>
			<when test="bns:identifier">
				<html:code>
					<value-of select="bns:identifier"/>
				</html:code>
			</when>
			<otherwise>
				<html:code>
					<call-template name="anchor"/>
				</html:code>
			</otherwise>
		</choose>
	</template>
	<template match="*" mode="contents">
		<choose>
			<when test="@rdf:parseType='Literal'">
				<apply-templates/>
			</when>
			<when test="bns:contents">
				<apply-templates select="bns:contents" mode="contents"/>
			</when>
			<otherwise>
				<html:span lang="{@xml:lang}">
					<value-of select="."/>
				</html:span>
			</otherwise>
		</choose>
	</template>
	<template match="html:*|svg:*">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<apply-templates/>
		</copy>
	</template>
	<template match="html:head">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<html:style>
html{ Margin: 0; Padding: 0; Color: Var(--Text); Background: Var(--Background); Font-Family: Var(--Serif); Line-Height: 1.25; --Background: Canvas; --Canvas: Canvas; --Fade: GrayText; --Magic: LinkText; --Text: CanvasText; --Attn: ActiveText; --Bold: VisitedText; --Shade: CanvasText; --Sans: Sans-Serif; --Serif: Serif; --Mono: Monospace }
body{ Margin: 0; Padding: 0 }
#BNS-Bookmarks{ Margin-Inline: Auto; Padding: 2REM; Max-Inline-Size: 44REM }
#BNS-Bookmarks>article{ Margin-Block: 2REM; Border: Medium Var(--Shade) Solid; Border-Radius: 1REM; Padding: 1REM; Color: Var(--Text); Background: Var(--Canvas) }
#BNS-Bookmarks>article>header{ Margin: 1REM; Border: Thin Var(--Shade) Solid; Padding: 1REM; Color: Var(--Text); Background: Var(--Background); Font-Size: 1.5REM; Text-Align: Center }
#BNS-Bookmarks>article>header>div{ Padding-Inline: 1REM; Font-Size: 1REM; Text-Align: Justify }
#BNS-Bookmarks>article h2{ Margin-Block: 0 1REM; Font-Size: 2REM; Font-Style: Italic; Font-Weight: Inherit}
#BNS-Bookmarks>article>div{ Position: Relative; Margin-Block: 1.5REM; Margin-Inline: 1REM; Padding-Block: 1REM; Padding-Inline: 1REM; Color: Var(--Text); Background: Var(--Background); Z-Index: 0 }
#BNS-Bookmarks>article>div p{ Margin: 0 }
#BNS-Bookmarks>article>div p+p{ Margin-Block-Start: .75REM }
#BNS-Bookmarks>article>div::before{ Position: Absolute; Inset-Block: -.5REM; Inset-Inline: -1REM; Opacity: .5; Background: Inherit; Z-Index: -1; Content: "" }
#BNS-Bookmarks>article footer{ Margin-Block: 1REM 0; Border-Block-Start: Thin Var(--Shade) Solid; Padding-Block: 1REM 0; Padding-Inline: 1REM }
#BNS-Bookmarks>article footer h3{ Display: Inline; Margin: 0; Font-Size: Inherit }
#BNS-Bookmarks>article footer h3::after{ Content: ": " }
#BNS-Bookmarks>article footer ul,#BNS-Bookmarks>article footer li{ All: Unset }
#BNS-Bookmarks>article footer li+li::before{ Content: ", " }
#BNS-Bookmarks--Tags{ Text-Align: Center }
#BNS-Bookmarks--Tags h2{ Margin: 0; Font-Family: Var(--Sans); Text-Decoration: Underline; Text-Decoration-Skip-Ink: None }
#BNS-Bookmarks--Tags ul{ Display: Block; Padding: 0 }
#BNS-Bookmarks--Tags li{ All: Unset }
#BNS-Bookmarks--Tags li+li::before{ Content: " " }
#BNS-Bookmarks--Tags li>a{ Display: Inline-Block; Margin: 0; Border: Thin Var(--Magic) Solid; Border-Radius: .25REM; Padding-Inline: .5REM; Block-Size: 1.25REM; Color: Var(--Text); Text-Decoration: None }
#BNS-Bookmarks--Tags li>a.TARGETED{ Background: Var(--Magic); Color: Var(--Background) }
*:Any-Link{ Color: Var(--Text) }
*:Any-Link:Hover{ Color: Var(--Fade) }
button,sup,sub{ Font-Size: .625EM; Line-Height: 1 }
code{ Overflow-Wrap: Break-Word; Font-Family: Var(--Mono) }
strong{ Color: Var(--Attn) }
a:Hover strong{ Color: Var(--Shade) }
time:Not([datetime]){ White-Space: NoWrap }
			</html:style>
			<html:script type="module">
const filterArticlesByTag= () => {
  const tag= location.hash.substring(1)
  for (
    const a of document.querySelectorAll("#BNS-Bookmarks--Tags li>a")
  ) {
    a.classList[
      a.hash.substring(1) == tag ? "add" : "remove"
    ]("TARGETED")
  }
  if ( possibleTags.includes(tag) )
    for (
      const elt of document.querySelectorAll("#BNS-Bookmarks>article")
    ) {
      elt.hidden= !(
        elt.dataset.tags?.split?.(" ") ?? []
      ).includes(tag)
    }
  else
    for (
      const elt of document.querySelectorAll("#BNS-Bookmarks>article")
    ) {
      elt.hidden= false
}   }
const possibleTags= Array.from
  ( document.querySelectorAll("#BNS-Bookmarks--Tags li>a") )
  .map(a => a.hash.substring(1))
mainScript: {
  window.addEventListener("hashchange", filterArticlesByTag)
  filterArticlesByTag()
}
			</html:script>
			<apply-templates/>
		</copy>
	</template>
	<template match="html:div[@id='BNS-Bookmarks']">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<if test="document($rdf)//bns:Tag">
				<html:nav id="BNS-Bookmarks--Tags">
					<html:h2 lang="en">Available Tags</html:h2>
					<html:ul>
						<for-each select="document($rdf)//bns:Tag">
							<html:li>
								<html:a>
									<attribute name="href">
										<text>#</text>
										<call-template name="anchor"/>
									</attribute>
									<call-template name="tagname"/>
								</html:a>
							</html:li>
						</for-each>
					</html:ul>
					<html:span lang="en">
						<text>or, </text>
						<html:a href="#">click here to view all works</html:a>
						<text>.</text>
					</html:span>
				</html:nav>
			</if>
			<for-each select="document($rdf)//bns:Bookmark">
				<html:article>
					<attribute name="id">
						<call-template name="anchor"/>
					</attribute>
					<if test="bns:hasTag">
						<attribute name="data-tags">
							<for-each select="bns:hasTag">
								<if test="position()!=1">
									<text> </text>
								</if>
								<for-each select="document($rdf)//bns:Tag[@rdf:about=current()/@rdf:resource][1]">
									<call-template name="anchor"/>
								</for-each>
							</for-each>
						</attribute>
					</if>
					<for-each select="bns:isBookmarkOf/*">
						<html:header>
							<html:h2>
								<html:a href="{@rdf:about}">
									<apply-templates select="bns:fullTitle" mode="contents"/>
								</html:a>
							</html:h2>
							<for-each select="bns:hasAuthor/*">
								<choose>
									<when test="position()=1"/>
									<when test="position()=last()">
										<text> &amp; </text>
									</when>
									<otherwise>
										<text>, </text>
									</otherwise>
								</choose>
								<html:a href="{@rdf:about}">
									<apply-templates select="bns:fullTitle" mode="contents"/>
								</html:a>
							</for-each>
							<html:div>
								<apply-templates select="bns:hasDescription" mode="contents"/>
							</html:div>
						</html:header>
					</for-each>
					<html:div>
						<apply-templates select="bns:hasDescription" mode="contents"/>
					</html:div>
					<if test="bns:hasTag">
						<html:footer>
							<html:h3 lang="en">Tags</html:h3>
							<html:ul>
								<for-each select="bns:hasTag">
									<for-each select="document($rdf)//bns:Tag[@rdf:about=current()/@rdf:resource][1]">
										<html:li>
											<html:a>
												<attribute name="href">
													<text>#</text>
													<call-template name="anchor"/>
												</attribute>
												<call-template name="tagname"/>
											</html:a>
										</html:li>
									</for-each>
								</for-each>
							</html:ul>
						</html:footer>
					</if>
				</html:article>
			</for-each>
		</copy>
	</template>
</stylesheet>
