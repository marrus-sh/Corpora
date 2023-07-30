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
		xmlns="https://ns.1024.gdn/BNS/#"
		xmlns:bns="https://ns.1024.gdn/BNS/#"
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
	xmlns:bns="https://ns.1024.gdn/BNS/#"
	xmlns:dc="http://purl.org/dc/terms/"
	xmlns:dcmitype="http://purl.org/dc/dcmitype/"
	xmlns:exsl="http://exslt.org/common"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
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
						<when test="self::*[substring(local-name(), 1, 1)='_'][translate(substring(local-name(), 2, 1), '123456789', '')=''][translate(substring(local-name(), 3), '0123456789', '')=''][namespace-uri()='http://www.w3.org/1999/02/22-rdf-syntax-ns#']/parent::bns:FileSequence/bns:mediaType">
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
			<for-each select="bns:hasFile/*[self::bns:FileSequence or @rdf:about]|bns:hasFile[@rdf:resource]">
				<variable name="mediatype">
					<value-of select="bns:mediaType"/>
				</variable>
				<variable name="contents">
					<choose>
						<when test="self::bns:FileSequence">
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
								<when test="self::bns:FileSequence">
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
						<if test="self::bns:FileSequence">
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
								<if test="not(self::bns:FileSequence)">
									<attribute name="type">
										<value-of select="$mediatype"/>
									</attribute>
								</if>
								<html:code>
									<value-of select="$mediatype"/>
								</html:code>
								<choose>
									<when test="bns:textLabel">
										<text> </text>
										<html:small>
											<text>(</text>
											<apply-templates select="bns:textLabel" mode="contents"/>
											<if test="self::bns:FileSequence">
												<text>, multiple</text>
											</if>
											<text>)</text>
										</html:small>
									</when>
									<otherwise>
										<if test="self::bns:FileSequence">
											<text> </text>
											<html:small>(multiple)</html:small>
										</if>
									</otherwise>
								</choose>
							</when>
							<otherwise>
								<variable name="dcmitype">
									<for-each select="rdf:type/@rdf:resource">
										<variable name="datatypeelt">
											<element name="{.}"/>
										</variable>
										<if test="namespace-uri(exsl:node-set($datatypeelt)//*[1])='http://purl.org/dc/dcmitype/'">
											<value-of select="local-name(exsl:node-set($datatypeelt)//*[1])"/>
											<text>,</text>
										</if>
									</for-each>
								</variable>
								<choose>
									<when test="contains($dcmitype, ',')">
										<value-of select="substring-before($dcmitype, ',')"/>
									</when>
									<otherwise>
										<text>???</text>
									</otherwise>
								</choose>
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
				<if test="ore:similarTo[@rdf:resource]">
					<html:p>
						<html:strong lang="en">Elsewhere:</html:strong>
						<text> </text>
						<for-each select="ore:similarTo/@rdf:resource">
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
