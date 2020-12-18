#!/usr/bin/env -S deno run --allow-read=. --allow-write=.
import { parse as YAML } from "https://deno.land/std@0.80.0/encoding/yaml.ts"

const NREGEX = /^(?:[-+]?[0-9]+|-?(?:[1-9][0-9]{3,}|0[0-9]{3})-(?:0[1-9]|1[0-2])(?:-(?:0[1-9]|[12][0-9]|3[01]))?(?:Z|[-+](?:(?:0[0-9]|1[0-3]):[0-5][0-9]|14:00))?|[A-Z_a-z\u{C0}-\u{D6}\u{D8}-\u{F6}\u{F8}-\u{2FF}\u{370}-\u{37D}\u{37F}-\u{1FFF}\u{200C}-\u{200D}\u{2070}-\u{218F}\u{2C00}-\u{2FEF}\u{3001}-\u{D7FF}\u{F900}-\u{FDCF}\u{FDF0}-\u{FFFD}\u{10000}-\u{EFFFF}][A-Z_a-z\u{C0}-\u{D6}\u{D8}-\u{F6}\u{F8}-\u{2FF}\u{370}-\u{37D}\u{37F}-\u{1FFF}\u{200C}-\u{200D}\u{2070}-\u{218F}\u{2C00}-\u{2FEF}\u{3001}-\u{D7FF}\u{F900}-\u{FDCF}\u{FDF0}-\u{FFFD}\u{10000}-\u{EFFFF}\-\.0-9\u{B7}\u{300}-\u{36F}\u{203F}-\u{2040}]*)$/u

function esc ( text ) {
	return text.replace(/&/g, "&amp;").replace(/</g, "&lt;") }

function generateIndex ( base, path, id ) {
	let gitattributes = null
	let hasGitAttribute = false
	try { // remove index.html if generated
		gitattributes = Deno.readTextFileSync(`${ base }${ path }/.gitattributes`)
		hasGitAttribute = gitattributes?.split?.("\n")?.includes?.("/index.html linguist-generated")
		if ( hasGitAttribute )
			Deno.removeSync(`${ base }${ path }/index.html`) }
	catch ( e ) { }
	try { // quit if index.html is not generated
		if ( Deno.statSync(`${ base }${ path }/index.html`).isFile )
			return }
	catch ( e ) { }
	try { // add generated marker for index.html
		if ( !hasGitAttribute )
			Deno.writeTextFileSync(`${ base }${ path }/.gitattributes`, `/index.html linguist-generated
${ gitattributes ?? "" }`) }
	catch ( e ) { }
	try { // generate index.html
		Deno.writeTextFileSync(`${ base }${ path }/index.html`, `<!dOcTyPe HtMl>
<HTML Lang=en>
	<TITLE>Redirect to description</TITLE>
	<BASE HRef="${ new Array (path.split("/").length).fill("..").join("/") }">
	<LINK Rel=alternate HRef=":bns/index.rdf" Type=application/rdf+xml>
	<META Http-Equiv=refresh Content="0; ${ new Array (path.split("/").length).fill("..").join("/") }/#${ id }"/>
	<P>
		<A HRef="#${ id }">View this directory’s description in the BNS corpus.</A>
`) }
	catch ( e ) { } }

function document ( object, path = "" ) {
	if ( object.KIND == null )
		return null
	else if ( Array.isArray(object.KIND) ) {
		let doctype = (( ) => {
			switch ( false ) {
				case !object.KIND.includes("Video"):
					return "dcmitype:MovingImage"
				case !object.KIND.includes("Image"):
					return "dcmitype:StillImage"
				case !object.KIND.includes("Audio"):
					return "dcmitype:Sound"
				case !object.KIND.includes("Text"):
					return "dcmitype:Text"
				default:
					return null } })()
		if ( !doctype ) return null
		const result = [ ]
		for ( const _nnn in object ) {
			if ( !/^_[1-9][0-9]*$/.test(_nnn) )
				continue
			let page = object[_nnn]
			result.push(`<rdf:${ _nnn } rdf:resource="${ page.IRI != null ? /^[^/]*:/.test(page.IRI) ? page.IRI : `./${ path }/${ page.IRI }` : `./${ path }/${ page }` }"/>`) }
		if ( object.KIND.includes("Sequence") )
			return `<rdf:Seq rdf:type="${ doctype }">${ object.FORMAT?.MIMETYPE != null ? `
		<dc:format>
	<dc:FileFormat>
		<dc:identifier rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ object.FORMAT.MIMETYPE }</dc:identifier>
	</dc:FileFormat>
		</dc:format>` : "" }
		${ result.join(`
		`) || "<!-- empty -->" }
	</rdf:Seq>`
		else if ( object.KIND.includes("Set") )
			return `<rdf:Bag rdf:type="${ doctype }">${ object.FORMAT?.MIMETYPE != null ? `
		<dc:format>
	<dc:FileFormat>
		<dc:identifier rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ object.FORMAT.MIMETYPE }</dc:identifier>
	</dc:FileFormat>
		</dc:format>` : "" }
		${ result.join(`
		`) || "<!-- empty -->" }
	</rdf:Bag>`
		else return null }
	else {
		let doctype = (( ) => {
			switch ( object?.KIND ) {
				case "Audio":
					return "dcmitype:Sound"
				case "Image":
					return "dcmitype:StillImage"
				case "Text":
					return "dcmitype:Text"
				case "Video":
					return "dcmitype:MovingImage"
				default:
					return null } })()
		if ( !doctype ) return null
		else return `<${ doctype }${ object.IRI != null ? ` rdf:about="${ /^[^/]*:/.test(object.IRI) ? object.IRI : `./${ path }/${ object.IRI }` }"` : "" }>${ object.FORMAT?.MIMETYPE != null ? `
		<dc:format>
	<dc:FileFormat>
		<dc:identifier rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ object.FORMAT.MIMETYPE }</dc:identifier>
	</dc:FileFormat>
		</dc:format>` : "" }
	</${ doctype }>` } }

function properties ( object, path = "" ) {
	if ( object == null || typeof object != "object" )
		return null
	else {
		const result = [ ]
		if ( object.ID != null )
			result.push(`<identifier rdf:datatype="http://www.w3.org/2001/XMLSchema#NCName">${ object.ID }</identifier>`)
		if ( object.N != null )
			result.push(`<index rdf:datatype="${ /^-?\d+$/.test(object.N) ? "http://www.w3.org/2001/XMLSchema#integer" : /-?\d{4,}-\d{2}-\d{2}/.test(object.N) ? "http://www.w3.org/2001/XMLSchema#date" : /-?\d{4,}-\d{2}/.test(object.N) ? "http://www.w3.org/2001/XMLSchema#gYearMonth" : "http://www.w3.org/2001/XMLSchema#NCName" }">${ object.N }</index>`)
		if ( object.TITLE != null )
			result.push(`<fullTitle xml:lang="${ object.TITLE.LANG ?? "en" }">${ esc(object.TITLE.TEXT ?? object.TITLE) }</fullTitle>`)
		if ( object.SHORTTITLE != null )
			result.push(`<abbreviatedTitle xml:lang="${ object.SHORTTITLE.LANG ?? "en" }">${ esc(object.SHORTTITLE.TEXT ?? object.SHORTTITLE) }</abbreviatedTitle>`)
		if ( object.INSPIRATION != null )
			if ( Array.isArray(object.INSPIRATION) )
				for ( const inspiration of object.INSPIRATION ) {
					result.push(`<inspiration rdf:resource="${ inspiration }"/>`) }
			else
				result.push(`<inspiration rdf:resource="${ object.INSPIRATION }"/>`)
		if ( object.COVER != null )
			if ( object.COVER.CONTENTS != null )
				result.push(`<hasCover rdf:parseType="Resource">
			<contents rdf:parseType="Literal">${ object.COVER.CONTENTS }</contents>
		</hasCover>`)
			else
				result.push(`<hasCover>
	${ document(object.COVER, path) ?? "" }
		</hasCover>`)
		if ( object.ABSTRACT?.CONTENTS != null )
			result.push(`<dc:abstract rdf:parseType="Resource">
			<contents rdf:parseType="Literal">${ object.ABSTRACT.CONTENTS }</contents>
		</dc:abstract>`)
		if ( object.PUBLISHED != null )
			if ( Array.isArray(object.PUBLISHED) )
				for ( const published of object.PUBLISHED ) {
					result.push(`<isPublishedAs>
	${ document(published, path) ?? "" }
		</isPublishedAs>`) }
			else
				result.push(`<isPublishedAs>
	${ document(object.PUBLISHED, path) ?? "" }
		</isPublishedAs>`)
		return result.join(`
		`) } }

function branches ( base, path ) {
	const result = []
	try {
		if ( !Deno.statSync(`${ base }${ path }`).isDirectory )
			return null }
	catch ( e ) { return null }
	for ( const entry of Deno.readDirSync(`${ base }${ path }`) ) {
		if ( !entry.isDirectory || !NREGEX.test(entry.name) )
			continue
		let branch = entry.name
		let subpath = `${ path }/${ branch }`
		try {
			let info = YAML(Deno.readTextFileSync(`${ base }${ subpath }/@.yml`))
			let iri = info.IRI ?? (this.IRI ?? `tag:${ base.substring(2, base.length - 1) }:bns::`) + `:${ subpath.replace(/\//g, ":") }`
			let id = iri.replace(this.IRI ?? `tag:${ base.substring(2, base.length - 1) }:bns::`, `${ this.ID ?? base.substring(2, base.length - 1) }:`)
			result.push(`<includes>
	<${ info.KIND ?? "Branch" } rdf:about="${ iri }">
		<owl:sameAs rdf:resource="./${ subpath }/"/>
		<owl:sameAs rdf:resource="#${ id }"/>
		${ properties(info, subpath) ?? "" }${ info.PUBLISHED == null ? `
		${ branches.call(this, base, subpath) }` : "" }
	</${ info.KIND ?? "Branch" }>
		</includes>`)
			generateIndex(base, subpath, id) }
		catch ( e ) { result.push(`<includes>
	<Branch rdf:about="./${ subpath }/">
		${ branches.call(this, base, subpath) || "<!-- empty -->" }
	</Branch>
		</includes>`) } }
	try {
		for ( const entry of Deno.readDirSync(`${ base }${ path }/:notes`) ) {
			if ( !entry.isDirectory || !NREGEX.test(entry.name) )
				continue
			let note = entry.name
			let subpath = `${ path }/:notes/${ note }`
			try {
				let info = YAML(Deno.readTextFileSync(`${ base }${ subpath }/@.yml`))
				let iri = info.IRI ?? (this.IRI ?? `tag:${ base.substring(2, base.length - 1) }:bns::`) + `:${ path.replace(/\//g, ":") }::notes:${ note }`
				let id = iri.replace(this.IRI ?? `tag:${ base.substring(2, base.length - 1) }:bns::`, `${ this.ID ?? base.substring(2, base.length - 1) }:`)
				result.push(`<hasNote>
	<Note rdf:about="${ iri }">
		<owl:sameAs rdf:resource="./${ subpath }/"/>
		<owl:sameAs rdf:resource="#${ id }"/>
		${ properties(info, subpath) || "<!-- empty -->" }
	</Note>
		</hasNote>`)
				generateIndex(base, subpath, id) }
			catch ( e ) { result.push(`<hasNote>
	<Note rdf:about="./${ subpath }/"/>
		</hasNote>`) } } }
	catch ( e ) { }
	return result.join(`
		`) }

function projects ( base ) {
	const result = []
	if ( this?.PROJECTS == null ) return null
	for ( const _nnn in this.PROJECTS ) {
		if ( !/^_[1-9][0-9]*$/.test(_nnn) )
			continue
		let project = this.PROJECTS[_nnn]
		try {
			let info = YAML(Deno.readTextFileSync(`${ base }${ project }/@.yml`))
			let iri = info.IRI ?? (this.IRI ?? `tag:${ base.substring(2, base.length - 1) }:bns::`) + `:${ project }`
			let id = iri.replace(this.IRI ?? `tag:${ base.substring(2, base.length - 1) }:bns::`, `${ this.ID ?? base.substring(2, base.length - 1) }:`)
			if ( info.KIND != "Project" )
				throw new Error
			result.push(`<rdf:${ _nnn }>
	<Project rdf:about="${ iri }">
		<owl:sameAs rdf:resource="./${ project }/"/>
		<owl:sameAs rdf:resource="#${ id }"/>
		${ properties(info, project) ?? "" }
		${ branches.call(this, base, project) }
	</Project>
		</rdf:${ _nnn }>`)
			generateIndex(base, project, id) }
		catch ( e ) { result.push(`<rdf:${ _nnn }>
	<Project rdf:about="./${ project }/">
		${ branches.call(this, base, project) || "<!-- empty -->" }
	</Project>
		</rdf:${ _nnn }>`) } }
	return `<rdf:Seq>
		${ result.join(`
		`) }
	</rdf:Seq>` }

function corpus ( path ) {
	try {
		const info = YAML(Deno.readTextFileSync(`${ path }@.yml`))
		if ( info.KIND != "Corpus" )
			return null
		return `<rdf:RDF
	xml:base="../"
	xmlns="https://go.KIBI.family/Ontologies/BNS/#"
	xmlns:bns="https://go.KIBI.family/Ontologies/BNS/#"
	xmlns:dc="http://purl.org/dc/terms/"
	xmlns:dcmitype="http://purl.org/dc/dcmitype"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>
	<owl:Ontology rdf:about="#">
		<owl:imports rdf:resource="https://go.KIBI.family/Ontologies/BNS/#"/>
	</owl:Ontology>
	<Corpus rdf:about="${ info.IRI ?? `tag:${ path.substring(2, path.length - 1) }:bns::` }">
		<owl:sameAs rdf:resource="./"/>
		<owl:sameAs rdf:resource="#${ info.ID ?? path.substring(2, path.length - 1) }:"/>
		${ properties(info) ?? "" }
		${ info.AUTHOR != null ? `<forAuthor>
	<Author rdf:about="${ info.AUTHOR.IRI ?? info.AUTHOR }">
		${ properties(info.AUTHOR) || "<!-- empty -->" }
	</Author>
		</forAuthor>` : "" }
		<hasProjects>
	${ projects.call(info, path) || "<!-- empty -->" }
		</hasProjects>
	</Corpus>
</rdf:RDF>
` }
	catch ( e ) { return null } }

for ( const entry of Deno.readDirSync(".") ) {
	if ( !entry.isDirectory )
		continue
	const document = corpus(`./${ entry.name }/`)
	if ( document != null ) {
		console.log(`Writing corpus: ./${ entry.name }/:bns/index.rdf`)
		Deno.mkdirSync(`./${ entry.name }/:bns`, { recursive: true })
		Deno.writeTextFileSync(`./${ entry.name }/:bns/index.rdf`, document) } }
