<!DOCTYPE stylesheet [
	<!ENTITY NCName "http://www.w3.org/2001/XMLSchema#NCName">
	<!ENTITY gYearMonth "http://www.w3.org/2001/XMLSchema#gYearMonth">
	<!ENTITY integer "http://www.w3.org/2001/XMLSchema#integer">
	<!ENTITY date "http://www.w3.org/2001/XMLSchema#date">
]>
<!--
⁌ Branching Notational System X·S·L Transformation Helpers (BNS-Helpers.xslt)

§ Usage :—

Requires both X·S·L·T 1.0 and E·X·S·L·T Common support.  C·S·S features require at least Firefox 76 / Safari 14.1 / Chrome 89.  Stick the following at the beginning of your X·S·L·T stylesheet :—

	<import href="/path/to/BNS-Helpers.xslt"/>


The ‹ helper-css › and ‹ helper-js › named templates provide necessary <style> and <script> rules.

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
	<template name="file">
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
	<template name="shorten">
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
	<template name="lang">
		<attribute name="lang">
			<value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
		</attribute>
	</template>
	<template name="expand">
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
	<template name="resolve">
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
	<template name="anchor">
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
	<template name="formatnumber">
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
	<template name="subsuper">
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
	<template name="formatted">
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
	<template name="namedformat">
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
	<template name="prefixes">
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
	<template name="helper-css">
		<html:style>
html{ Margin: 0; Padding: 0; Font-Family: Serif; Line-Height: 1.25; --Background: Canvas; --Canvas: Canvas; --Fade: GrayText; --Magic: LinkText; --Text: CanvasText; --Attn: ActiveText; --Bold: VisitedText; --Shade: CanvasText }
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
code{ Overflow-Wrap: Break-Word }
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
	<template name="helper-js">
		<html:script>
const unprefix= prefix =>
  (
    { bf: "http://id.loc.gov/ontologies/bibframe/"
    , bns: "https://go.KIBI.family/Ontologies/BNS/#"
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
	<template match="*" mode="xml-serialize">
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
	<template match="@*" mode="xml-serialize">
		<text> </text>
		<value-of select="name()"/>
		<text>="</text>
		<value-of select="."/>
		<text>"</text>
	</template>
	<template match="text()" mode="xml-serialize">
		<value-of select="."/>
	</template>
	<template match="*" mode="contents">
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
	<template match="html:*|svg:*">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<apply-templates/>
		</copy>
	</template>
	<template match="html:a">
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
	<template match="*[parent::rdf:RDF]"/>
	<template match="*" mode="files">
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
								<if test="self::rdf:Bag|self::rdf:Seq">
									<text> </text>
									<html:small>
										<text>(multiple)</text>
									</html:small>
								</if>
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
			</html:footer>
		</html:div>
	</template>
</stylesheet>
