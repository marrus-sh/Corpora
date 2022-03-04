#!/usr/bin/env -S deno run --allow-read=. --allow-write=.
import
  { parse as YAML
  , JSON_SCHEMA }
from "https://deno.land/std@0.126.0/encoding/yaml.ts"

const NREGEX=
  /^(?:[-+]?[0-9]+|-?(?:[1-9][0-9]{3,}|0[0-9]{3})-(?:0[1-9]|1[0-2])(?:-(?:0[1-9]|[12][0-9]|3[01]))?(?:Z|[-+](?:(?:0[0-9]|1[0-3]):[0-5][0-9]|14:00))?|'?[A-Z_a-z\u{C0}-\u{D6}\u{D8}-\u{F6}\u{F8}-\u{2FF}\u{370}-\u{37D}\u{37F}-\u{1FFF}\u{200C}-\u{200D}\u{2070}-\u{218F}\u{2C00}-\u{2FEF}\u{3001}-\u{D7FF}\u{F900}-\u{FDCF}\u{FDF0}-\u{FFFD}\u{10000}-\u{EFFFF}][A-Z_a-z\u{C0}-\u{D6}\u{D8}-\u{F6}\u{F8}-\u{2FF}\u{370}-\u{37D}\u{37F}-\u{1FFF}\u{200C}-\u{200D}\u{2070}-\u{218F}\u{2C00}-\u{2FEF}\u{3001}-\u{D7FF}\u{F900}-\u{FDCF}\u{FDF0}-\u{FFFD}\u{10000}-\u{EFFFF}\-\.0-9\u{B7}\u{300}-\u{36F}\u{203F}-\u{2040}]*)[°′″]?$/u

function esc ( text ) {
  return text.replace(/&/g, "&amp;").replace(/</g, "&lt;")
}

function generateIndex ( base, path, id ) {
  let gitattributes= null
  let hasGitAttribute= false
  try { // remove index.html if generated
    gitattributes= Deno.readTextFileSync
      ( `${ base }${ path }/.gitattributes` )
    hasGitAttribute= gitattributes
      ?.split
      ?.("\n")
      ?.includes
      ?.("/index.html linguist-generated")
    if ( hasGitAttribute )
      Deno.removeSync(`${ base }${ path }/index.html`)
  } catch { }
  try { // quit if index.html is not generated
    if ( Deno.statSync(`${ base }${ path }/index.html`).isFile )
      return
  } catch { }
  try { // add generated marker for index.html
    if ( !hasGitAttribute )
      Deno.writeTextFileSync
        ( `${ base }${ path }/.gitattributes`
        , `/index.html linguist-generated
${ gitattributes || "" }` )
  } catch { }
  try { // generate index.html
    Deno.writeTextFileSync
      ( `${ base }${ path }/index.html`
      , `<!dOcTyPe hTmL>
<HTML Lang=en>
	<TITLE>Redirect to description</TITLE>
	<LINK Rel=alternate HRef="${ new Array (path.split("/").length).fill("..").join("/") }/:bns/index.rdf" Type=application/rdf+xml>
	<META Http-Equiv=refresh Content="0; ${ new Array (path.split("/").length).fill("..").join("/") }/:bns/#${ id }"/>
	<P>
		<A HRef="${ new Array (path.split("/").length).fill("..").join("/") }/:bns/#${ id }">View this directory’s description in the B·N·S corpus.</A>
` )
  } catch { }
}

function indexDatatype ( n ) {
  return /^-?\d+$/.test(n) ? "http://www.w3.org/2001/XMLSchema#integer"
  : /-?\d{4,}-\d{2}-\d{2}/.test(n) ? "http://www.w3.org/2001/XMLSchema#date"
  : /-?\d{4,}-\d{2}/.test(n) ? "http://www.w3.org/2001/XMLSchema#gYearMonth"
  : "http://www.w3.org/2001/XMLSchema#NCName"
}

function textElement ( tag, object ) {
  if ( object.TEXT == null )
    return `<${ tag } xml:lang="en">${ esc(object) }</${ tag }>`
  else {
    const lang= object.LANG ?? "en"
    const text= object.TEXT
    return `<${ tag } xml:lang="${ lang }">${ esc(text) }</${ tag }>` } }

function writeIndex ( base, id, anchor ) {
  const result= [ `<indexes rdf:resource="../:bns/#${ anchor }"/>` ]
  if ( this.TITLE != null )
    result.push(textElement("fullTitle", this.TITLE))
  if ( this.SHORTTITLE != null )
    result.push(textElement("shortTitle", this.SHORTTITLE))
  if ( this.COVER != null )
    if ( this.COVER.CONTENTS != null )
      result.push(`<hasCover rdf:parseType="Resource">
	<contents rdf:parseType="Literal">${ this.COVER.CONTENTS }</contents>
</hasCover>`)
    else
      result.push(`<hasCover>
${ document(this.COVER, id) || "" }
</hasCover>`)
  for ( const selected of Array.from(this.INDEX) ) {
    result.push(`<selects rdf:parseType="Resource">
		<branch rdf:resource="${ selected.BRANCH != null ? /^[^/]+\x3A/.test(selected.BRANCH) ? selected.BRANCH : `../${ id }/${ selected.BRANCH }` : `../${ id }/${ selected }` }"/>
	</selects>`)
  }
  console.log(`Writing index: ${ base }${ id }/index.rdf`)
  Deno.writeTextFileSync
    ( `${ base }${ id }/index.rdf`
    , `<Index
	xmlns="https://go.KIBI.family/Ontologies/BNS/#"
	xmlns:bns="https://go.KIBI.family/Ontologies/BNS/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>
	${ result.join(`
	`) }
</Index>
` )
}

function document ( object, path = "" ) {
  if ( object.KIND == null )
    return null
  else if ( Array.isArray(object.KIND) ) {
    let doctype= (( ) => {
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
          return null
    } })()
    if ( !doctype )
      return null
    else {
      const result= [ ]
      for ( const _nnn in object ) {
        if ( !/^_[1-9][0-9]*$/.test(_nnn) )
          continue
        else {
          let page= object[_nnn]
          result.push(`<rdf:${ _nnn } rdf:resource="${ page.IRI != null ? /^[^/]+\x3A/.test(page.IRI) ? page.IRI : `../${ path }/${ page.IRI }` : `../${ path }/${ page }` }"/>`)
        }
      }
      if ( object.KIND.includes("Sequence") )
        return `<rdf:Seq rdf:type="${ doctype }">${ object.FORMAT != null ? `
	<mediaType rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ object.FORMAT }</mediaType>` : "" }
  ${ result.join(`
	`) || "<!-- empty -->" }
</rdf:Seq>`
      else if ( object.KIND.includes("Set") )
        return `<rdf:Bag rdf:type="${ doctype }">${ object.FORMAT != null ? `
	<mediaType rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ object.FORMAT }</mediaType>` : "" }
  ${ result.join(`
	`) || "<!-- empty -->" }
</rdf:Bag>`
      else return null
    }
  } else {
    let doctype= (( ) => {
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
          return null
    } })()
    if ( !doctype )
      return null
    else
      return `<${ doctype } rdf:about="${ object.IRI != null ? /^[^/]+\x3A/.test(object.IRI) ? object.IRI : `../${ path }/${ object.IRI }` : `../${ path }/${ object }` }">${ object.FORMAT != null ? `
	<mediaType rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ object.FORMAT }</mediaType>` : "" }
</${ doctype }>`
} }

function song ( object ) {
  if ( object == null || typeof object != "object" )
    return null
  else {
    const result= [ ]
    if ( object.CITATION != null )
      result.push(`<citation rdf:parseType="Literal">${ object.CITATION }</citation>`)
    if ( object.AVAILABLE != null )
      if ( Array.isArray(object.AVAILABLE) )
        for ( const published of object.AVAILABLE ) {
          if ( published.URL == null )
            continue
          result.push(`<isMadeAvailableBy rdf:parseType="Resource">
	<url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">${ published.URL }</url>${ published.SITELABEL != null ? `
	<siteLabel rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ published.SITELABEL }</siteLabel>` : "" }
		</isMadeAvailableBy>`)
        }
      else if ( object.AVAILABLE.URL != null )
        result.push(`<isMadeAvailableBy rdf:parseType="Resource">
	<url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">${ object.AVAILABLE.URL }</url>${ object.AVAILABLE.SITELABEL != null ? `
	<siteLabel rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ object.AVAILABLE.SITELABEL }</siteLabel>` : "" }
		</isMadeAvailableBy>`)
    return result.join(`
		`)
} }

function mixtape ( object, path = "" ) {
  if ( object == null || typeof object != "object" )
    return null
  else {
    const result= [ ]
    if ( object.TITLE != null )
      result.push(textElement("fullTitle", object.TITLE))
    if ( object.SHORTTITLE != null )
      result.push(textElement("fullTitle", object.SHORTTITLE))
    if ( object.COVER != null )
      if ( object.COVER.CONTENTS != null )
        result.push(`<hasCover rdf:parseType="Resource">
	<contents rdf:parseType="Literal">${ object.COVER.CONTENTS }</contents>
		</hasCover>`)
      else
        result.push(`<hasCover>
${ document(object.COVER, path) || "" }
		</hasCover>`)
    if ( object.AVAILABLE != null )
      if ( Array.isArray(object.AVAILABLE) )
        for ( const published of object.AVAILABLE ) {
          if ( published.URL == null )
            continue
          result.push(`<isMadeAvailableBy rdf:parseType="Resource">
	<url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">${ published.URL }</url>${ published.SITELABEL != null ? `
	<siteLabel rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ published.SITELABEL }</siteLabel>` : "" }
		</isMadeAvailableBy>`)
        }
      else if ( object.AVAILABLE.URL != null )
        result.push(`<isMadeAvailableBy rdf:parseType="Resource">
	<url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">${ object.AVAILABLE.URL }</url>${ object.AVAILABLE.SITELABEL != null ? `
	<siteLabel rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ object.AVAILABLE.SITELABEL }</siteLabel>` : "" }
		</isMadeAvailableBy>`)
    if ( object.TRACK != null )
      if ( Array.isArray(object.TRACK) )
        for ( const track of object.TRACK ) {
          result.push(`<hasTrack rdf:parseType="Resource">${ track.N != null ? `
	<index rdf:datatype="${ indexDatatype(track.N) }">${ object.N }</index>` : "" }${ track.SONG != null ? `
	<song rdf:parseType="Resource">
${ song(track.SONG) || "" }
	</song>` : "" }
		</hasTrack>`)
        }
      else
        result.push(`<hasTrack rdf:parseType="Resource">${ object.TRACK.N != null ? `
	<index rdf:datatype="${ indexDatatype(track.N) }">${ object.N }</index>` : "" }${ object.TRACK.SONG != null ? `
	<song rdf:parseType="Resource">
${ song(object.TRACK.SONG) || "" }
	</song>` : "" }
		</hasTrack>`)
    return result.join(`
    `)
} }

function properties ( object, path = "" ) {
  if ( object == null || typeof object != "object" )
    return null
  else {
    const result= [ ]
    if ( object.ID != null )
      result.push(`<identifier rdf:datatype="http://www.w3.org/2001/XMLSchema#NCName">${ object.ID }</identifier>`)
    if ( object.N != null )
      result.push(`<index rdf:datatype="${ indexDatatype(object.N) }">${ object.N }</index>`)
    if ( object.TITLE != null )
      result.push(textElement("fullTitle", object.TITLE))
    if ( object.SHORTTITLE != null )
      result.push(textElement("shortTitle", object.SHORTTITLE))
    if ( object.COVER != null )
      if ( object.COVER.CONTENTS != null )
        result.push(`<hasCover rdf:parseType="Resource">
		<contents rdf:parseType="Literal">${ object.COVER.CONTENTS }</contents>
	</hasCover>`)
      else
        result.push(`<hasCover>
${ document(object.COVER, path) || "" }
	</hasCover>`)
    if ( object.DESCRIPTION?.CONTENTS != null )
      result.push(`<hasDescription rdf:parseType="Resource">
		<contents rdf:parseType="Literal">${ object.DESCRIPTION.CONTENTS }</contents>
	</hasDescription>`)
    if ( object.FILE != null )
      if ( Array.isArray(object.FILE) )
        for ( const published of object.FILE ) {
          result.push(`<hasFile>
${ document(published, path) || "" }
	</hasFile>`)
        }
      else
        result.push(`<hasFile>
${ document(object.FILE, path) || "" }
	</hasFile>`)
    if ( object.FANDOM != null )
      if ( Array.isArray(object.FANDOM) )
        for ( const inspiration of object.FANDOM ) {
          result.push(`<isFanworkOf rdf:resource="${ inspiration }"/>`)
        }
      else
        result.push(`<isFanworkOf rdf:resource="${ object.FANDOM }"/>`)
    if ( object.INSPIRATION != null )
      if ( Array.isArray(object.INSPIRATION) )
        for ( const inspiration of object.INSPIRATION ) {
          result.push(`<isInspiredBy rdf:resource="${ inspiration }"/>`)
        }
      else
        result.push(`<isInspiredBy rdf:resource="${ object.INSPIRATION }"/>`)
    if ( object.THEMESONG != null )
      if ( Array.isArray(object.THEMESONG) )
        for ( const theme of object.THEMESONG ) {
          result.push(`<hasThemeSong rdf:parseType="Resource">
		${ song(theme) || "" }
	</hasThemeSong>`)
        }
      else
        result.push(`<hasThemeSong rdf:parseType="Resource">
		${ song(object.THEMESONG) || "" }
	</hasThemeSong>`)
    if ( object.MIXTAPE != null )
      if ( Array.isArray(object.MIXTAPE) )
        for ( const tape of object.MIXTAPE ) {
          result.push(`<hasMixtape rdf:parseType="Resource">
		${ mixtape(tape, path) || "" }
	</hasMixtape>`)
        }
      else
        result.push(`<hasMixtape rdf:parseType="Resource">
		${ mixtape(object.MIXTAPE, path) || "" }
	</hasMixtape>`)
    if ( object.AVAILABLE != null )
      if ( Array.isArray(object.AVAILABLE) )
        for ( const published of object.AVAILABLE ) {
          if ( published.URL == null )
            continue
          else
            result.push(`<isMadeAvailableBy rdf:parseType="Resource">
		<url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">${ published.URL }</url>${ published.SITELABEL != null ? `
		<siteLabel rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ published.SITELABEL }</siteLabel>` : "" }
	</isMadeAvailableBy>`)
        }
      else if ( object.AVAILABLE.URL != null )
        result.push(`<isMadeAvailableBy rdf:parseType="Resource">
		<url rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">${ object.AVAILABLE.URL }</url>${ object.AVAILABLE.SITELABEL != null ? `
		<siteLabel rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ object.AVAILABLE.SITELABEL }</siteLabel>` : "" }
	</isMadeAvailableBy>`)
    return result.join(`
	`)
} }

function branches ( base, path, parentTag ) {
  const result= []
  try {
    if ( !Deno.statSync(`${ base }${ path }`).isDirectory )
      return null
  } catch { return null }
  for (
    const entry of [
      ...Deno.readDirSync(`${ base }${ path }`)
    ].sort((a, b) => a.name > b.name ? 1 : -1)
  ) {
    if ( !entry.isDirectory || !NREGEX.test(entry.name) )
      continue
    else {
      const branch= entry.name
      const subpath= `${ path }/${ branch }`
      try {
        const info= YAML
          ( Deno.readTextFileSync(`${ base }${ subpath }/@.yml`)
          , { schema: JSON_SCHEMA } )
        const index= info.N ?? path.substring(path.lastIndexOf("/") + 1)
        const iri= `${ parentTag }/${
        { Project: "Prj"
        , Book: "Bbl"
        , Concept: "Ccp"
        , Arc: "Arc"
        , Volume: "Vol"
        , Version: "Vsn"
        , Side: "Sde"
        , Chapter: "Chp"
        , Draft: "Dft"
        , Section: "Sec"
        , Verse: "Vrs" }[info.KIND] || "Bra" }:${ encodeURIComponent(index) }`
        const anchor= `${ this.ID || this.DOMAIN.substring(0, this.DOMAIN.indexOf(".")) }:${ subpath }`
        result.push(`<includes>
<${ info.KIND || "Branch" } rdf:about="${ iri }">
	<owl:sameAs rdf:resource="../${ subpath }/"/>
	<owl:sameAs rdf:resource="./#${ anchor }"/>
	${ properties(info, subpath) || "" }${ info.FILE == null ? `
	${ branches.call(this, base, subpath, iri) }` : "" }
</${ info.KIND || "Branch" }>
  </includes>`)
        // generateIndex(base, subpath, anchor)
      } catch {
        result.push(`<includes>
<Branch rdf:about="../${ subpath }/">
	${ branches.call(this, base, subpath, `${ parentTag }/Bra:${ encodeURIComponent(path.substring(path.lastIndexOf("/") + 1)) }`) || "<!-- empty -->" }
</Branch>
  </includes>`)
  } } }
  try {
    for (
      const entry of [
        ...Deno.readDirSync(`${ base }${ path }/:notes`)
      ].sort((a, b) => a.name > b.name ? 1 : -1)
    ) {
      if ( !entry.isDirectory || !NREGEX.test(entry.name) )
        continue
      else {
        const note= entry.name
        const subpath= `${ path }/:notes/${ note }`
        try {
          const info= YAML
            ( Deno.readTextFileSync(`${ base }${ subpath }/@.yml`)
            , { schema: JSON_SCHEMA } )
          const iri= `${ parentTag }/Note:${ encodeURIComponent(info.ID || note) }`
          const anchor= `${ this.ID || this.DOMAIN.substring(0, this.DOMAIN.indexOf(".")) }:${ subpath }`
          result.push(`<hasNote>
<Note rdf:about="${ iri }">
	<owl:sameAs rdf:resource="../${ subpath }/"/>
	<owl:sameAs rdf:resource="./#${ anchor }"/>
	${ properties(info, subpath) || "<!-- empty -->" }
</Note>
	</hasNote>`)
          // generateIndex(base, subpath, anchor)
        } catch {
          result.push(`<hasNote>
<Note rdf:about="../${ subpath }/"/>
	</hasNote>`)
  } } } } catch { }
  return result.join(`
  `)
}

function projects ( base, parentTag ) {
  const result= []
  for (
    const entry of [
      ...Deno.readDirSync(`${ base }`)
    ].sort((a, b) => a.name > b.name ? 1 : -1)
  ) {
    if ( !entry.isDirectory || !NREGEX.test(entry.name) )
      continue
    else {
      const project= entry.name
      try {
        const info= YAML
          ( Deno.readTextFileSync(`${ base }${ project }/@.yml`)
          , { schema: JSON_SCHEMA } )
        const index= +info.N
        const iri= `${ parentTag }/Prj:${ index }`
        const anchor= `${ this.ID || this.DOMAIN.substring(0, this.DOMAIN.indexOf(".")) }:${ project }`
        if (
          info.KIND != "Project"
          || info.ID != project
          || isNaN(index)
        )
          throw new Error
        else {
          result.push(`<hasProject>
<Project rdf:about="${ iri }">
	<owl:sameAs rdf:resource="../${ project }/"/>
	<owl:sameAs rdf:resource="./#${ anchor }"/>
	${ properties(info, project) || "" }
	${ branches.call(this, base, project, iri) }
</Project>
	</hasProject>`)
          // generateIndex(base, project, anchor)
          if (info.INDEX)
            writeIndex.call(info, base, project, anchor)
      } }
      catch {
  } } }
  return result.join(`
  `)
}

function corpus ( path ) {
  try {
    const info= YAML
      ( Deno.readTextFileSync(`${ path }@.yml`)
      , { schema: JSON_SCHEMA } )
    const iri= `tag:${ info.DOMAIN },${ info.DATE }:B@N`
    const anchor= `${ info.ID || info.DOMAIN.substring(0, info.DOMAIN.indexOf(".")) }:`
    if (
      info.KIND != "Corpus"
      || typeof info.DOMAIN != "string"
      || typeof info.DATE != "string"
    )
      return null
    else
      return `<rdf:RDF
	xmlns="https://go.KIBI.family/Ontologies/BNS/#"
	xmlns:bns="https://go.KIBI.family/Ontologies/BNS/#"
	xmlns:dcmitype="http://purl.org/dc/dcmitype"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>
<owl:Ontology rdf:about="#">
	<owl:imports rdf:resource="https://go.KIBI.family/Ontologies/BNS/#"/>
</owl:Ontology>
<Corpus rdf:about="${ iri }">
	<owl:sameAs rdf:resource="../:bns"/>
	<owl:sameAs rdf:resource="./#${ anchor }"/>
	${ properties(info) || "" }
	${ info.AUTHORITY != null ? `<hasAuthority rdf:resource="${ info.AUTHORITY }"/>
	` : "" }${ info.PSEUD != null ? `<isCorpusOf>
<Pseud rdf:about="${ info.PSEUD.IRI || "./#pseud" }">
	${ properties(info.PSEUD) || "<!-- empty -->" }
	${ info.PSEUD.PSEUD_OF != null ? `<isPseudOf rdf:resource="${ info.PSEUD.PSEUD_OF }"/>` : "" }
</Pseud>
	</isCorpusOf>
	` : "" }${ projects.call(info, path, iri) || "<!-- empty -->" }
</Corpus>
</rdf:RDF>
`
  } catch {
    return null
} }

for ( const entry of Deno.readDirSync(".") ) {
  if ( !entry.isDirectory )
    continue
  else {
    const document= corpus(`./${ entry.name }/`)
    if ( document != null ) {
      console.log(`Writing corpus: ./${ entry.name }/:bns/index.rdf`)
      Deno.mkdirSync(`./${ entry.name }/:bns`, { recursive: true })
      Deno.writeTextFileSync
        ( `./${ entry.name }/:bns/index.rdf`
        , document )
} } }
