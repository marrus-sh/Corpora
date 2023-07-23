<!DOCTYPE stylesheet [
	<!ENTITY NCName "http://www.w3.org/2001/XMLSchema#NCName">
	<!ENTITY gYearMonth "http://www.w3.org/2001/XMLSchema#gYearMonth">
	<!ENTITY integer "http://www.w3.org/2001/XMLSchema#integer">
	<!ENTITY date "http://www.w3.org/2001/XMLSchema#date">
]>
<!--
⁌ Branching Notational System Corpus X·S·L Transformation (BNS-Corpus.xslt)

§ Usage :—

Requires both X·S·L·T 1.0 and E·X·S·L·T Common support.  C·S·S features require at least Firefox 76 / Safari 14.1 / Chrome 89.  Stick the following at the beginning of your X·M·L file :—

	<?xml-stylesheet type="text/xsl" href="/path/to/BNS-Corpus.xslt"?>

§§ Configuration (in the file which links to this stylesheet) :—

• The first <html:link rel="alternate" type="application/rdf+xml"> element with an @href attribute is used to source the R·D·F for the corpus.

• The @lang attribute on the document element is used to prioritize titles from fetched resources.

• The @prefix attribute on the <html:html> element (with the R·D·F∕A syntax) is used for shortening of displayed links.

• Exactly one <html:article id="BNS-Corpus"> must be supplied; the corpus will be placed in here!

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

• Relative values #in general# unless the base U·R·I’s of the R·D·F and the document it is being linked from are the same (or equivalent).

• A non‐nested structure for branches:  This stylesheet does not attempt to resolve @rdf:resource in #most cases.

§ Disclaimer :—

To the extent possible under law, kibigo! has waived all copyright and related or neighboring rights to this file via a CC0 1.0 Universal Public Domain Dedication.  See ‹ https://creativecommons.org/publicdomain/zero/1.0/ › for more information.

THIS FILE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THIS FILE, THE USE OF THIS FILE, OR OTHER DEALINGS IN THIS FILE.
-->
<stylesheet
	id="transform"
	version="1.0"
	xmlns="http://www.w3.org/1999/XSL/Transform"
	xmlns:bns="https://ns.1024.gdn/BNS/#"
	xmlns:dcmitype="http://purl.org/dc/dcmitype/"
	xmlns:exsl="http://exslt.org/common"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:svg="http://www.w3.org/2000/svg"
>
	<!-- BEGIN SHARED TEMPLATES -->
	<variable name="defaultprefixes">
		<html:dl>
			<call-template name="prefixes">
				<with-param name="prefixlist">
					<text>
as: https://www.w3.org/ns/activitystreams#
csvw: http://www.w3.org/ns/csvw#
dcat: http://www.w3.org/ns/dcat#
dqv: http://www.w3.org/ns/dqv#
duv: https://www.w3.org/ns/duv#
grddl: http://www.w3.org/2003/g/data-view#
jsonld: http://www.w3.org/ns/json-ld#
ldp: http://www.w3.org/ns/ldp#
ma: http://www.w3.org/ns/ma-ont#
oa: http://www.w3.org/ns/oa#
odrl: http://www.w3.org/ns/odrl/2/
org: http://www.w3.org/ns/org#
owl: http://www.w3.org/2002/07/owl#
prov: http://www.w3.org/ns/prov#
qb: http://purl.org/linked-data/cube#
rdf: http://www.w3.org/1999/02/22-rdf-syntax-ns#
rdfa: http://www.w3.org/ns/rdfa#
rdfs: http://www.w3.org/2000/01/rdf-schema#
rif: http://www.w3.org/2007/rif#
rr: http://www.w3.org/ns/r2rml#
sd: http://www.w3.org/ns/sparql-service-description#
skos: http://www.w3.org/2004/02/skos/core#
skosxl: http://www.w3.org/2008/05/skos-xl#
ssn: http://www.w3.org/ns/ssn/
sosa: http://www.w3.org/ns/sosa/
time: http://www.w3.org/2006/time#
void: http://rdfs.org/ns/void#
wdr: http://www.w3.org/2007/05/powder#
wdrs: http://www.w3.org/2007/05/powder-s#
xhv: http://www.w3.org/1999/xhtml/vocab#
xml: http://www.w3.org/XML/1998/namespace
xsd: http://www.w3.org/2001/XMLSchema#
earl: http://www.w3.org/ns/earl#
cc: http://creativecommons.org/ns#
ctag: http://commontag.org/ns#
dc: http://purl.org/dc/terms/
dcterms: http://purl.org/dc/terms/
dc11: http://purl.org/dc/elements/1.1/
foaf: http://xmlns.com/foaf/0.1/
gr: http://purl.org/goodrelations/v1#
ical: http://www.w3.org/2002/12/cal/icaltzd#
og: http://ogp.me/ns#
rev: http://purl.org/stuff/rev#
sioc: http://rdfs.org/sioc/ns#
v: http://rdf.data-vocabulary.org/#
vcard: http://www.w3.org/2006/vcard/ns#
schema: http://schema.org/
					</text>
				</with-param>
			</call-template>
			<call-template name="prefixes"/>
		</html:dl>
	</variable>
	<template name="file" priority="-1">
		<param name="path"/>
		<choose>
			<when test="contains($path, '/')">
				<call-template name="file">
					<with-param name="path" select="substring-after($path, '/')"/>
				</call-template>
			</when>
			<otherwise>
				<value-of select="$path"/>
			</otherwise>
		</choose>
	</template>
	<template name="shorten" priority="-1">
		<param name="uri"/>
		<param name="prefixes" select="$defaultprefixes"/>
		<variable name="expansion" select="exsl:node-set($prefixes)//html:dd[starts-with($uri, .)][last()]"/>
		<variable name="prefix" select="$expansion//preceding-sibling::html:dt[1]"/>
		<choose>
			<when test="$prefix">
				<value-of select="concat($prefix, ':', substring-after($uri, $expansion))"/>
			</when>
			<otherwise>
				<value-of select="$uri"/>
			</otherwise>
		</choose>
	</template>
	<template name="lang" priority="-1">
		<attribute name="lang">
			<value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
		</attribute>
	</template>
	<template name="expand" priority="-1">
		<param name="pname"/>
		<param name="prefixes" select="$defaultprefixes"/>
		<variable name="prefix" select="exsl:node-set($prefixes)//html:dt[starts-with($pname, concat(., ':'))][last()]"/>
		<variable name="expansion" select="$prefix//following-sibling::html:dd[1]"/>
		<choose>
			<when test="$prefix">
				<value-of select="concat($expansion, substring-after($pname, concat($prefix, ':')))"/>
			</when>
			<otherwise>
				<value-of select="$pname"/>
			</otherwise>
		</choose>
	</template>
	<template name="resolve" priority="-1">
		<param name="uri"/>
		<param name="base"/>
		<variable name="prehash">
			<choose>
				<when test="contains($base, '#')">
					<value-of select="substring-before($base, '#')"/>
				</when>
				<otherwise>
					<value-of select="$base"/>
				</otherwise>
			</choose>
		</variable>
		<variable name="presearch">
			<choose>
				<when test="contains($prehash, '?')">
					<value-of select="substring-before($prehash, '?')"/>
				</when>
				<otherwise>
					<value-of select="$prehash"/>
				</otherwise>
			</choose>
		</variable>
		<variable name="path">
			<choose>
				<when test="contains($presearch, '//')">
					<choose>
						<when test="contains(substring-after($presearch, '//'), '/')">
							<text>/</text>
							<value-of select="substring-after(substring-after($presearch, '//'), '/')"/>
						</when>
					</choose>
				</when>
				<when test="starts-with(translate($presearch, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', ''), ':') and not(starts-with($presearch, ':'))">
					<value-of select="substring-after($presearch, ':')"/>
				</when>
				<otherwise>
					<value-of select="$presearch"/>
				</otherwise>
			</choose>
		</variable>
		<variable name="origin">
			<choose>
				<when test="contains($presearch, '//')">
					<value-of select="substring-before($presearch, '//')"/>
					<text>//</text>
					<choose>
						<when test="contains(substring-after($presearch, '//'), '/')">
							<value-of select="substring-before(substring-after($presearch, '//'), '/')"/>
						</when>
						<otherwise>
							<value-of select="substring-after($presearch, '//')"/>
						</otherwise>
					</choose>
				</when>
				<when test="starts-with(translate($presearch, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', ''), ':') and not(starts-with($presearch, ':'))">
					<value-of select="substring-before($presearch, ':')"/>
					<text>:</text>
				</when>
			</choose>
		</variable>
		<variable name="file">
			<call-template name="file">
				<with-param name="path" select="$path"/>
			</call-template>
		</variable>
		<variable name="dir">
			<choose>
				<when test="$path=''">/</when>
				<otherwise>
					<value-of select="substring($path, 1, string-length($path) - string-length($file))"/>
				</otherwise>
			</choose>
		</variable>
		<choose>
			<when test="starts-with($uri, '../')">
				<call-template name="resolve">
					<with-param name="uri" select="substring-after($uri, '.')"/>
					<with-param name="base" select="concat($origin, substring($dir, 1, string-length($dir) - 1))"/>
				</call-template>
			</when>
			<when test="starts-with($uri, './')">
				<call-template name="resolve">
					<with-param name="uri" select="substring-after($uri, './')"/>
					<with-param name="base" select="concat($origin, $dir)"/>
				</call-template>
			</when>
			<when test="starts-with(translate($uri, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', ''), ':') and not(starts-with($uri, ':')) or starts-with($uri, '//')">
				<value-of select="$uri"/>
			</when>
			<when test="starts-with($uri, '#')">
				<value-of select="concat($prehash, $uri)"/>
			</when>
			<when test="starts-with($uri, '?')">
				<value-of select="concat($presearch, $uri)"/>
			</when>
			<when test="starts-with($uri, '/')">
				<value-of select="concat($origin, $uri)"/>
			</when>
			<otherwise>
				<value-of select="concat($origin, $dir, $uri)"/>
			</otherwise>
		</choose>
	</template>
	<template name="anchor" priority="-1">
		<choose>
			<when test="self::bns:hasMixtape[@rdf:parseType='Resource']">
				<for-each select="..">
					<call-template name="anchor"/>
				</for-each>
				<text>/:mixtapes/</text>
				<choose>
					<when test="bns:identifier">
						<value-of select="bns:identifier"/>
					</when>
					<otherwise>
						<value-of select="count(preceding-sibling::bns:hasMixtape[@rdf:parseType='Resource']) + 1"/>
					</otherwise>
				</choose>
			</when>
			<when test="owl:sameAs[starts-with(@rdf:resource, './#') or starts-with(@rdf:resource, '#')]">
				<value-of select="substring-after(owl:sameAs[starts-with(@rdf:resource, './#') or starts-with(@rdf:resource, '#')][1]/@rdf:resource, '#')"/>
			</when>
			<otherwise>
				<call-template name="shorten">
					<with-param name="uri" select="@rdf:about"/>
				</call-template>
			</otherwise>
		</choose>
	</template>
	<template name="formatnumber" priority="-1">
		<param name="number"/>
		<variable name="num" select="number($number)"/>
		<choose>
			<when test="0>$num">
				<text>−</text>
				<value-of select="-$num"/>
			</when>
			<otherwise>
				<value-of select="$num"/>
			</otherwise>
		</choose>
	</template>
	<template name="subsuper" priority="-1">
		<param name="string"/>
		<choose>
			<when test="substring($string, 1, 1)='0' or substring($string, 1, 1)='1' or substring($string, 1, 1)='2' or substring($string, 1, 1)='3' or substring($string, 1, 1)='4' or substring($string, 1, 1)='5' or substring($string, 1, 1)='6' or substring($string, 1, 1)='7' or substring($string, 1, 1)='8' or substring($string, 1, 1)='9' or substring($string, 1, 1)='-'">
				<value-of select="substring($string, 1, 1)"/>
				<call-template name="subsuper">
					<with-param name="string" select="substring($string, 2)"/>
				</call-template>
			</when>
			<otherwise>
				<html:sup>
					<value-of select="$string"/>
				</html:sup>
			</otherwise>
		</choose>
	</template>
	<template name="formatted" priority="-1">
		<choose>
			<when test="not(bns:index)">
				<html:code>
					<choose>
						<when test="starts-with(@rdf:about, ../../@rdf:about)">
							<value-of select="substring-after(@rdf:about, ../../@rdf:about)"/>
						</when>
						<otherwise>
							<call-template name="shorten">
								<with-param name="uri" select="@rdf:about"/>
							</call-template>
						</otherwise>
					</choose>
				</html:code>
			</when>
			<when test="self::bns:Project|parent::bns:hasProject">
				<if test="10>bns:index">0</if>
				<if test="100>bns:index">0</if>
				<value-of select="bns:index"/>
			</when>
			<when test="self::bns:Book">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index=1">Α</when>
							<when test="bns:index=2">Β</when>
							<when test="bns:index=3">Γ</when>
							<when test="bns:index=4">Δ</when>
							<when test="bns:index=5">Ε</when>
							<when test="bns:index=6">Ζ</when>
							<when test="bns:index=7">Η</when>
							<when test="bns:index=8">Θ</when>
							<when test="bns:index=9">Ι</when>
							<when test="bns:index=10">Κ</when>
							<when test="bns:index=11">Λ</when>
							<when test="bns:index=12">Μ</when>
							<when test="bns:index=13">Ν</when>
							<when test="bns:index=14">Ξ</when>
							<when test="bns:index=15">Ο</when>
							<when test="bns:index=16">Π</when>
							<when test="bns:index=17">Ρ</when>
							<when test="bns:index=18">Σ</when>
							<when test="bns:index=19">Τ</when>
							<when test="bns:index=20">Υ</when>
							<when test="bns:index=21">Φ</when>
							<when test="bns:index=22">Χ</when>
							<when test="bns:index=23">Ψ</when>
							<when test="bns:index=24">Ω</when>
							<when test="bns:index=25">Ϛ</when>
							<when test="bns:index=26">Ϟ</when>
							<when test="bns:index=27">Ϡ</when>
							<when test="bns:index=28">Ϸ</when>
							<otherwise>
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>&apos;</text>
						<value-of select="bns:index"/>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Volume">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index>99">
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</when>
							<when test="bns:index>9">
								<choose>
									<when test="substring(number(bns:index), 1, 1)='9'">ⅬⅩⅬ</when>
									<when test="substring(number(bns:index), 1, 1)='8'">ⅬⅩⅩⅩ</when>
									<when test="substring(number(bns:index), 1, 1)='7'">ⅬⅩⅩ</when>
									<when test="substring(number(bns:index), 1, 1)='6'">ⅬⅩ</when>
									<when test="substring(number(bns:index), 1, 1)='5'">Ⅼ</when>
									<when test="substring(number(bns:index), 1, 1)='4'">ⅩⅬ</when>
									<when test="substring(number(bns:index), 1, 1)='3'">ⅩⅩⅩ</when>
									<when test="substring(number(bns:index), 1, 1)='2'">ⅩⅩ</when>
									<when test="substring(number(bns:index), 1, 1)='1'">Ⅹ</when>
								</choose>
								<choose>
									<when test="substring(number(bns:index), 2, 1)='9'">ⅤⅠⅤ</when>
									<when test="substring(number(bns:index), 2, 1)='8'">ⅤⅠⅠⅠ</when>
									<when test="substring(number(bns:index), 2, 1)='7'">ⅤⅠⅠ</when>
									<when test="substring(number(bns:index), 2, 1)='6'">ⅤⅠ</when>
									<when test="substring(number(bns:index), 2, 1)='5'">Ⅴ</when>
									<when test="substring(number(bns:index), 2, 1)='4'">ⅠⅤ</when>
									<when test="substring(number(bns:index), 2, 1)='3'">ⅠⅠⅠ</when>
									<when test="substring(number(bns:index), 2, 1)='2'">ⅠⅠ</when>
									<when test="substring(number(bns:index), 2, 1)='1'">Ⅰ</when>
								</choose>
							</when>
							<when test="bns:index>0">
								<choose>
									<when test="bns:index=9">ⅤⅠⅤ</when>
									<when test="bns:index=8">ⅤⅠⅠⅠ</when>
									<when test="bns:index=7">ⅤⅠⅠ</when>
									<when test="bns:index=6">ⅤⅠ</when>
									<when test="bns:index=5">Ⅴ</when>
									<when test="bns:index=4">ⅠⅤ</when>
									<when test="bns:index=3">ⅠⅠⅠ</when>
									<when test="bns:index=2">ⅠⅠ</when>
									<when test="bns:index=1">Ⅰ</when>
								</choose>
							</when>
							<otherwise>
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>&apos;</text>
						<value-of select="bns:index"/>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Arc">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index=1">α</when>
							<when test="bns:index=2">β</when>
							<when test="bns:index=3">γ</when>
							<when test="bns:index=4">δ</when>
							<when test="bns:index=5">ε</when>
							<when test="bns:index=6">ζ</when>
							<when test="bns:index=7">η</when>
							<when test="bns:index=8">θ</when>
							<when test="bns:index=9">ι</when>
							<when test="bns:index=10">κ</when>
							<when test="bns:index=11">λ</when>
							<when test="bns:index=12">μ</when>
							<when test="bns:index=13">ν</when>
							<when test="bns:index=14">ξ</when>
							<when test="bns:index=15">ο</when>
							<when test="bns:index=16">π</when>
							<when test="bns:index=17">ρ</when>
							<when test="bns:index=18">σ</when>
							<when test="bns:index=19">τ</when>
							<when test="bns:index=20">υ</when>
							<when test="bns:index=21">φ</when>
							<when test="bns:index=22">χ</when>
							<when test="bns:index=23">ψ</when>
							<when test="bns:index=24">ω</when>
							<when test="bns:index=25">ϛ</when>
							<when test="bns:index=26">ϟ</when>
							<when test="bns:index=27">ϡ</when>
							<when test="bns:index=28">ϸ</when>
							<otherwise>
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>&apos;</text>
						<value-of select="bns:index"/>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Side">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index=1">A</when>
							<when test="bns:index=2">B</when>
							<when test="bns:index=3">C</when>
							<when test="bns:index=4">D</when>
							<when test="bns:index=5">E</when>
							<when test="bns:index=6">F</when>
							<when test="bns:index=7">G</when>
							<when test="bns:index=8">H</when>
							<when test="bns:index=9">I</when>
							<when test="bns:index=10">J</when>
							<when test="bns:index=11">K</when>
							<when test="bns:index=12">L</when>
							<when test="bns:index=13">M</when>
							<when test="bns:index=14">N</when>
							<when test="bns:index=15">O</when>
							<when test="bns:index=16">P</when>
							<when test="bns:index=17">Q</when>
							<when test="bns:index=18">R</when>
							<when test="bns:index=19">S</when>
							<when test="bns:index=20">T</when>
							<when test="bns:index=21">U</when>
							<when test="bns:index=22">V</when>
							<when test="bns:index=23">W</when>
							<when test="bns:index=24">X</when>
							<when test="bns:index=25">Y</when>
							<when test="bns:index=26">Z</when>
							<when test="bns:index=27">Þ</when>
							<when test="bns:index=28">Ð</when>
							<when test="bns:index=29">Æ</when>
							<when test="bns:index=30">Œ</when>
							<when test="bns:index=31">Ŋ</when>
							<when test="bns:index=32">Ƒ</when>
							<otherwise>
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>&apos;</text>
						<value-of select="bns:index"/>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Chapter|ancestor-or-self::bns:hasTrack">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<if test="10>bns:index">0</if>
						<call-template name="formatnumber">
							<with-param name="number" select="bns:index"/>
						</call-template>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>&apos;</text>
						<value-of select="bns:index"/>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Section">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index=1">a</when>
							<when test="bns:index=2">b</when>
							<when test="bns:index=3">c</when>
							<when test="bns:index=4">d</when>
							<when test="bns:index=5">e</when>
							<when test="bns:index=6">f</when>
							<when test="bns:index=7">g</when>
							<when test="bns:index=8">h</when>
							<when test="bns:index=9">i</when>
							<when test="bns:index=10">j</when>
							<when test="bns:index=11">k</when>
							<when test="bns:index=12">l</when>
							<when test="bns:index=13">m</when>
							<when test="bns:index=14">n</when>
							<when test="bns:index=15">o</when>
							<when test="bns:index=16">p</when>
							<when test="bns:index=17">q</when>
							<when test="bns:index=18">r</when>
							<when test="bns:index=19">s</when>
							<when test="bns:index=20">t</when>
							<when test="bns:index=21">u</when>
							<when test="bns:index=22">v</when>
							<when test="bns:index=23">w</when>
							<when test="bns:index=24">x</when>
							<when test="bns:index=25">y</when>
							<when test="bns:index=26">z</when>
							<when test="bns:index=27">þ</when>
							<when test="bns:index=28">ð</when>
							<when test="bns:index=29">æ</when>
							<when test="bns:index=30">œ</when>
							<when test="bns:index=31">ŋ</when>
							<when test="bns:index=32">ƒ</when>
							<otherwise>
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>&apos;</text>
						<value-of select="bns:index"/>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Verse">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index>99">
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</when>
							<when test="bns:index>9">
								<choose>
									<when test="substring(number(bns:index), 1, 1)='9'">ⅼⅹⅼ</when>
									<when test="substring(number(bns:index), 1, 1)='8'">ⅼⅹⅹⅹ</when>
									<when test="substring(number(bns:index), 1, 1)='7'">ⅼⅹⅹ</when>
									<when test="substring(number(bns:index), 1, 1)='6'">ⅼⅹ</when>
									<when test="substring(number(bns:index), 1, 1)='5'">ⅼ</when>
									<when test="substring(number(bns:index), 1, 1)='5'">ⅹⅼ</when>
									<when test="substring(number(bns:index), 1, 1)='3'">ⅹⅹⅹ</when>
									<when test="substring(number(bns:index), 1, 1)='2'">ⅹⅹ</when>
									<when test="substring(number(bns:index), 1, 1)='1'">ⅹ</when>
								</choose>
								<choose>
									<when test="substring(number(bns:index), 2, 1)='9'">ⅴⅰⅴ</when>
									<when test="substring(number(bns:index), 2, 1)='8'">ⅴⅰⅰⅰ</when>
									<when test="substring(number(bns:index), 2, 1)='7'">ⅴⅰⅰ</when>
									<when test="substring(number(bns:index), 2, 1)='6'">ⅴⅰ</when>
									<when test="substring(number(bns:index), 2, 1)='5'">ⅴ</when>
									<when test="substring(number(bns:index), 2, 1)='4'">ⅰⅴ</when>
									<when test="substring(number(bns:index), 2, 1)='3'">ⅰⅰⅰ</when>
									<when test="substring(number(bns:index), 2, 1)='2'">ⅰⅰ</when>
									<when test="substring(number(bns:index), 2, 1)='1'">ⅰ</when>
								</choose>
							</when>
							<when test="bns:index>0">
								<choose>
									<when test="bns:index=9">ⅴⅰⅴ</when>
									<when test="bns:index=8">ⅴⅰⅰⅰ</when>
									<when test="bns:index=7">ⅴⅰⅰ</when>
									<when test="bns:index=6">ⅴⅰ</when>
									<when test="bns:index=5">ⅴ</when>
									<when test="bns:index=4">ⅰⅴ</when>
									<when test="bns:index=3">ⅰⅰⅰ</when>
									<when test="bns:index=2">ⅰⅰ</when>
									<when test="bns:index=1">ⅰ</when>
								</choose>
							</when>
							<otherwise>
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>&apos;</text>
						<value-of select="bns:index"/>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Concept">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<call-template name="formatnumber">
							<with-param name="number" select="bns:index"/>
						</call-template>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<when test="string-length(translate(substring-after(bns:index, '_'), '0123456789', ''))>0">
						<call-template name="subsuper">
							<with-param name="string" select="substring-after(bns:index, '_')"/>
						</call-template>
					</when>
					<otherwise>
						<value-of select="bns:index"/>
					</otherwise>
				</choose>
				<text>°</text>
			</when>
			<when test="self::bns:Version">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<call-template name="formatnumber">
							<with-param name="number" select="bns:index"/>
						</call-template>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<when test="string-length(translate(substring-after(bns:index, '_'), '0123456789', ''))>0">
						<call-template name="subsuper">
							<with-param name="string" select="substring-after(bns:index, '_')"/>
						</call-template>
					</when>
					<otherwise>
						<value-of select="bns:index"/>
					</otherwise>
				</choose>
				<text>′</text>
			</when>
			<when test="self::bns:Draft">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<call-template name="formatnumber">
							<with-param name="number" select="bns:index"/>
						</call-template>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<when test="string-length(translate(substring-after(bns:index, '_'), '0123456789-', ''))>0">
						<call-template name="subsuper">
							<with-param name="string" select="substring-after(bns:index, '_')"/>
						</call-template>
					</when>
					<otherwise>
						<value-of select="bns:index"/>
					</otherwise>
				</choose>
				<text>″</text>
			</when>
			<otherwise>
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<call-template name="formatnumber">
							<with-param name="number" select="bns:index"/>
						</call-template>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>&apos;</text>
						<value-of select="bns:index"/>
					</otherwise>
				</choose>
			</otherwise>
		</choose>
	</template>
	<template name="namedformat" priority="-1">
		<html:span lang="en">
			<choose>
				<when test="self::bns:Project|parent::bns:hasProject">
					<text>Project </text>
					<call-template name="formatted"/>
				</when>
				<when test="self::bns:Note|parent::bns:hasNote">
					<text>Note</text>
				</when>
				<when test="self::bns:hasMixtape[@rdf:parseType='Resource']">
					<text>Mixtape</text>
				</when>
				<otherwise>
					<value-of select="local-name()"/>
					<text> </text>
					<call-template name="formatted"/>
				</otherwise>
			</choose>
		</html:span>
	</template>
	<template name="prefixes" priority="-1">
		<param name="prefixlist" select="//html:html/@prefix"/>
		<variable name="prefix" select="normalize-space($prefixlist)"/>
		<if test="contains($prefix, ': ')">
			<html:div>
				<html:dt>
					<value-of select="substring-before($prefix, ': ')"/>
				</html:dt>
				<html:dd>
					<choose>
						<when test="contains(substring-after($prefix, ': '), ' ')">
							<value-of select="substring-before(substring-after($prefix, ': '), ' ')"/>
						</when>
						<otherwise>
							<value-of select="substring-after($prefix, ': ')"/>
						</otherwise>
					</choose>
				</html:dd>
			</html:div>
			<if test="contains(substring-after($prefix, ': '), ' ')">
				<call-template name="prefixes">
					<with-param name="prefixlist" select="substring-after(substring-after($prefix, ': '), ' ')"/>
				</call-template>
			</if>
		</if>
	</template>
	<template name="helper-css" priority="-1">
		<html:style>
html{ Margin: 0; Padding: 0; Color: Var(--Text); Background: Var(--Background); Font-Family: Var(--Serif); Line-Height: 1.25; --Background: Canvas; --Canvas: Canvas; --Fade: GrayText; --Magic: LinkText; --Text: CanvasText; --Attn: ActiveText; --Bold: VisitedText; --Shade: CanvasText; --Sans: Sans-Serif; --Serif: Serif; --Mono: Monospace }
body{ Margin: 0; Padding: 0 }
div.FILES{ Display: Grid; Box-Sizing: Border-Box; Padding-Block: 2REM 0; Padding-Inline: 2REM; Block-Size: 100%; Grid-Template-Rows: 1FR Max-Content; Grid-Auto-Flow: Row; Overflow: Auto; Background: Var(--Shade); Color: Var(--Canvas) }
div.FILES>div{ Display: Contents }
div.FILES>div>*{ Display: Block; Box-Sizing: Border-Box; Block-Size: 100%; Inline-Size: 100%; Overflow: Auto; Object-Fit: Contain }
div.FILES>div>iframe{ Object-Fit: Fill }
div.FILES>div>div.CONTAINER>div{ Display: Contents }
div.FILES>div>div.CONTAINER>div>*{ Display: Block; Box-Sizing: Border-Box; Margin: Auto; Block-Size: Auto; Max-Inline-Size: 100%; Overflow: Auto; Object-Fit: Contain }
div.FILES>div>div.CONTAINER>div>iframe{ Block-Size: 100%; Inline-Size: 100%; Object-Fit: Fill }
div.FILES>footer{ Padding-Block: .5EM }
div.FILES>footer p{ Text-Align: Start; Text-Align-Last: Auto }
div.FILES>footer a:Not(:Hover){ Color: Inherit }
div.FILES>footer strong{ Color: Var(--Background) }
iframe{ Display: Block; Margin: 0; Border: Medium Var(--Canvas) Inset; Color: Var(--Text); Background: Var(--Background) }
rt{ Ruby-Align: Center; Font-Size: .625EM; Color: Var(--Magic) }
*:Any-Link{ Color: Var(--Text) }
*:Any-Link:Hover{ Color: Var(--Fade) }
button,sup,sub{ Font-Size: .625EM; Line-Height: 1 }
button{ Margin-Inline: 0; Border-Color: CurrentColor; Border-Width: Thin; Border-Block-Style: None Dotted; Border-Inline-Style: None; Padding: 0; Vertical-Align: Super; Color: Var(--Magic); Background: Transparent; Cursor: Pointer }
code{ Overflow-Wrap: Break-Word; Font-Family: Var(--Mono) }
span.LOOKUP{ White-Space: NoWrap }
span.LOOKUP>a{ White-Space: Normal }
span.LOOKUP>a:Not([data-expanded]){ Word-Break: Break-All }
span.LOOKUP>a[data-expanded]+small{ Vertical-Align: Sub; Font-Size: Smaller; Line-Height: 1; White-Space: NoWrap }
span.LOOKUP>a[data-expanded]+small>code{ Display: Inline-Block; Max-Inline-Size: 50%; Vertical-Align: Text-Bottom; Overflow: Hidden; Overflow-Wrap: Normal; Text-Overflow: Ellipsis }
span.LOOKUP>a[data-expanded]+small::before{ Content: "[" }
span.LOOKUP>a[data-expanded]+small::after{ Content: "]" }
strong{ Color: Var(--Attn) }
a:Hover strong{ Color: Var(--Shade) }
time:Not([datetime]){ White-Space: NoWrap }
		</html:style>
	</template>
	<template name="helper-js" priority="-1">
		<html:script>
const unprefix= prefix =>
  (
    { bf: "http://id.loc.gov/ontologies/bibframe/"
    , bns: "https://ns.1024.gdn/BNS/#"
    , dc: "http://purl.org/dc/terms/"
    , madsrdf: "http://www.loc.gov/mads/rdf/v1#"
    , owl: "http://www.w3.org/2002/07/owl#"
    , rdf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    , rdfs: "http://www.w3.org/2000/01/rdf-schema#"
    , skos: "http://www.w3.org/2004/02/skos/core#"
    , xml: "http://www.w3.org/XML/1998/namespace" }[prefix]
  )
const fetchResource= ( link, href, win, lose ) =>
  {
    const request= new XMLHttpRequest
    request.open
      ( "GET"
      , href.indexOf("http://www.wikidata.org/entity/") == 0 ? `https://www.wikidata.org/wiki/Special:EntityData/${ href.substring(31) }`
      : href.indexOf("http://") == 0 ? `https${ href.substring(4) }`
      : href )
    request.setRequestHeader("Accept", "application/rdf+xml")
    request.responseType= "document"
    request.addEventListener
      ( "load"
      , handleResponse.bind(null, request, link, href, win, lose))
    request.addEventListener("error", lose)
    request.send()
  }
const handleResponse= ( { response }, link, href, win, lose ) =>
  {
    let result= null
    return !response ? lose()
    : (
        result= response
          .evaluate
            ( `//*[@rdf:about='${ link }' or owl:sameAs/@rdf:resource='${ link }']/*[self::madsrdf:authoritativeLabel|self::skos:prefLabel|self::dc:title|self::bns:fullTitle|self::rdfs:label][@xml:lang='${ document.documentElement.lang }' or starts-with(@xml:lang, '${ document.documentElement.lang }-')]|//*[@rdf:about='${ link }' or owl:sameAs/@rdf:resource='${ link }']/bf:title/bf:Title/bf:mainTitle[@xml:lang='${ document.documentElement.lang }' or starts-with(@xml:lang, '${ document.documentElement.lang }-')]`
            , response
            , unprefix
            , XPathResult.FIRST_ORDERED_NODE_TYPE
            , null )
          .singleNodeValue
        ?? response
          .evaluate
            ( `//*[@rdf:about='${ link }' or owl:sameAs/@rdf:resource='${ link }']/*[self::madsrdf:authoritativeLabel|self::skos:prefLabel|self::dc:title|self::bns:fullTitle|self::rdfs:label]|//*[@rdf:about='${ link }' or owl:sameAs/@rdf:resource='${ link }']/bf:title/bf:Title/bf:mainTitle`
            , response
            , unprefix
            , XPathResult.FIRST_ORDERED_NODE_TYPE
            , null )
          .singleNodeValue
      ) ? win(result)
    : (
        result= response.querySelector
          ( "link[rel~=alternate][type='application/rdf+xml']" )
      ) ? fetchResouce(link, result.href, win, lose)
    : lose()
  }
globalThis.getInfo= ( { target: element } ) =>
  {
    element.onclick= null
    const link= element.previousElementSibling
    if (
      link.origin != location.origin
      || link.pathname != location.pathname
      || link.search != location.search
    )
      fetchResource
        ( link.hasAttribute("resource") ? link.getAttribute("resource")
        : link.href
        , link.href
        , result =>
          {
            const cite= document
              .createElementNS("http://www.w3.org/1999/xhtml", "cite")
            const small= document
              .createElementNS("http://www.w3.org/1999/xhtml", "small")
            if (
              result.hasAttributeNS
                ( "http://www.w3.org/XML/1998/namespace"
                , "lang" )
            )
              cite.setAttribute
                ( "lang"
                , result.getAttributeNS
                  ( "http://www.w3.org/XML/1998/namespace"
                  , "lang" ) )
            cite.textContent= result.textContent
            small.title= link.textContent
            for ( const child of link.childNodes ) {
              small.appendChild(child)  //  removes from `link`
            }
            link.appendChild(cite)
            element.parentNode.replaceChild(small, element)
            link.dataset.expanded= ""
          }
        , ( ) => element.parentNode.removeChild(element) )
    else {
      const result= document
        .getElementById(decodeURIComponent(link.hash.substring(1)))
        ?.querySelector
        ?.("h2")
      if ( result ) {
        const cite= document
          .createElementNS("http://www.w3.org/1999/xhtml", "cite")
        const small= document
          .createElementNS("http://www.w3.org/1999/xhtml", "small")
        cite.lang= result.lang
        cite.textContent= result.textContent
        for ( const child of link.childNodes ) {
          small.appendChild(child)  //  removes from `link`
        }
        link.appendChild(cite)
        element.parentNode.replaceChild(small, element)
        link.dataset.expanded= ""
      }
      else
        element.parentNode.removeChild(element)
  } }
globalThis.displayMediaIn= element => {
  for ( const media of element.querySelectorAll("iframe[data-src],audio[data-src],video[data-src],img[data-src]") ) {
    const node= media.cloneNode()
    node.src= media.dataset.src
    node.removeAttribute("data-src")
    media.replaceWith(node)
} }
window.addEventListener
  ( "load"
  , ( ) => {
    if ( location.search.length > 1 ) {
      const element= document.getElementById
        ( decodeURIComponent(location.search.substring(1)) )
      if ( !(element == null || !element.hasAttribute("data-srcdoc")) )
        try {
          const src= (new DOMParser).parseFromString
            ( element.getAttribute("data-srcdoc")
            , "application/xhtml+xml" )
          document.head.replaceWith
            ( document.importNode(src.head, true) )
          document.body.replaceWith
            ( document.importNode(src.body, true) )
          displayMediaIn(document.body)
        }
        catch {
  } }   } )
		</html:script>
	</template>
	<template match="*" mode="xml-serialize" priority="-1">
		<text>&lt;</text>
		<value-of select="name()"/>
		<apply-templates select="@*" mode="xml-serialize"/>
		<choose>
			<when test="node()">
				<text>></text>
				<apply-templates mode="xml-serialize"/>
				<text>&lt;/</text>
				<value-of select="name()"/>
				<text>></text>
			</when>
			<otherwise>
				<text>/></text>
			</otherwise>
		</choose>
	</template>
	<template match="@*" mode="xml-serialize" priority="-1">
		<text> </text>
		<value-of select="name()"/>
		<text>="</text>
		<value-of select="."/>
		<text>"</text>
	</template>
	<template match="text()" mode="xml-serialize" priority="-1">
		<value-of select="."/>
	</template>
	<template match="*" mode="contents" priority="-1">
		<choose>
			<when test="@rdf:parseType='Literal'">
				<apply-templates/>
			</when>
			<when test="bns:contents">
				<apply-templates select="bns:contents" mode="contents"/>
			</when>
			<when test="@rdf:resource|@rdf:about">
				<variable name="mediatype">
					<choose>
						<when test="bns:mediaType">
							<value-of select="bns:mediaType"/>
						</when>
						<when test="self::*[substring(local-name(), 1, 1)='_'][translate(substring(local-name(), 2, 1), '123456789', '')=''][translate(substring(local-name(), 3), '0123456789', '')=''][namespace-uri()='http://www.w3.org/1999/02/22-rdf-syntax-ns#']/parent::*[self::rdf:Bag|self::rdf:Seq]/bns:mediaType">
							<value-of select="../bns:mediaType"/>
						</when>
					</choose>
				</variable>
				<choose>
					<when test="$mediatype='application/tei+xml'">
						<html:iframe data-src="{@rdf:about|@rdf:resource}"/>
					</when>
					<when test="$mediatype='text/html'">
						<html:iframe data-src="{@rdf:about|@rdf:resource}"/>
					</when>
					<when test="$mediatype='application/xhtml+xml'">
						<html:iframe data-src="{@rdf:about|@rdf:resource}"/>
					</when>
					<when test="starts-with($mediatype, 'video/')">
						<html:video controls="" data-src="{@rdf:about|@rdf:resource}"/>
					</when>
					<when test="starts-with($mediatype, 'audio/')">
						<html:audio controls="" data-src="{@rdf:about|@rdf:resource}"/>
					</when>
					<when test="starts-with($mediatype, 'image/')">
						<html:img alt="{@bns:description}" data-src="{@rdf:about|@rdf:resource}"/>
					</when>
					<when test="starts-with($mediatype, 'text/')">
						<html:iframe data-src="{@rdf:about|@rdf:resource}"/>
					</when>
					<when test="$mediatype='application/xml' or substring-after($mediatype, '+')='xml'">
						<html:iframe data-src="{@rdf:about|@rdf:resource}"/>
					</when>
					<otherwise>
						<html:iframe data-src="{@rdf:about|@rdf:resource}"/>
					</otherwise>
				</choose>
			</when>
			<otherwise>
				<html:span lang="{@xml:lang}">
					<value-of select="."/>
				</html:span>
			</otherwise>
		</choose>
	</template>
	<template match="html:*|svg:*" priority="-1">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<apply-templates/>
		</copy>
	</template>
	<template match="html:a" priority="-1">
		<variable name="result">
			<copy>
				<for-each select="@*">
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
	<template match="*[parent::rdf:RDF]" priority="-1"/>
	<template match="*" mode="files" priority="-1">
		<variable name="documents">
			<for-each select="bns:hasFile/*[self::rdf:Bag or self::rdf:Seq or @rdf:about]|bns:hasFile[@rdf:resource]">
				<variable name="mediatype">
					<value-of select="bns:mediaType"/>
				</variable>
				<variable name="contents">
					<choose>
						<when test="self::rdf:Bag|self::rdf:Seq">
							<html:div class="CONTAINER">
								<for-each select="*[substring(local-name(), 1, 1)='_'][translate(substring(local-name(), 2, 1), '123456789', '')=''][translate(substring(local-name(), 3), '0123456789', '')=''][namespace-uri()='http://www.w3.org/1999/02/22-rdf-syntax-ns#']">
									<sort select="substring(local-name(), 2)" data-type="number"/>
									<html:div>
										<apply-templates select="." mode="contents"/>
									</html:div>
								</for-each>
							</html:div>
						</when>
						<otherwise>
							<apply-templates select="." mode="contents"/>
						</otherwise>
					</choose>
				</variable>
				<html:div>
					<choose>
						<when test="@rdf:resource">
							<attribute name="data-sort">10</attribute>
						</when>
						<when test="$mediatype='application/tei+xml'">
							<attribute name="data-sort">1</attribute>
						</when>
						<when test="$mediatype='text/html'">
							<attribute name="data-sort">2</attribute>
						</when>
						<when test="$mediatype='application/xhtml+xml'">
							<attribute name="data-sort">3</attribute>
						</when>
						<when test="starts-with($mediatype, 'video/')">
							<attribute name="data-sort">4</attribute>
						</when>
						<when test="starts-with($mediatype, 'audio/')">
							<attribute name="data-sort">5</attribute>
						</when>
						<when test="starts-with($mediatype, 'image/')">
							<attribute name="data-sort">6</attribute>
						</when>
						<when test="starts-with($mediatype, 'text/')">
							<attribute name="data-sort">7</attribute>
						</when>
						<when test="$mediatype='application/xml' or substring-after($mediatype, '+')='xml'">
							<attribute name="data-sort">8</attribute>
						</when>
						<otherwise>
							<attribute name="data-sort">9</attribute>
						</otherwise>
					</choose>
					<html:div>
						<copy-of select="$contents"/>
					</html:div>
					<html:a href="{@rdf:about|@rdf:resource}" target="_blank">
						<attribute name="href">
							<choose>
								<when test="self::rdf:Bag|self::rdf:Seq">
									<text>?</text>
									<for-each select="../..">
										<call-template name="anchor"/>
									</for-each>
									<text>/</text>
									<value-of select="position()"/>
								</when>
								<otherwise>
									<value-of select="@rdf:about|@rdf:resource"/>
								</otherwise>
							</choose>
						</attribute>
						<if test="self::rdf:Bag|self::rdf:Seq">
							<attribute name="id">
								<for-each select="../..">
									<call-template name="anchor"/>
								</for-each>
								<text>/</text>
								<value-of select="position()"/>
							</attribute>
							<attribute name="data-srcdoc">
								<text>&lt;html:html xmlns:html="http://www.w3.org/1999/xhtml">&lt;html:head>&lt;html:title></text>
								<call-template name="shorten">
									<with-param name="uri" select="../../@rdf:about"/>
								</call-template>
								<text>&lt;/html:title>&lt;html:style>body>div.CONTAINER>div>*{ Display: Block; Box-Sizing: Border-Box; Margin: Auto; Block-Size: Auto; Max-Inline-Size: 100%; Overflow: Auto; Object-Fit: Contain } body>div.CONTAINER>div>iframe{ Block-Size: 100VH; Inline-Size: 100%; Object-Fit: Fill }&lt;/html:style>&lt;/html:head>&lt;html:body></text>
								<apply-templates select="exsl:node-set($contents)" mode="xml-serialize"/>
								<text>&lt;/html:body>&lt;/html:html></text>
							</attribute>
						</if>
						<choose>
							<when test="string($mediatype)">
								<if test="not(self::rdf:Bag|self::rdf:Seq)">
									<attribute name="type">
										<value-of select="$mediatype"/>
									</attribute>
								</if>
								<html:code>
									<value-of select="$mediatype"/>
								</html:code>
								<choose>
									<when test="bns:fileLabel">
										<text> </text>
										<html:small>
											<text>(</text>
											<apply-templates select="bns:fileLabel" mode="contents"/>
											<if test="self::rdf:Bag|self::rdf:Seq">
												<text>, multiple</text>
											</if>
											<text>)</text>
										</html:small>
									</when>
									<otherwise>
										<if test="self::rdf:Bag|self::rdf:Seq">
											<text> </text>
											<html:small>(multiple)</html:small>
										</if>
									</otherwise>
								</choose>
							</when>
							<when test="self::dcmitype:*">
								<value-of select="name()"/>
							</when>
							<otherwise>
								<text>???</text>
							</otherwise>
						</choose>
					</html:a>
				</html:div>
			</for-each>
		</variable>
		<variable name="sorted">
			<for-each select="exsl:node-set($documents)//*[@data-sort]">
				<sort select="@data-sort" data-type="number"/>
				<copy-of select="."/>
			</for-each>
		</variable>
		<html:div class="FILES">
			<copy-of select="exsl:node-set($sorted)//*[@data-sort][1]/*[1]"/>
			<html:footer>
				<html:p>
					<html:a lang="en">
						<for-each select="exsl:node-set($sorted)//*[@data-sort][1]/*[2]">
							<for-each select="@*">
								<copy/>
							</for-each>
							<text>Open in a new window</text>
							<if test="@type">
								<text> (</text>
								<copy-of select="node()"/>
								<text>)</text>
							</if>
						</for-each>
					</html:a>
				</html:p>
				<if test="exsl:node-set($sorted)//*[@data-sort][position()!=1]/*[2]">
					<html:p>
						<html:strong lang="en">Other formats:</html:strong>
						<for-each select="exsl:node-set($sorted)//*[@data-sort][position()!=1]/*[2]">
							<text> </text>
							<copy-of select="."/>
						</for-each>
					</html:p>
				</if>
				<if test="skos:closeMatch[@rdf:resource]">
					<html:p>
						<html:strong lang="en">In other systems:</html:strong>
						<text> </text>
						<for-each select="skos:closeMatch/@rdf:resource">
							<text> </text>
							<html:a href="{.}">
								<html:code>
									<call-template name="shorten">
										<with-param name="uri" select="."/>
									</call-template>
								</html:code>
							</html:a>
						</for-each>
					</html:p>
				</if>
			</html:footer>
		</html:div>
	</template>
	<!-- END SHARED TEMPLATES -->
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
#BNS-Corpus{ Display: Flex; Position: Relative; Box-Sizing: Border-Box; Margin-Block: 0 2REM; Margin-Inline: Auto; Border-End-Start-Radius: 4REM; Border-End-End-Radius: 4REM; Padding-Block: 1REM; Padding-Inline: 5REM; Min-Block-Size: Calc(100VH - 2REM); Inline-Size: 54REM; Max-Inline-Size: 100%; Flex-Direction: Column; Color: Var(--Text); Background: Var(--Background); Font-Family: Var(--Serif); Line-Height: 1.25; Z-Index: Auto }
#BNS-Corpus::after{ Display: Block; Position: Absolute; Inset-Block: Auto -2EM; Inset-Inline: 0; Block-Size: 6REM; Background: Var(--Shade); Z-Index: -1; Content: "" }
#BNS-Corpus>header{ Flex: None }
#BNS-Corpus>header>h1{ Display: Block; Margin-Block: .5REM; Color: Var(--Text); Font-Size: XX-Large; Font-Family: Var(--Sans); Text-Align: Center }
#BNS-Corpus>header>h1>a{ Color: Var(--Shade) }
#BNS-Corpus>header>h1>a:Hover{ Color: Var(--Attn) }
#BNS-Corpus>header>nav{ Font-Size: Medium; Margin-Block: .5REM 1REM; Color: Var(--Text); Font-Family: Var(--Sans); Text-Align: Justify; Text-Align-Last: Center }
#BNS-Corpus>header>nav>ol,#BNS-Corpus>header>nav>ol>li{ Display: Inline; Margin: 0; Padding: 0 }
#BNS-Corpus>header>nav>ol>li::after{ Content: "\200B" }
#BNS-Corpus>header>nav>ol>li+li::before{ Margin-Inline-Start: .5EM; Border-Inline-Start: Thin Solid; Padding-Inline-Start: .5EM; Content: "" }
#BNS-Corpus>header>nav a{ Color: Var(--Text); Text-Decoration: None }
#BNS-Corpus>header>nav a:Focus,#BNS-Corpus>header>nav a:Hover{ Text-Decoration: Underline }
#BNS-Corpus>div{ Position: Relative; Flex: Auto; Margin-Block: 0 -1REM; Margin-Inline: -5REM; Min-Block-Size: 24REM; Overflow: Hidden }
#BNS-Corpus>div>*{ Display: Grid; Position: Absolute; Box-Sizing: Border-Box; Inset-Block: 0; Inset-Inline: 0 Auto; Border: .25REM Var(--Shade) Solid; Border-Radius: 4REM; Padding: 2REM; Inline-Size: 100%; Gap: 1REM 2REM; Grid-Template-Rows: Min-Content 1FR Min-Content; Grid-Template-Columns: 1FR 23EM; Overflow: Auto; Background: Var(--Canvas) }
#BNS-Corpus>div>*[data-slide=in]{ Animation: In-From-End 1S Both }
#BNS-Corpus>div>*[data-direction=reverse][data-slide=in]{ Animation: In-From-Start 1S Both }
#BNS-Corpus>div>*[data-slide=out]{ Animation: Out-To-Start 1S Both }
#BNS-Corpus>div>*[data-direction=reverse][data-slide=out]{ Animation: Out-To-End 1S Both }
#BNS-Corpus>div>*[hidden]{ Display: None }
#BNS-Corpus>div>*>header,#BNS-Corpus>div>*>header+section,#BNS-Corpus>div>*>div,#BNS-Corpus>div>*>footer{ Grid-Column: 1 / Span 2 }
#BNS-Corpus>div>*>header{ Display: Grid; Grid-Auto-Flow: Dense Column; Grid-Row: 1 / Span 1; Margin-Block: -1REM 0; Margin-Inline: -2REM; Border-Block-End: Thin Var(--Shade) Solid; Padding-Block: 0 1REM; Padding-Inline: 2REM; Grid-Template-Rows: Auto Auto Auto; Grid-Template-Columns: Auto 1EM 1EM Max-Content 1EM 1EM Auto; Gap: .3125EM .5REM; Text-Align: Center }
#BNS-Corpus>div>*>header>p{ Grid-Column: 2 / Span 5; Margin-Block: 0; Min-Inline-Size: Max-Content; Color: Var(--Bold); Font-Variant-Caps: Small-Caps; Text-Align: Center; Text-Decoration: Underline }
#BNS-Corpus>div>*>header>p>a{ Color: Inherit }
#BNS-Corpus>div>*>header>p>a:Focus,#BNS-Corpus>div>*>header>p>a:Hover{ Color: Var(--Shade); Text-Decoration: Double Underline }
#BNS-Corpus>div>*>header>hgroup>h2{ Grid-Column: 1 / Span 7; Margin-Block: 0; Inline-Size: Min-Content; Min-Inline-Size: 100%; Color: Var(--Shade); Font-Size: X-Large; Font-Family: Var(--Sans); Line-Height: 1 }
#BNS-Corpus>div>*>header>hgroup>h3{ Grid-Column: 4 / Span 1; Margin-Block: 0; Color: Var(--Attn); Font-Size: Inherit; Font-Weight: Inherit; Font-Variant-Caps: Small-Caps }
#BNS-Corpus>div>*>header>hgroup,#BNS-Corpus>div>*>header>nav{ Display: Contents }
#BNS-Corpus>div>*>header>nav>a{ Text-Decoration: None }
#BNS-Corpus>div>*>header>nav>a[data-nav=prev]{ Grid-Column: 2 / Span 1 }
#BNS-Corpus>div>*>header>nav>a[data-nav=parent]{ Grid-Column: 3 / Span 1 }
#BNS-Corpus>div>*>header>nav>a[data-nav=child]{ Grid-Column: 5 / Span 1 }
#BNS-Corpus>div>*>header>nav>a[data-nav=next]{ Grid-Column: 6 / Span 1 }
#BNS-Corpus>div>*>section{ Display: Flex; Flex-Direction: Column; Box-Sizing: Border-Box; Grid-Row: 2 / Span 1; Margin-Inline: Auto; Border-Block: Thin Var(--Shade) Solid; Padding-Inline: 0 1PX; Inline-Size: 100%; Max-Inline-Size: 23EM; Overflow-Block: Auto; Overflow-Inline: Hidden }
#BNS-Corpus>div>*>section>*{ Flex: 1; Border-Color: Var(--Shade); Margin-Block: -1PX 0; Border-Block-Style: Solid Double; Border-Block-Width: Thin Medium; Border-Inline-Style: Solid Double; Border-Inline-Width: Thin Medium; Padding-Block: 1EM; Padding-Inline: 1EM; Background: Var(--Background); Box-Shadow: 1PX 1PX Var(--Shade) }
#BNS-Corpus>div>*>section>*:Not(:Empty)~*{ Margin-Block-Start: Calc(1EM + 1PX) }
#BNS-Corpus>div>*>section>*:Empty:Not(:Only-Child){ Display: None }
#BNS-Corpus>div>*>figure{ Display: Grid; Grid-Row: 2 / Span 1; Grid-Column: 1 / Span 1; Margin: 0; Padding: 0; Block-Size: 100%; Inline-Size: 100%; Overflow: Hidden }
#BNS-Corpus>div>*>figure>*{ Border: None; Grid-Row: 1 / Span 1; Grid-Column: 1 / Span 1; Block-Size: 100%; Inline-Size: 100%; Object-Fit: Contain }
#BNS-Corpus>div>*>figure>iframe{ Object-Fit: Fill }
#BNS-Corpus>div>*>div{ Grid-Row: 2 / Span 1 }
#BNS-Corpus>div>*>footer{ Display: Flex; Grid-Row: 3 / Span 1; Margin-Block: 0 -2REM; Margin-Inline: -2REM; Border-Block-Start: Thin Var(--Shade) Solid; Padding-Block: 1EM; Padding-Inline: 3EM; Max-Inline-Size: Calc(100% + 4REM - 6EM); Justify-Content: Space-Between; Font-Size: Smaller; White-Space: NoWrap }
#BNS-Corpus>div>*>footer>*:First-Child:Not(:Only-Child){ Flex: None }
#BNS-Corpus>div>*>footer>*+*:Last-Child{ Display: Grid; Margin-Inline-Start: 1EM; Grid-Template-Columns: Max-Content 1FR Max-Content }
#BNS-Corpus>div>*>footer>*+*:Last-Child>a{ Max-Inline-Size: 100%; Overflow: Hidden; Text-Overflow: Ellipsis }
#BNS-Corpus div.FILES{ Margin-Block: -1REM; Margin-Inline: -2REM; Block-Size: Auto }
h4{ Margin-Block: 0 .5REM; Margin-Inline: Auto; Border-Width: Thin; Border-Block-Style: Dotted Solid; Border-Block-Color: Var(--Fade) Var(--Shade); Border-Inline-Style: Dashed; Border-Inline-Color: Var(--Text); Padding-Block: .3125EM; Padding-Inline: 1EM; Max-Inline-Size: Max-Content; Color: Var(--Text); Font-Size: X-Large; Font-Family: Var(--Sans); Line-Height: 1; Text-Align: Center }
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
dd>ul{ Margin-Block: 0 .5REM; Margin-Inline: -1REM 0; Text-Align: End; Font-Size: Smaller }
dd>ul:Not(:Empty){ Margin-Block-Start: .25REM; Border-Block-Start: Thin Transparent Solid; Padding-Block: .25REM 0 }
dd>ul:Not(:Empty)::before{ Box-Sizing: Border-Box; Position: Absolute; Inset-Inline: 0; Margin-Block: -.5REM 0; Border-Block-End: Thin Var(--Fade) Dashed; Block-Size: .25REM; Content: "" }
dd:Not(:Last-Child)>ul{ Margin-Block-End: .75REM; Border-Block-End: Thin Var(--Text) Solid; Padding-Block-End: .75REM }
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
    const div= document.querySelector("#BNS-Corpus>div")
    div.removeChild(div.firstElementChild)
    let element= location.hash.length > 1 ? document.getElementById
      ( decodeURIComponent(location.hash.substring(1)) )
    : null
    if ( !element || !element.matches("#BNS-Corpus>div>*") )
      element= document.querySelector("#BNS-Corpus>div>*")
    for ( const panel of document.querySelectorAll("#BNS-Corpus>div>*") ) {
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
      if ( !element || !element.matches("#BNS-Corpus>div>*") )
        return
      for ( const panel of document.querySelectorAll("#BNS-Corpus>div>*") ) {
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
      const current= document.querySelector("#BNS-Corpus>div>*:Not([hidden])")
      const { key }= event
      if ( key == "ArrowRight" || key == "ArrowLeft" )
        event.preventDefault()
      if (
        document.querySelector("#BNS-Corpus>div>*[data-slide]")
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
					<when test="@resource and document($rdf)//bns:*[local-name()='includes' or local-name()='hasProject']/*[@rdf:about=current()/@resource]">
						<attribute name="href">
							<text>#</text>
							<for-each select="document($rdf)//bns:*[local-name()='includes' or local-name()='hasProject']/*[@rdf:about=current()/@resource][1]">
								<call-template name="anchor"/>
							</for-each>
						</attribute>
					</when>
					<when test="not(@resource) and document($rdf)//bns:*[local-name()='includes' or local-name()='hasProject']/*[@rdf:about=current()/@href]">
						<attribute name="href">
							<text>#</text>
							<for-each select="document($rdf)//bns:*[local-name()='includes' or local-name()='hasProject']/*[@rdf:about=current()/@href][1]">
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
	<template match="html:article[@id='BNS-Corpus']">
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
			<if test="skos:closeMatch[@rdf:resource]">
				<html:div>
					<html:dt>In Other Systems</html:dt>
					<for-each select="skos:closeMatch/@rdf:resource">
						<html:dd>
							<html:a href="{.}">
								<html:code>
									<call-template name="shorten">
										<with-param name="uri" select="."/>
									</call-template>
								</html:code>
							</html:a>
						</html:dd>
					</for-each>
				</html:div>
			</if>
		</variable>
		<if test="string($contents)">
			<html:dl lang="en">
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
