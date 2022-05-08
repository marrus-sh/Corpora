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
body{ Box-Sizing: Border-Box; Margin-Block: Calc(26REM - 50VW) 0; Margin-Inline: 0; Padding-Block: Calc(50VW - 26REM); Padding-Inline: 0; Min-Block-Size: Calc(50VW - 26REM + 100VH); Box-Shadow: Inset 0 0 Calc(50VW - 26REM) Var(--Shade);  }
@media ( max-width: 52REM ) {
	body{ Margin-Block: 0; Min-Block-Size: 0 } }
#BNS-Bookmarks{ Display: Grid; Margin-Inline: Auto; Padding-Block: 2REM; Padding-Inline: 4REM; Max-Inline-Size: 44REM; Overflow: Hidden; Grid-Template-Columns: 100%; Counter-Reset: Article }
@media ( max-width: 53REM ) {
	#BNS-Bookmarks{ Margin-Inline-Start: 0; Padding-Inline-End: 1REM } }
#BNS-Bookmarks>article{ Position: Relative; Margin-Block: 1.5REM; Border: 3PX Var(--Shade) Solid; Border-Radius: 1REM; Padding: 1REM; Color: Var(--Text); Background: Var(--Canvas); Z-Index: 0; Counter-Increment: Article }
#BNS-Bookmarks>article::before{ Display: Block; Position: Absolute; Inset-Block-Start: 1REM; Inset-Inline-End: 100%; Min-Inline-Size: 4REM; Color: Fade; Opacity: .6; Font-Size: 1.25EM; Font-Weight: Bold; Line-Height: 1; Text-Align: Center; Content: "№" Counter(Article, Decimal-Leading-Zero) }
#BNS-Bookmarks>article:Target::before{ Content: "⁎" }
#BNS-Bookmarks>article::after{ Display: Block; Position: Absolute; Inset-Block-Start: 100%; Inset-Inline: -1REM; Margin-Block-Start: 3PX; Border-Block-End: Thin Var(--Fade) Dashed; Padding-Block: .25REM;  Padding-Inline: 1REM; Color: Var(--Fade); Opacity: .6; White-Space: NoWrap; Line-Height: 1; Text-Align: End; Content: "#" Attr(id) }
#BNS-Bookmarks>article:Not(:Has(~article:Not([hidden])))::after{ Border-Block-End: None }
#BNS-Bookmarks>article>header{ Margin: 1REM; Border: Thin Var(--Shade) Solid; Padding: 1REM; Color: Var(--Text); Background: Var(--Background); Font-Size: 1.5REM; Text-Align: Center }
#BNS-Bookmarks>article>header>div{ Margin-Block: 1REM; Padding-Inline: 1REM; Font-Size: 1REM; Text-Align: Justify }
#BNS-Bookmarks>article>header>h2{ Margin-Block: 0 1REM; Font-Size: 2REM; Font-Style: Italic; Font-Weight: Inherit}
#BNS-Bookmarks>article>div{ Position: Relative; Margin-Block: 1.5REM; Margin-Inline: 1REM; Padding-Block: 1REM; Padding-Inline: 1REM; Color: Var(--Text); Background: Var(--Background); Z-Index: 0 }
#BNS-Bookmarks>article>div::before{ Position: Absolute; Inset-Block: -.5REM; Inset-Inline: -1REM; Opacity: .5; Background: Inherit; Z-Index: -1; Content: "" }
#BNS-Bookmarks>article>div>div:Not(:First-Child){ Margin-Block-Start: 1.5REM; Border-Block-Start: Thin Var(--Fade) Dashed; Padding-Block-Start: 1.5REM }
#BNS-Bookmarks>article>footer{ Border-Color: Var(--Shade); Padding-Inline: 1REM; Color: Var(--Text); Font-Family: Var(--Sans) }
#BNS-Bookmarks>article>footer h3{ All: Unset; Font-Weight: Bold }
#BNS-Bookmarks>article>footer h3::after{ Content: ": " }
#BNS-Bookmarks>article>footer ul,#BNS-Bookmarks>article>footer li{ All: Unset }
#BNS-Bookmarks>article>footer li+li::before{ Content: ", " }
#BNS-Bookmarks--Tags{ Margin-Inline: -1REM; Border: Thin Var(--Fade) Dashed; Padding-Block: .5REM; Padding-Inline: 2REM; Text-Align: Center; Font-Family: Var(--Sans) }
#BNS-Bookmarks--Tags h2{ Margin-Block: 0; Font-Family: Var(--Sans); Text-Decoration: Underline; Text-Decoration-Skip-Ink: None }
#BNS-Bookmarks--Tags ul{ Display: Block; Position: Relative; Margin-Block: 1REM; Margin-Inline: 0; Border: None; Padding: 0; Line-Height: 1.5 }
#BNS-Bookmarks--Tags ul::before{ Position: Absolute; Inset-Block: 1REM; Inset-Inline: 1REM; Background: Var(--Background); Box-Shadow: 0 0 3REM 3REM Var(--Background); Z-Index: -1; Content: "" }
#BNS-Bookmarks--Tags li{ All: Unset }
#BNS-Bookmarks--Tags li+li::before{ Content: " " }
#BNS-Bookmarks--Tags li>a{ Display: Inline-Block; Margin: 0; Border: Thin Var(--Magic) Solid; Border-Radius: .25REM; Padding-Inline: .5REM; Color: Var(--Text); Line-Height: 1.25; Text-Decoration: None }
#BNS-Bookmarks--Tags li>a.TARGETED{ Background: Var(--Magic); Color: Var(--Background) }
article{ Padding-Inline: 1REM }
footer{ Margin-Block: 1REM 0; Border-Block-Start: Thin Var(--Fade) Solid; Padding-Block: 1REM 0; Color: Var(--Fade) }
h3{ Margin: Auto; Margin-Block: 1.25REM 1REM; Margin-Inline: Auto; Border-Block-End: Thin Solid; Padding-Block-End: .25REM; Padding-Inline: .5REM; Min-Inline-Size: 40%; Inline-Size: Max-Content; Max-Inline-Size: 100%; Font-Size: 1.5REM; Text-Align: Center }
ol,ul{ Margin-Block: .25EM; Margin-Inline: -1PX 0; Border-Inline-Start: 1PX Var(--Fade) Dashed; Padding-Block: .5EM; Padding-Inline: 4CH 0 }
ol{ List-Style-Type: Decimal-Leading-Zero }
ul{ List-Style-Type: Circle }
li{ Margin: 0 }
p{ Margin: 0; Text-Align: Justify }
li+li,p+p{ Margin-Block-Start: .75EM }
hr{ Margin-Block: .5EM; Border-Block-Start: Thin Var(--Fade) Solid; Border-Block-End: None; Border-Inline: None }
*:Any-Link{ Color: Var(--Text) }
*:Any-Link:Hover{ Color: Var(--Fade) }
button,sup,sub{ Font-Size: .625EM; Line-Height: 1 }
code{ Overflow-Wrap: Break-Word; Font-Family: Var(--Mono) }
strong{ Color: Var(--Attn) }
a:Hover strong{ Color: Var(--Shade) }
time:Not([datetime]){ White-Space: NoWrap }
			</html:style>
			<html:script>
const filterArticlesByTag= function ( ) {
  const hash= location.hash.substring(1)
  for (
    const a of document.querySelectorAll("#BNS-Bookmarks--Tags li>a")
  ) {
    a.classList[
      a.hash.substring(1) == hash ? "add" : "remove"
    ]("TARGETED")
  }
  if ( this.includes(hash) )
    for (
      const elt of document.querySelectorAll("#BNS-Bookmarks>article")
    ) {
      elt.hidden= !(
        elt.dataset.tags?.split?.(" ") ?? []
      ).includes(hash)
      const remarks=
        elt.querySelector("#BNS-Bookmarks>article>div>div.REMARKS")
      if ( remarks != null )
        remarks.firstElementChild.hidden=
          !(remarks.lastElementChild.hidden= true)
    }
  else if (
    hash
    &amp;&amp; document.getElementById(hash)
       ?.matches
       ?.("#BNS-Bookmarks>article")
  )
    for (
      const elt of document.querySelectorAll("#BNS-Bookmarks>article")
    ) {
      elt.hidden= !(elt.id == hash)
      const remarks=
        elt.querySelector("#BNS-Bookmarks>article>div>div.REMARKS")
      if ( remarks != null )
        remarks.firstElementChild.hidden=
          !(remarks.lastElementChild.hidden= false)
    }
  else
    for (
      const elt of document.querySelectorAll("#BNS-Bookmarks>article")
    ) {
      elt.hidden= false
      const remarks=
        elt.querySelector("#BNS-Bookmarks>article>div>div.REMARKS")
      if ( remarks != null )
        remarks.firstElementChild.hidden=
          !(remarks.lastElementChild.hidden= true)
}   }
window.addEventListener
  ( "load"
  , () => {
      const possibleTags= Array.from
        ( document.querySelectorAll("#BNS-Bookmarks--Tags li>a") )
        .map(a => a.hash.substring(1))
      window.addEventListener
        ( "hashchange"
        , filterArticlesByTag.bind(possibleTags) )
      filterArticlesByTag.call(possibleTags)
    } )
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
							<sort select="bns:contents"/>
							<sort select="bns:identifier"/>
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
				<sort select="substring-before(substring-after(owl:sameAs[starts-with(@rdf:resource, './#') or starts-with(@rdf:resource, '#')][1]/@rdf:resource, '#'), '-')"/>
				<sort select="substring-after(substring-after(owl:sameAs[starts-with(@rdf:resource, './#') or starts-with(@rdf:resource, '#')][1]/@rdf:resource, '#'), '-')" data-type="number"/>
				<sort select="bns:identifier"/>
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
						<html:div class="DESCRIPTION">
							<apply-templates select="bns:hasDescription" mode="contents"/>
						</html:div>
						<if test="bns:hasRemark">
							<html:div class="REMARKS">
								<html:a lang="en">
									<attribute name="href">
										<text>#</text>
										<call-template name="anchor"/>
									</attribute>
									<text>Click to view full remarks.</text>
								</html:a>
								<html:article hidden="">
									<html:h3>Remarks</html:h3>
									<apply-templates select="bns:hasRemark" mode="contents"/>
								</html:article>
							</html:div>
						</if>
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
