<!DOCTYPE stylesheet [
	<!ENTITY NCName "http://www.w3.org/2001/XMLSchema#NCName">
	<!ENTITY gYearMonth "http://www.w3.org/2001/XMLSchema#gYearMonth">
	<!ENTITY integer "http://www.w3.org/2001/XMLSchema#integer">
	<!ENTITY date "http://www.w3.org/2001/XMLSchema#date">
]>
<!--
⁌ Branching Notational System X·S·L Transformation (BNS.xslt)

§ Usage :—

Requires both X·S·L·T 1.0 and E·X·S·L·T Common support.  C·S·S features require at least Firefox 76 / Safari 14.1 / Chrome 89.  Stick the following at the beginning of your X·M·L file :—

	<?xml-stylesheet type="text/xsl" href="/path/to/BNS.xslt"?>

§§ Configuration (in the file which links to this stylesheet) :—

• The first <html:link rel="alternate" type="application/rdf+xml"> element with an @href attribute is used to source the R·D·F for the corpus.

• The @lang attribute on the document element is used to prioritize titles from fetched resources.

• The @prefix attribute on the <html:html> element (with the R·D·F∕A syntax) is used for shortening of displayed links.

• Exactly one <html:article id="BNS"> must be supplied; the corpus will be placed in here!

• Feel free to add your own <html:style> elements or other content.

§§ Things to be sure to define :—

• <bns:fullTitle> is used for titles of branches.  <bns:shortTitle> takes preference in limited situations (navigational lists).

• <bns:description> is used for branch summaries.  Note that this is an object property; it should point to a thing.

• <bns:contents> gives the contents of a thing, most importantly the thing pointed by <bns:description>.  X·M·L contents are supported with @rdf:parseType='Literal'.

• @xml:lang or @rdf:datatype every time you specify a literal.

§§ Things which are supported :—

• @rdf:parseType="Resource" and @rdf:parseType="Literal" in #most of the places where they would make sense.

• <html:a><html:code></html:code></html:a> is a special syntax which will generate a button that will attempt to fetched the title of the linked resource when clicked.  You can use the @resource attribute to specify a name for the resource, if it differs from the @href (which should point to its data).  The script will automatically convert ‹ http: › to ‹ https: ›, and handles Wikidata links as a special case.

• The R·D·F∕A Core Initial Context (so you needn’t provide those prefixes).

§§ Things notably not supported :—

• Relative values for @rdf:about on branches, or, similarly, any use of @rdf:ID (as in either case this requires I·R·I processing).

• Relative values #in general# unless the base U·R·I’s of this stylesheet and the document it is being linked from are the same (or equivalent).

• A non‐nested structure for branches:  This stylesheet does not attempt to resolve @rdf:resource in #most cases.

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
	<variable name="rdf" select="//html:link[@rel='alternate'][@type='application/rdf+xml']/@href[1]"/>
	<template match="html:head">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<call-template name="helper-css"/>
			<html:style>
@keyframes In-From-Start{
	from{ Inset-Inline: -100%; Opacity: 0 }
	to{ Inset-Inline: 0; Opacity: 1 } }
@keyframes In-From-End{
	from{ Inset-Inline: 100%; Opacity: 0 }
	to{ Inset-Inline: 0; Opacity: 1 } }
@keyframes Out-To-Start{
	from{ Inset-Inline: 0; Opacity: 1 }
	to{ Inset-Inline: -100%; Opacity: 0 } }
@keyframes Out-To-End{
	from{ Inset-Inline: 0; Opacity: 1 }
	to{ Inset-Inline: 100%; Opacity: 0 } }
#BNS{ Display: Flex; Position: Relative; Box-Sizing: Border-Box; Margin-Block: 0 2REM; Margin-Inline: Auto; Border-End-Start-Radius: 4REM; Border-End-End-Radius: 4REM; Padding-Block: 1REM; Padding-Inline: 5REM; Min-Block-Size: Calc(100VH - 2REM); Inline-Size: 54REM; Max-Inline-Size: 100%; Flex-Direction: Column; Color: Var(--Text); Background: Var(--Background); Font-Family: Serif; Line-Height: 1.25; Z-Index: Auto }
#BNS::after{ Display: Block; Position: Absolute; Inset-Block: Auto -2EM; Inset-Inline: 0; Block-Size: 6REM; Background: Var(--Shade); Z-Index: -1; Content: "" }
#BNS>header{ Flex: None }
#BNS>header>h1{ Display: Block; Margin-Block: .5REM; Color: Var(--Text); Font-Size: XX-Large; Font-Family: Sans-Serif; Text-Align: Center }
#BNS>header>h1>a{ Color: Var(--Shade) }
#BNS>header>h1>a:Hover{ Color: Var(--Attn) }
#BNS>header>nav{ Font-Size: Medium; Margin-Block: .5REM 1REM; Color: Var(--Text); Font-Family: Sans-Serif; Text-Align: Justify; Text-Align-Last: Center }
#BNS>header>nav>ol,#BNS>header>nav>ol>li{ Display: Inline; Margin: 0; Padding: 0 }
#BNS>header>nav>ol>li::after{ Content: "\200B" }
#BNS>header>nav>ol>li+li::before{ Margin-Inline-Start: .5EM; Border-Inline-Start: Thin Solid; Padding-Inline-Start: .5EM; Content: "" }
#BNS>header>nav a{ Color: Var(--Text); Text-Decoration: None }
#BNS>header>nav a:Focus,#BNS>header>nav a:Hover{ Text-Decoration: Underline }
#BNS>div{ Position: Relative; Flex: Auto; Margin-Block: 0 -1REM; Margin-Inline: -5REM; Min-Block-Size: 24REM; Overflow: Hidden }
#BNS>div>*{ Display: Grid; Position: Absolute; Box-Sizing: Border-Box; Inset-Block: 0; Inset-Inline: 0 Auto; Border: .25REM Var(--Shade) Solid; Border-Radius: 4REM; Padding: 2REM; Inline-Size: 100%; Gap: 1REM 2REM; Grid-Template-Rows: Min-Content 1FR Min-Content; Grid-Template-Columns: 1FR 23EM; Overflow: Auto; Background: Var(--Canvas) }
#BNS>div>*[data-slide=in]{ Animation: In-From-End 1S Both }
#BNS>div>*[data-direction=reverse][data-slide=in]{ Animation: In-From-Start 1S Both }
#BNS>div>*[data-slide=out]{ Animation: Out-To-Start 1S Both }
#BNS>div>*[data-direction=reverse][data-slide=out]{ Animation: Out-To-End 1S Both }
#BNS>div>*[hidden]{ Display: None }
#BNS>div>*>header,#BNS>div>*>header+section,#BNS>div>*>div,#BNS>div>*>footer{ Grid-Column: 1 / Span 2 }
#BNS>div>*>header{ Display: Grid; Grid-Auto-Flow: Dense Column; Grid-Row: 1 / Span 1; Margin-Block: -1REM 0; Margin-Inline: -2REM; Border-Block-End: Thin Var(--Shade) Solid; Padding-Block: 0 1REM; Padding-Inline: 2REM; Grid-Template-Rows: Auto Auto Auto; Grid-Template-Columns: Auto 1EM 1EM Max-Content 1EM 1EM Auto; Gap: .3125EM .5REM; Text-Align: Center }
#BNS>div>*>header>p{ Grid-Column: 2 / Span 5; Margin-Block: 0; Min-Inline-Size: Max-Content; Color: Var(--Bold); Font-Variant-Caps: Small-Caps; Text-Align: Center; Text-Decoration: Underline }
#BNS>div>*>header>p>a{ Color: Inherit }
#BNS>div>*>header>p>a:Focus,#BNS>div>*>header>p>a:Hover{ Color: Var(--Shade); Text-Decoration: Double Underline }
#BNS>div>*>header>hgroup>h2{ Grid-Column: 1 / Span 7; Margin-Block: 0; Inline-Size: Min-Content; Min-Inline-Size: 100%; Color: Var(--Shade); Font-Size: X-Large; Font-Family: Sans-Serif; Line-Height: 1 }
#BNS>div>*>header>hgroup>h3{ Grid-Column: 4 / Span 1; Margin-Block: 0; Color: Var(--Attn); Font-Size: Inherit; Font-Weight: Inherit; Font-Variant-Caps: Small-Caps }
#BNS>div>*>header>hgroup,#BNS>div>*>header>nav{ Display: Contents }
#BNS>div>*>header>nav>a{ Text-Decoration: None }
#BNS>div>*>header>nav>a[data-nav=prev]{ Grid-Column: 2 / Span 1 }
#BNS>div>*>header>nav>a[data-nav=parent]{ Grid-Column: 3 / Span 1 }
#BNS>div>*>header>nav>a[data-nav=child]{ Grid-Column: 5 / Span 1 }
#BNS>div>*>header>nav>a[data-nav=next]{ Grid-Column: 6 / Span 1 }
#BNS>div>*>section{ Display: Flex; Flex-Direction: Column; Box-Sizing: Border-Box; Grid-Row: 2 / Span 1; Margin-Inline: Auto; Border-Block: Thin Var(--Shade) Solid; Padding-Inline: 0 1PX; Inline-Size: 100%; Max-Inline-Size: 23EM; Overflow-Block: Auto; Overflow-Inline: Hidden }
#BNS>div>*>section>*{ Flex: 1; Border-Color: Var(--Shade); Margin-Block: -1PX 0; Border-Block-Style: Solid Double; Border-Block-Width: Thin Medium; Border-Inline-Style: Solid Double; Border-Inline-Width: Thin Medium; Padding-Block: 1EM; Padding-Inline: 1EM; Background: Var(--Background); Box-Shadow: 1PX 1PX Var(--Shade) }
#BNS>div>*>section>*:Not(:Empty)~*{ Margin-Block-Start: Calc(1EM + 1PX) }
#BNS>div>*>section>*:Empty:Not(:Only-Child){ Display: None }
#BNS>div>*>figure{ Display: Grid; Grid-Row: 2 / Span 1; Grid-Column: 1 / Span 1; Margin: 0; Padding: 0; Block-Size: 100%; Inline-Size: 100%; Overflow: Hidden }
#BNS>div>*>figure>*{ Border: None; Grid-Row: 1 / Span 1; Grid-Column: 1 / Span 1; Block-Size: 100%; Inline-Size: 100%; Object-Fit: Contain }
#BNS>div>*>figure>iframe{ Object-Fit: Fill }
#BNS>div>*>div{ Grid-Row: 2 / Span 1 }
#BNS>div>*>footer{ Display: Flex; Grid-Row: 3 / Span 1; Margin-Block: 0 -2REM; Margin-Inline: -2REM; Border-Block-Start: Thin Var(--Shade) Solid; Padding-Block: 1EM; Padding-Inline: 3EM; Max-Inline-Size: Calc(100% + 4REM - 6EM); Justify-Content: Space-Between; Font-Size: Smaller; White-Space: NoWrap }
#BNS>div>*>footer>*:First-Child:Not(:Only-Child){ Flex: None }
#BNS>div>*>footer>*+*:Last-Child{ Display: Grid; Margin-Inline-Start: 1EM; Grid-Template-Columns: Max-Content 1FR Max-Content }
#BNS>div>*>footer>*+*:Last-Child>a{ Max-Inline-Size: 100%; Overflow: Hidden; Text-Overflow: Ellipsis }
#BNS div.FILES{ Margin-Block: -1REM; Margin-Inline: -2REM }
h4{ Margin-Block: 0 .5REM; Margin-Inline: Auto; Border-Width: Thin; Border-Block-Style: Dotted Solid; Border-Block-Color: Var(--Fade) Var(--Shade); Border-Inline-Style: Dashed; Border-Inline-Color: Var(--Text); Padding-Block: .3125EM; Padding-Inline: 1EM; Max-Inline-Size: Max-Content; Color: Var(--Text); Font-Size: X-Large; Font-Family: Sans-Serif; Line-Height: 1; Text-Align: Center }
blockquote,p{ Margin-Block: 0; Margin-Inline: Auto; Text-Align: Justify; Text-Align-Last: Center }
blockquote:Not(:First-Child),p:Not(:First-Child){ Margin-Block: .625EM 0 }
blockquote{ Padding-Inline: 1EM; Font-Style: Italic }
dl,ol,ul{ Margin-Block: 1EM; Margin-Inline: 0; Padding: 0; Text-Align: Start; Text-Align-Last: Auto }
nav ol,nav ul{ Margin-Block: .5REM; List-Style-Type: None }
nav li ol,nav li ul{ Margin-Block: 0 }
li,nav li li,dd{ Margin-Inline: 1REM 0; Padding: 0 }
nav li{ Margin-Inline: 0 }
dl{ Margin-Block: 1EM; Padding-Inline: 0 }
dl:First-Child{ Margin-Block-Start: 0 }
dt{ Margin-Inline: 0; Padding: 0; Font-Weight: Bold }
dd{ Position: Relative; Display: List-Item; List-Style-Type: Square }
dd>ul{ Margin-Block: .25REM .5REM; Margin-Inline: -1REM 0; Border-Block-Start: Thin Transparent Solid; Padding-Block: .25REM 0; Text-Align: End; Font-Size: Smaller }
dd>ul::before{ Box-Sizing: Border-Box; Position: Absolute; Inset-Inline: 0; Margin-Block: -.5REM 0; Border-Block-End: Thin Var(--Fade) Dashed; Block-Size: .25REM; Content: "" }
dd:Not(:Last-Child)>ul{ Margin-Block-End: .75REM; Border-Block-End: Thin Var(--Text) Solid; Padding-Block-End: .75REM; }
dd>ul>li{ Display: Inline; Margin: 0 }
dd>ul>li::before{ Content: "[" }
dd>ul>li+li::before{ Content: " [" }
dd>ul>li::after{ Content: "]" }
dd>p{ Hyphens: Auto }
			</html:style>
			<call-template name="helper-js"/>
			<html:script>
const finishAnimation= ( { target: element } ) =>
  {
    element.hidden= element.dataset.slide == "out"
    element.removeAttribute("data-slide")
    element.removeAttribute("data-direction")
    element.removeEventListener("animationend", finishAnimation)
  }
window.addEventListener
  ( "load"
  , ( ) => {
    const div= document.querySelector("#BNS>div")
    div.removeChild(div.firstElementChild)
    let element= location.hash.length > 1 ? document.getElementById
      ( decodeURIComponent(location.hash.substring(1)) )
    : null
    if ( !element || !element.matches("#BNS>div>*") )
      element= document.querySelector("#BNS>div>*")
    for ( const panel of document.querySelectorAll("#BNS>div>*") ) {
      if ( !(panel.hidden= panel != element) )
        displayMediaIn(panel)
  } } )
window.addEventListener
  ( "hashchange"
  , event =>
    {
      if ( 1 >= location.hash.length )
        return
      let met= false
      const anchor= decodeURIComponent(location.hash.substring(1))
      const element= document.getElementById(anchor)
      if ( !element || !element.matches("#BNS>div>*") )
        return
      for ( const panel of document.querySelectorAll("#BNS>div>*") ) {
        if ( panel == element ) {
          met= true
          if ( panel.hidden || panel.dataset.slide == "out" ) {
            panel.dataset.slide= "in"
            panel.addEventListener("animationend", finishAnimation)
            panel.hidden= false
            displayMediaIn(panel)
        } }
        else if ( !panel.hidden || panel.dataset.slide == "in" ) {
          panel.dataset.slide= "out"
          if (met)
            panel.dataset.direction= (
              element.dataset.direction= "reverse"
            )
          else
            panel.dataset.direction= (
              element.dataset.direction= "forward"
            )
          panel.addEventListener("animationend", finishAnimation)
      } }
      event.preventDefault()
    } )
document.addEventListener
  ( "keydown"
  , event =>
    {
      let link
      const current= document.querySelector("#BNS>div>*:Not([hidden])")
      const { key }= event
      if ( key == "ArrowRight" || key == "ArrowLeft" )
        event.preventDefault()
      if (
        document.querySelector("#BNS>div>*[data-slide]")
        || !current
      )
        return
      if ( key == "ArrowLeft" )
        link= current.querySelector("a[data-nav=prev]")
      else if ( key == "ArrowUp" )
        link= current.querySelector("a[data-nav=parent]")
      else if ( key == "ArrowDown" )
        link= current.querySelector("a[data-nav=child]")
      else if ( key == "ArrowRight" )
        link= current.querySelector("a[data-nav=next]")
      if ( !link )
        return
      location.hash= link.hash
    } )
			</html:script>
			<apply-templates/>
		</copy>
	</template>
	<template match="html:title">
		<copy>
			<value-of select="document($rdf)//bns:Corpus/bns:fullTitle"/>
		</copy>
	</template>
	<template match="html:a">
		<variable name="result">
			<copy>
				<choose>
					<when test="document($rdf)//bns:includes/*[@rdf:about=current()/@href]|document($rdf)//bns:hasProject/*[@rdf:about=current()/@href]">
						<attribute name="href">
							<text>#</text>
							<for-each select="(document($rdf)//bns:includes/*[@rdf:about=current()/@href]|document($rdf)//bns:hasProject/*[@rdf:about=current()/@href])[1]">
								<call-template name="anchor"/>
							</for-each>
						</attribute>
					</when>
					<otherwise>
						<for-each select="@href">
							<copy/>
						</for-each>
					</otherwise>
				</choose>
				<for-each select="@*[not(name()='href')]">
					<copy/>
				</for-each>
				<apply-templates/>
			</copy>
		</variable>
		<choose>
			<when test="count(*)=1 and html:code">
				<html:span class="LOOKUP">
					<copy-of select="$result"/>
					<text>&#x2060;</text>
					<html:button title="Attempt to fetch link metadata." onclick="getInfo(event)" type="button">[?]</html:button>
				</html:span>
			</when>
			<otherwise>
				<copy-of select="$result"/>
			</otherwise>
		</choose>
	</template>
	<template match="html:article[@id='BNS']">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<for-each select="document($rdf)//bns:Corpus[1]">
				<html:header>
					<html:h1>
						<html:a>
							<attribute name="href">
								<text>#</text>
								<call-template name="anchor"/>
							</attribute>
							<apply-templates select="bns:fullTitle[1]" mode="contents"/>
						</html:a>
					</html:h1>
					<html:nav>
						<html:ol>
							<for-each select="document($rdf)//bns:Project">
								<sort select="bns:index" data-type="number"/>
								<html:li value="{bns:index}">
									<html:a>
										<attribute name="href">
											<text>#</text>
											<call-template name="anchor"/>
										</attribute>
										<html:code style="Font-Size: 1REM">
											<choose>
												<when test="bns:identifier">
													<value-of select="bns:identifier"/>
												</when>
												<otherwise>
													<call-template name="formatted"/>
												</otherwise>
											</choose>
										</html:code>
									</html:a>
								</html:li>
							</for-each>
						</html:ol>
					</html:nav>
				</html:header>
				<html:div>
					<html:span lang="en">Loading…</html:span>
					<apply-templates select="."/>
				</html:div>
			</for-each>
		</copy>
	</template>
	<template name="name">
		<html:hgroup>
			<choose>
				<when test="parent::bns:hasProject|parent::bns:hasNote|self::bns:hasMixtape[@rdf:parseType='Resource']">
					<html:h2>
						<html:span lang="{bns:fullTitle[1]/@xml:lang}">
							<apply-templates select="bns:fullTitle[1]" mode="contents"/>
						</html:span>
					</html:h2>
				</when>
				<when test="ancestor-or-self::*[parent::bns:includes]/bns:fullTitle">
					<html:h2>
						<for-each select="ancestor-or-self::*[parent::bns:includes]/bns:fullTitle[1]">
							<choose>
								<when test="parent::bns:Book|parent::bns:Volume|parent::bns:Arc">
									<if test="../ancestor::*[parent::bns:includes]/bns:fullTitle[1]">
										<text>: </text>
									</if>
									<html:span lang="{@xml:lang}">
										<apply-templates select="." mode="contents"/>
									</html:span>
								</when>
								<when test="parent::bns:Side|parent::bns:Chapter|parent::bns:Section|parent::bns:Verse">
									<if test="../ancestor::*[parent::bns:includes]/bns:fullTitle[1]">
										<text> – </text>
									</if>
									<html:span lang="{@xml:lang}">
										<text>“</text>
										<apply-templates select="." mode="contents"/>
										<text>”</text>
									</html:span>
								</when>
								<when test="parent::bns:Concept|parent::bns:Version|parent::bns:Draft">
									<if test="../ancestor::*[parent::bns:includes]/bns:fullTitle[1]">
										<text> </text>
									</if>
									<html:span lang="{@xml:lang}">
										<text>(</text>
										<apply-templates select="." mode="contents"/>
										<text>)</text>
									</html:span>
								</when>
								<otherwise>
									<html:span lang="{@xml:lang}">
										<apply-templates select="." mode="contents"/>
									</html:span>
								</otherwise>
							</choose>
						</for-each>
					</html:h2>
				</when>
				<when test="bns:fullTitle">
					<html:h2>
						<html:span lang="{bns:fullTitle[1]/@xml:lang}">
							<apply-templates select="bns:fullTitle[1]" mode="contents"/>
						</html:span>
					</html:h2>
				</when>
			</choose>
			<choose>
				<when test="self::bns:Pseud">
					<html:h3 lang="en">
						Branching Notational System
					</html:h3>
				</when>
				<otherwise>
					<html:h3>
						<choose>
							<when test="bns:identifier">
								<value-of select="bns:identifier"/>
							</when>
							<otherwise>
								<choose>
									<when test="self::bns:Version">
										<for-each select="ancestor::bns:Concept[1]">
											<call-template name="formatted"/>
										</for-each>
									</when>
									<when test="self::bns:Draft">
										<for-each select="ancestor::bns:Concept[1]">
											<call-template name="formatted"/>
										</for-each>
										<for-each select="ancestor::bns:Version[1]">
											<call-template name="formatted"/>
										</for-each>
									</when>
								</choose>
								<call-template name="formatted"/>
							</otherwise>
						</choose>
					</html:h3>
				</otherwise>
			</choose>
		</html:hgroup>
	</template>
	<template name="navigate">
		<variable name="siblings">
			<choose>
				<when test="parent::bns:hasProject">
					<for-each select="../../bns:hasProject/*">
						<sort select="bns:index" data-type="number"/>
						<html:span>
							<value-of select="generate-id()"/>
						</html:span>
					</for-each>
				</when>
				<when test="parent::bns:includes">
					<for-each select="../../bns:includes/*[bns:index/@rdf:datatype='&integer;']">
						<sort select="bns:index" data-type="number"/>
						<html:span>
							<value-of select="generate-id()"/>
						</html:span>
					</for-each>
					<for-each select="../../bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
						<sort select="bns:index" lang="en" case-order="upper-first"/>
						<html:span>
							<value-of select="generate-id()"/>
						</html:span>
					</for-each>
				</when>
				<when test="parent::bns:hasNote">
					<for-each select="../../bns:hasNote/*">
						<sort select="self::*[bns:identifier]/bns:identifier|self::*[not(bns:identifier)]/bns:fullTitle" lang="en" case-order="upper-first"/>
						<html:span>
							<value-of select="generate-id()"/>
						</html:span>
					</for-each>
				</when>
				<when test="self::bns:hasMixtape[@rdf:parseType='Resource']">
					<for-each select="../../bns:hasMixtape[@rdf:parseType='Resource']">
						<sort select="self::*[bns:identifier]/bns:identifier|self::*[not(bns:identifier)]/bns:fullTitle" lang="en" case-order="upper-first"/>
						<html:span>
							<value-of select="generate-id()"/>
						</html:span>
					</for-each>
				</when>
			</choose>
		</variable>
		<variable name="children">
			<choose>
				<when test="bns:hasProject">
					<for-each select="bns:hasProject/*">
						<sort select="bns:index" data-type="number"/>
						<html:span>
							<value-of select="generate-id()"/>
						</html:span>
					</for-each>
				</when>
				<when test="bns:includes">
					<for-each select="bns:includes/*[bns:index/@rdf:datatype='&integer;']">
						<sort select="bns:index" data-type="number"/>
						<html:span>
							<value-of select="generate-id()"/>
						</html:span>
					</for-each>
					<for-each select="bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
						<sort select="bns:index" lang="en" case-order="upper-first"/>
						<html:span>
							<value-of select="generate-id()"/>
						</html:span>
					</for-each>
				</when>
			</choose>
		</variable>
		<variable name="prev" select="exsl:node-set($siblings)/*[string()=generate-id(current())]/preceding-sibling::*[1]"/>
		<variable name="next" select="exsl:node-set($siblings)/*[string()=generate-id(current())]/following-sibling::*[1]"/>
		<variable name="child" select="exsl:node-set($children)/*[1]"/>
		<html:nav>
			<if test="$prev">
				<html:a data-nav="prev">
					<attribute name="href">
						<text>#</text>
						<for-each select="../../*/*[generate-id()=$prev]">
							<call-template name="anchor"/>
						</for-each>
					</attribute>
					<text>←</text>
				</html:a>
			</if>
			<if test="parent::bns:hasProject/..|parent::bns:includes/..|parent::bns:hasNote/..|self::bns:hasMixtape[@rdf:parseType='Resource']/..">
				<html:a data-nav="parent">
					<attribute name="href">
						<text>#</text>
						<choose>
							<when test="self::bns:hasMixtape[@rdf:parseType='Resource']">
								<for-each select="..">
									<call-template name="anchor"/>
								</for-each>
							</when>
							<otherwise>
								<for-each select="../..">
									<call-template name="anchor"/>
								</for-each>
							</otherwise>
						</choose>
					</attribute>
					<text>↑</text>
				</html:a>
			</if>
			<if test="bns:hasProject/*|bns:includes/*">
				<html:a data-nav="child">
					<attribute name="href">
						<text>#</text>
						<for-each select="*/*[generate-id()=$child]">
							<call-template name="anchor"/>
						</for-each>
					</attribute>
					<text>↓</text>
				</html:a>
			</if>
			<if test="$next">
				<html:a data-nav="next">
					<attribute name="href">
						<text>#</text>
						<for-each select="../../*/*[generate-id()=$next]">
							<call-template name="anchor"/>
						</for-each>
					</attribute>
					<text>→</text>
				</html:a>
			</if>
		</html:nav>
	</template>
	<template name="footer">
		<variable name="anchored">
			<text>#</text>
			<call-template name="anchor"/>
		</variable>
		<html:footer>
			<if test="string($anchored)!=string(@rdf:about)">
				<html:code>
					<value-of select="$anchored"/>
				</html:code>
			</if>
			<if test="@rdf:about">
				<html:code>
					<text>&lt;</text>
					<html:a href="{@rdf:about}">
						<value-of select="@rdf:about"/>
					</html:a>
					<text>></text>
				</html:code>
			</if>
		</html:footer>
	</template>
	<template name="metadata">
		<variable name="contents">
			<if test="bns:isFanworkOf/@rdf:resource">
				<html:div>
					<html:dt>Fandom</html:dt>
					<for-each select="bns:isFanworkOf/@rdf:resource">
						<variable name="link">
							<html:a href="{.}">
								<html:code>
									<call-template name="shorten">
										<with-param name="uri" select="."/>
									</call-template>
								</html:code>
							</html:a>
						</variable>
						<html:dd>
							<apply-templates select="exsl:node-set($link)"/>
						</html:dd>
					</for-each>
				</html:div>
			</if>
			<if test="bns:isInspiredBy/@rdf:resource">
				<html:div>
					<html:dt>Inspiration</html:dt>
					<for-each select="bns:isInspiredBy/@rdf:resource">
						<variable name="link">
							<html:a href="{.}">
								<html:code>
									<call-template name="shorten">
										<with-param name="uri" select="."/>
									</call-template>
								</html:code>
							</html:a>
						</variable>
						<html:dd>
							<apply-templates select="exsl:node-set($link)"/>
						</html:dd>
					</for-each>
				</html:div>
			</if>
			<if test="bns:hasThemeSong">
				<html:div>
					<html:dt>Theme Music</html:dt>
					<for-each select="bns:hasThemeSong">
						<html:dd>
							<if test=".//bns:citation">
								<apply-templates select=".//bns:citation[1]" mode="contents"/>
							</if>
							<if test=".//bns:isMadeAvailableBy//bns:url">
								<html:ul>
									<for-each select=".//bns:isMadeAvailableBy[.//bns:url]">
										<html:li>
											<html:a href="{.//bns:url[1]}">
												<choose>
													<when test=".//bns:siteLabel">
														<apply-templates select=".//bns:siteLabel[1]" mode="contents"/>
													</when>
													<otherwise>
														<call-template name="shorten">
															<with-param name="uri" select=".//bns:url[1]"/>
														</call-template>
													</otherwise>
												</choose>
											</html:a>
										</html:li>
									</for-each>
								</html:ul>
							</if>
						</html:dd>
					</for-each>
				</html:div>
			</if>
			<if test="bns:hasTrack">
				<html:div style="Border: Thin Var(--Text) Solid; Padding-Block: .25REM">
					<html:dt style="Margin-Block-End: .75REM; Border-Block-End: Thin Var(--Text) Solid; Padding-Block-End: .25REM; Padding-Inline: .5REM">Track Listing</html:dt>
					<for-each select="bns:hasTrack">
						<sort select="bns:index" data-type="number"/>
						<html:dd>
							<attribute name="style">
								<text>Margin-Inline: 2.5REM .5REM</text>
								<if test=".//bns:index">
									<text>; List-Style-Type: Decimal-Leading-Zero; Counter-Set: list-item </text>
									<value-of select=".//bns:index[1]"/>
								</if>
							</attribute>
							<for-each select=".//bns:song">
								<if test=".//bns:citation">
									<apply-templates select=".//bns:citation[1]" mode="contents"/>
								</if>
								<if test=".//bns:isMadeAvailableBy//bns:url">
									<html:ul style="Margin-Inline: -2.5REM -.5REM; Padding-Inline: .5REM">
										<for-each select=".//bns:isMadeAvailableBy[.//bns:url]">
											<html:li>
												<html:a href="{.//bns:url[1]}">
													<choose>
														<when test=".//bns:siteLabel">
															<apply-templates select=".//bns:siteLabel[1]" mode="contents"/>
														</when>
														<otherwise>
															<call-template name="shorten">
																<with-param name="uri" select=".//bns:url[1]"/>
															</call-template>
														</otherwise>
													</choose>
												</html:a>
											</html:li>
										</for-each>
									</html:ul>
								</if>
							</for-each>
						</html:dd>
					</for-each>
				</html:div>
			</if>
			<if test="bns:isMadeAvailableBy//bns:url">
				<html:div>
					<html:dt>Published</html:dt>
					<for-each select="bns:isMadeAvailableBy[.//bns:url]">
						<html:dd>
							<html:a href="{.//bns:url[1]}">
								<choose>
									<when test=".//bns:siteLabel">
										<apply-templates select=".//bns:siteLabel[1]" mode="contents"/>
									</when>
									<otherwise>
										<call-template name="shorten">
											<with-param name="uri" select=".//bns:url[1]"/>
										</call-template>
									</otherwise>
								</choose>
							</html:a>
						</html:dd>
					</for-each>
				</html:div>
			</if>
		</variable>
		<if test="string($contents)">
			<html:dl>
				<copy-of select="$contents"/>
			</html:dl>
		</if>
	</template>
	<template name="includes">
		<for-each select="bns:hasProject/*">
			<sort select="bns:index" data-type="number"/>
			<apply-templates select="."/>
		</for-each>
		<for-each select="bns:includes/*[bns:index/@rdf:datatype='&integer;']">
			<sort select="bns:index" data-type="number"/>
			<apply-templates select="."/>
		</for-each>
		<for-each select="bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
			<sort select="bns:index" lang="en" case-order="upper-first"/>
			<apply-templates select="."/>
		</for-each>
		<for-each select="bns:hasNote/*">
			<sort select="self::*[bns:identifier]/bns:identifier|self::*[not(bns:identifier)]/bns:fullTitle" lang="en" case-order="upper-first"/>
			<apply-templates select="."/>
		</for-each>
		<for-each select="bns:hasMixtape[@rdf:parseType='Resource']">
			<sort select="self::*[bns:identifier]/bns:identifier|self::*[not(bns:identifier)]/bns:fullTitle" lang="en" case-order="upper-first"/>
			<apply-templates select="."/>
		</for-each>
	</template>
	<template match="bns:Corpus">
		<html:section hidden="">
			<attribute name="id">
				<call-template name="anchor"/>
			</attribute>
			<html:header>
				<html:p lang="en">Corpus of</html:p>
				<apply-templates select="bns:isCorpusOf/*"/>
				<call-template name="navigate"/>
			</html:header>
			<if test="bns:hasCover/*">
				<html:figure>
					<choose>
						<when test="bns:hasCover/*[1][../@rdf:parseType='Resource']">
							<apply-templates select="bns:hasCover/*[1]/.." mode="contents"/>
						</when>
						<otherwise>
							<apply-templates select="bns:hasCover/*[1]" mode="contents"/>
						</otherwise>
					</choose>
				</html:figure>
			</if>
			<html:section>
				<html:div>
					<apply-templates select="bns:hasDescription" mode="contents"/>
				</html:div>
			</html:section>
			<call-template name="footer"/>
		</html:section>
		<call-template name="includes"/>
	</template>
	<template match="bns:Pseud">
		<call-template name="name"/>
	</template>
	<template match="*[parent::bns:includes or parent::bns:hasProject or parent::bns:hasNote or self::bns:hasMixtape[@rdf:parseType='Resource']]">
		<variable name="contents">
			<apply-templates select="." mode="header"/>
			<choose>
				<when test="(parent::bns:includes or parent::bns:hasNote) and bns:hasFile[@rdf:resource or rdf:Bag or rdf:Seq or */@rdf:about]">
					<apply-templates select="." mode="files"/>
				</when>
				<otherwise>
					<if test="bns:hasCover/*">
						<html:figure>
							<choose>
								<when test="bns:hasCover/*[1][../@rdf:parseType='Resource']">
									<apply-templates select="bns:hasCover/*[1]/.." mode="contents"/>
								</when>
								<otherwise>
									<apply-templates select="bns:hasCover/*[1]" mode="contents"/>
								</otherwise>
							</choose>
						</html:figure>
					</if>
					<html:section>
						<html:div>
							<apply-templates select="bns:hasDescription" mode="contents"/>
							<call-template name="metadata"/>
						</html:div>
						<if test="bns:includes/*|bns:hasNote/*|bns:hasMixtape[@rdf:parseType='Resource']">
							<html:nav>
								<if test="bns:includes/*">
									<html:section>
										<html:h4 lang="en">Includes</html:h4>
										<html:ol>
											<for-each select="bns:includes/*[bns:index/@rdf:datatype='&integer;']">
												<sort select="bns:index" data-type="number"/>
												<apply-templates select="." mode="list"/>
											</for-each>
											<for-each select="bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
												<sort select="bns:index" lang="en" case-order="upper-first"/>
												<apply-templates select="." mode="list"/>
											</for-each>
										</html:ol>
									</html:section>
								</if>
								<if test="bns:hasNote/*">
									<html:section>
										<html:h4 lang="en">Notes</html:h4>
										<html:ul>
											<for-each select="bns:hasNote/*">
												<sort select="self::*[bns:identifier]/bns:identifier|self::*[not(bns:identifier)]/bns:fullTitle" lang="en" case-order="upper-first"/>
												<apply-templates select="." mode="list"/>
											</for-each>
										</html:ul>
									</html:section>
								</if>
								<if test="bns:hasMixtape[@rdf:parseType='Resource']">
									<html:section>
										<html:h4 lang="en">Mixtapes</html:h4>
										<html:ul>
											<for-each select="bns:hasMixtape[@rdf:parseType='Resource']">
												<sort select="self::*[bns:identifier]/bns:identifier|self::*[not(bns:identifier)]/bns:fullTitle" lang="en" case-order="upper-first"/>
												<apply-templates select="." mode="list"/>
											</for-each>
										</html:ul>
									</html:section>
								</if>
							</html:nav>
						</if>
					</html:section>
				</otherwise>
			</choose>
			<call-template name="footer"/>
		</variable>
		<choose>
			<when test="parent::bns:hasNote|self::bns:hasMixtape[@rdf:parseType='Resource']">
				<html:aside hidden="">
					<attribute name="id">
						<call-template name="anchor"/>
					</attribute>
					<copy-of select="$contents"/>
				</html:aside>
			</when>
			<otherwise>
				<html:section hidden="">
					<attribute name="id">
						<call-template name="anchor"/>
					</attribute>
					<copy-of select="$contents"/>
				</html:section>
			</otherwise>
		</choose>
		<call-template name="includes"/>
	</template>
	<template match="*[parent::bns:includes|parent::bns:hasProject|parent::bns:hasNote|self::bns:hasMixtape[@rdf:parseType='Resource']]" mode="header">
		<html:header>
			<html:p>
				<for-each select="ancestor::*[parent::bns:includes|parent::bns:hasProject]">
					<html:a>
						<attribute name="href">
							<text>#</text>
							<call-template name="anchor"/>
						</attribute>
						<call-template name="namedformat"/>
					</html:a>
					<text> ∷ </text>
				</for-each>
				<call-template name="namedformat"/>
			</html:p>
			<call-template name="name"/>
			<call-template name="navigate"/>
		</html:header>
	</template>
	<template match="*[parent::bns:includes|parent::bns:hasProject|parent::bns:hasNote|self::bns:hasMixtape[@rdf:parseType='Resource']]" mode="list">
		<html:li>
			<choose>
				<when test="parent::bns:hasProject">
					<attribute name="value">
						<value-of select="bns:index"/>
					</attribute>
				</when>
				<when test="parent::bns:includes">
					<attribute name="value">
						<choose>
							<when test="bns:index[@rdf:datatype='&integer;']">
								<value-of select="bns:index"/>
							</when>
							<otherwise>
								<text>0</text>
							</otherwise>
						</choose>
					</attribute>
				</when>
			</choose>
			<html:a>
				<attribute name="href">
					<text>#</text>
					<call-template name="anchor"/>
				</attribute>
				<html:strong>
					<call-template name="namedformat"/>
					<if test="bns:identifier">
						<text> </text>
						<html:code>
							<value-of select="bns:identifier[1]"/>
						</html:code>
					</if>
					<if test="bns:fullTitle|bns:shortTitle">
						<text> | </text>
					</if>
				</html:strong>
				<choose>
					<when test="bns:shortTitle">
						<text> </text>
						<html:cite>
							<apply-templates select="bns:shortTitle[1]" mode="contents"/>
						</html:cite>
					</when>
					<when test="bns:fullTitle">
						<text> </text>
						<html:cite>
							<apply-templates select="bns:fullTitle[1]" mode="contents"/>
						</html:cite>
					</when>
				</choose>
			</html:a>
			<variable name="remarks">
				<choose>
					<when test="bns:hasFile/*">available</when>
					<when test="bns:hasNote/*">
						<text>with notes</text>
						<if test="bns:hasMixtape[@rdf:parseType='Resource']">, mixtape</if>
					</when>
					<when test="bns:hasMixtape[@rdf:parseType='Resource']">with mixtape</when>
				</choose>
			</variable>
			<if test="$remarks!=''">
				<text> </text>
				<html:small lang="en">
					<text>(</text>
					<value-of select="$remarks"/>
					<text>)</text>
				</html:small>
			</if>
			<if test="bns:includes/* and (count(../../bns:includes/*)=1 or not(self::bns:Concept or self::bns:Version or self::bns:Draft))">
				<html:ol>
					<for-each select="bns:includes/*[bns:index/@rdf:datatype='&integer;']">
						<sort select="bns:index" data-type="number"/>
						<apply-templates select="." mode="list"/>
					</for-each>
					<for-each select="bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
						<sort select="bns:index" lang="en" case-order="upper-first"/>
						<apply-templates select="." mode="list"/>
					</for-each>
				</html:ol>
			</if>
		</html:li>
	</template>
</stylesheet>
