#!/usr/bin/env -S deno run --allow-read --allow-write
import
  { parse as YAML
  , JSON_SCHEMA }
from "https://deno.land/std@0.126.0/encoding/yaml.ts"

/**
 *  Not found.
 */
const { NotFound }= Deno.errors

/**
 *  The default language.
 */
const DEFAULT_LANGUAGE= "en"

/**
 *  Valid characters for use as directory names.
 */
const SEGMENT= /^[A-Za-z0-9\-\._~\u{A0}-\u{D7FF}\u{F900}-\u{FDCF}\u{FDF0}-\u{FFEF}\u{10000}-\u{1FFFD}\u{20000}-\u{2FFFD}\u{30000}-\u{3FFFD}\u{40000}-\u{4FFFD}\u{50000}-\u{5FFFD}\u{60000}-\u{6FFFD}\u{70000}-\u{7FFFD}\u{80000}-\u{8FFFD}\u{90000}-\u{9FFFD}\u{A0000}-\u{AFFFD}\u{B0000}-\u{BFFFD}\u{C0000}-\u{CFFFD}\u{D0000}-\u{DFFFD}\u{E0000}-\u{EFFFD}!$&-,;=]+$/u

/**
 *  Escapes the provided `text` for use in X·M·L.
 */
const esc= text =>
  String(text).replace(/&/g, "&amp;").replace(/</g, "&lt;")

/**
 *  Generates an `index.html` file which redirects from a subdirectory
 *    to the corresponding page in the corpus.
 *
 *  This function is commented out in the below script, because server
 *    redirect rules are a better solution, but if you are hosting the
 *    corpus on e·g GitHub pages you may want to use it.
 *
 *  The script uses `.gitattributes` files to denote whether a given
 *    `index.html` file was generated (and can be automatically
 *    replaced) or is perhaps a meaningful part of content.
 */
const generateRedirect= ( base, path, anchor ) => {
  let gitattributes= null
  let hasGitAttribute= false
  try {  //  remove `index.html` if generated
    gitattributes= Deno.readTextFileSync
      ( `${ base }${ path }/.gitattributes` )
    hasGitAttribute= gitattributes
      ?.split
      ?.("\n")
      ?.includes
      ?.("/index.html linguist-generated")
    if ( hasGitAttribute )
      Deno.removeSync(`${ base }${ path }/index.html`)
  }
  catch ( error ){
    if ( !error instanceof NotFound )
      throw new Error ("", { cause: error })
  }
  try { // quit if `index.html` is not generated
    if ( Deno.statSync(`${ base }${ path }/index.html`) )
      return
  }
  catch ( error ) {
    if ( !error instanceof NotFound )
      throw new Error ("", { cause: error })
  }
  if ( !hasGitAttribute )  // add generated marker for `index.html`
    Deno.writeTextFileSync
      ( `${ base }${ path }/.gitattributes`
      , `/index.html linguist-generated
${ gitattributes ?? "" }` )
  Deno.writeTextFileSync  //  generate index.html
    ( `${ base }${ path }/index.html`
    , `<!dOcTyPe hTmL>
<HTML Lang=en>
	<TITLE>Redirect to description</TITLE>
	<LINK Rel=alternate HRef="${ new Array (path.split("/").length).fill("..").join("/") }/:bns/index.rdf" Type=application/rdf+xml>
	<META Http-Equiv=refresh Content="0; ${ new Array (path.split("/").length).fill("..").join("/") }/:bns/#${ anchor }"/>
	<P>
		<A HRef="${ new Array (path.split("/").length).fill("..").join("/") }/:bns/#${ anchor }">View this directory’s description in the B·N·S corpus.</A>
` )
}

/**
 *  Returns the appropriate datatype corresponding to an index’s
 *    syntax.
 *
 *  `xsd:NCName` is the default and is not checked for validity if the
 *    others fail.
 */
const indexDatatype= n => `http://www.w3.org/2001/XMLSchema#${
  /^-?\d+$/.test(n) ? "integer"
  : /-?\d{4,}-\d{2}-\d{2}/.test(n) ? "date"
  : /-?\d{4,}-\d{2}/.test(n) ? "gYearMonth"
  : "NCName"
}`

/**
 *  Returns an element of name `tag` with the language and text of the
 *    provided `object`.
 *
 *  The language defaults to `DEFAULT_LANGUAGE` if not supplied.
 */
const textElement= ( tag, object ) =>
  object.TEXT == null ? `<${ tag } xml:lang="en">${ esc(object ?? "") }</${ tag }>`
  : `<${ tag } xml:lang="${ object.LANG ?? "en" }">${ esc(object.TEXT) }</${ tag }>`

/**
 *  Writes an “index” file for this project.
 *
 *  Needs to be called with the project info as its `this`.
 */
function writeIndex ( base, id, anchor ) {
  const result= [ `<indexes rdf:resource="../:bns/#${ anchor }"/>` ]
  if ( this.TITLE != null )
    result.push(textElement("fullTitle", this.TITLE))
  if ( this.SHORTTITLE != null )
    result.push(textElement("shortTitle", this.SHORTTITLE))
  if ( this.COVER != null )
    result.push
      ( this.COVER.CONTENTS != null
        ? `<hasCover rdf:parseType="Resource">
	<contents rdf:parseType="Literal">${ this.COVER.CONTENTS }</contents>
</hasCover>`
      : `<hasCover>
${ document(this.COVER, id) || "<!-- empty -->" }
</hasCover>` )
  for ( const selected of [ ...this.INDEX ] ) {
    result.push(`<selects rdf:parseType="Resource">
		<branch rdf:resource="${
		  selected.BRANCH != null ?
		    /^[^/]+\x3A/.test(selected.BRANCH) ? selected.BRANCH
		    : `../${ id }/${ selected.BRANCH }`
		  : `../${ id }/${ selected }`
		}"/>
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
  try {
    if ( Deno.statSync(`${ base }${ id }/index.xhtml`) )
      ;  //  do nothing
  }
  catch ( error ) {
    if ( error instanceof NotFound )
      try {  //  ok if this doesn’t succeed
        Deno.copyFileSync
          ( "./templates/BNS-Index.xhtml"
          , `${ base }${ id }/index.xhtml` )
      }
      catch { }
    else
      throw new Error ("", { cause: error })
  }
}

/**
 *  Creates the appropriate XML for the passed document `object`.
 *
 *  `path` is used to “resolve” relative I·R·I’s.
 */
const document= ( object, path= "" ) => {
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
          result.push(`<rdf:${ _nnn } rdf:resource="${
            page.IRI != null ?
              /^[^/]+\x3A/.test(page.IRI) ? page.IRI
              : `../${ path }/${ page.IRI }`
            : `../${ path }/${ page }`
          }"/>`)
      } }
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
  } }
  else {
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
      return `<${ doctype } rdf:about="${
        object.IRI != null ?
          /^[^/]+\x3A/.test(object.IRI) ? object.IRI
          : `../${ path }/${ object.IRI }`
        : `../${ path }/${ object }`
      }">${ object.FORMAT != null ? `
	<mediaType rdf:datatype="http://www.w3.org/2001/XMLSchema#string">${ object.FORMAT }</mediaType>` : "" }
</${ doctype }>`
} }

/**
 *  Creates the appropriate XML for the passed song `object`.
 */
const song= ( object ) => {
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

/**
 *  Creates the appropriate XML for the passed mixtape `object`.
 */
const mixtape= ( object, path= "" ) => {
  if ( object == null || typeof object != "object" )
    return null
  else {
    const result= [ ]
    if ( object.TITLE != null )
      result.push(textElement("fullTitle", object.TITLE))
    if ( object.SHORTTITLE != null )
      result.push(textElement("fullTitle", object.SHORTTITLE))
    if ( object.COVER != null )
      result.push
        ( object.COVER.CONTENTS != null
          ? `<hasCover rdf:parseType="Resource">
	<contents rdf:parseType="Literal">${ object.COVER.CONTENTS }</contents>
</hasCover>`
        : `<hasCover>
${ document(object.COVER, path) || "<!-- empty -->" }
</hasCover>` )
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
${ song(track.SONG) || "<!-- empty -->" }
	</song>` : "" }
		</hasTrack>`)
        }
      else
        result.push(`<hasTrack rdf:parseType="Resource">${ object.TRACK.N != null ? `
	<index rdf:datatype="${ indexDatatype(track.N) }">${ object.N }</index>` : "" }${ object.TRACK.SONG != null ? `
	<song rdf:parseType="Resource">
${ song(object.TRACK.SONG) || "<!-- empty -->" }
	</song>` : "" }
		</hasTrack>`)
    return result.join(`
		`)
} }

/**
 *  Creates the appropriate XML for the metadata properties of the
 *    passed `object`.
 *
 *  `path` is used to “resolve” relative I·R·I’s.
 */
const properties= ( object, path= "" ) => {
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
      result.push
        ( object.COVER.CONTENTS != null
          ? `<hasCover rdf:parseType="Resource">
	<contents rdf:parseType="Literal">${ object.COVER.CONTENTS }</contents>
</hasCover>`
        : `<hasCover>
${ document(object.COVER, path) || "<!-- empty -->" }
</hasCover>` )
    if ( object.DESCRIPTION?.CONTENTS != null )
      result.push(`<hasDescription rdf:parseType="Resource">
		<contents rdf:parseType="Literal">${ object.DESCRIPTION.CONTENTS }</contents>
	</hasDescription>`)
    if ( object.FILE != null )
      if ( Array.isArray(object.FILE) )
        for ( const published of object.FILE ) {
          result.push(`<hasFile>
${ document(published, path) || "<!-- empty -->" }
	</hasFile>`)
        }
      else
        result.push(`<hasFile>
${ document(object.FILE, path) || "<!-- empty -->" }
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
		${ song(theme) ?? "" }
	</hasThemeSong>`)
        }
      else
        result.push(`<hasThemeSong rdf:parseType="Resource">
		${ song(object.THEMESONG) ?? "" }
	</hasThemeSong>`)
    if ( object.MIXTAPE != null )
      if ( Array.isArray(object.MIXTAPE) )
        for ( const tape of object.MIXTAPE ) {
          result.push(`<hasMixtape rdf:parseType="Resource">
		${ mixtape(tape, path) ?? "" }
	</hasMixtape>`)
        }
      else
        result.push(`<hasMixtape rdf:parseType="Resource">
		${ mixtape(object.MIXTAPE, path) ?? "" }
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

/**
 *  Creates the appropriate XML for the branches in `path`.
 *
 *  Needs to be called with the corpus info as its `this`.
 */
function branches ( base, path, parentTag ) {
  const result= []
  try {
    if ( !Deno.statSync(`${ base }${ path }`).isDirectory )
      return null
  }
  catch ( error ) {
    if ( error instanceof NotFound )
      return null
    else
      throw new Error ("", { cause: error })
  }
  for (
    const { isDirectory, name: branch } of Array
      .from(Deno.readDirSync(`${ base }${ path }`))
      .sort(( a, b ) => a.name > b.name ? 1 : -1)
  ) {
    if ( !isDirectory || !SEGMENT.test(branch) )
      continue
    else {
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
          , Verse: "Vrs" }[info.KIND] ?? "Bra"
        }:${ encodeURIComponent(index) }`
        const anchor= `${ this.ID || this.DOMAIN.substring(0, this.DOMAIN.indexOf(".")) }:${ subpath }`
        result.push(`<includes>
<${ info.KIND || "Branch" } rdf:about="${ iri }">
	<owl:sameAs rdf:resource="../${ subpath }/"/>
	<owl:sameAs rdf:resource="./#${ anchor }"/>
	${ properties(info, subpath) ?? "" }${ info.FILE == null ? `
	${ branches.call(this, base, subpath, iri) }` : "" }
</${ info.KIND || "Branch" }>
  </includes>`)
        //generateRedirect(base, subpath, anchor)
      }
      catch ( error ) {
        if ( error instanceof NotFound )
          result.push(`<includes>
<Branch rdf:about="../${ subpath }/">
	${ branches.call(this, base, subpath, `${ parentTag }/Bra:${ encodeURIComponent(path.substring(path.lastIndexOf("/") + 1)) }`) || "<!-- empty -->" }
</Branch>
  </includes>`)
        else
          throw new Error ("", { cause: error })
  } } }
  try {
    for (
      const { isDirectory, name: note } of Array
        .from(Deno.readDirSync(`${ base }${ path }/:notes`))
        .sort(( a, b ) => a.name > b.name ? 1 : -1)
    ) {
      if ( !isDirectory || !SEGMENT.test(note) )
        continue
      else {
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
          //generateRedirect(base, subpath, anchor)
        }
        catch ( error ) {
          if ( error instanceof NotFound )
            result.push(`<hasNote>
<Note rdf:about="../${ subpath }/"/>
	</hasNote>`)
          else
            throw new Error ("", { cause: error })
  } } } }
  catch ( error ) {
    if ( !error instanceof NotFound )
      throw new Error ("", { cause: error })
  }
  return result.join(`
  `)
}

/**
 *  Creates the appropriate XML for the projects in `base`.
 *
 *  Needs to be called with the corpus info as its `this`.
 */
function projects ( base, parentTag ) {
  const result= []
  for (
    const { isDirectory, name: project } of Array
      .from(Deno.readDirSync(base))
      .sort(( a, b ) => a.name > b.name ? 1 : -1)
  ) {
    if ( !isDirectory || !SEGMENT.test(project) )
      continue
    else {
      try {
        const info= YAML
          ( Deno.readTextFileSync(`${ base }${ project }/@.yml`)
          , { schema: JSON_SCHEMA } )
        const index= info.N >>> 0
        const iri= `${ parentTag }/Prj:${ index }`
        const anchor= `${ this.ID || this.DOMAIN.substring(0, this.DOMAIN.indexOf(".")) }:${ project }`
        if (
          info.KIND != "Project"
          || +info.N != index
        )
          throw new Error
            ( "Directory did not contain project with valid index." )
        else {
          result.push(`<hasProject>
<Project rdf:about="${ iri }">
	<owl:sameAs rdf:resource="../${ project }/"/>
	<owl:sameAs rdf:resource="./#${ anchor }"/>
	${ properties(info, project) || "" }
	${ branches.call(this, base, project, iri) }
</Project>
	</hasProject>`)
          if (info.INDEX)
            writeIndex.call(info, base, project, anchor)
          //else
          //  generateRedirect(base, project, anchor)
      } }
      catch ( error ) {
        if ( !error instanceof NotFound )
          throw new Error ("", { cause: error })
  } } }
  return result.join(`
  `)
}

/**
 *  Creates the appropriate XML for the corpus in `path`.
 */
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
	${ properties(info.PSEUD) || "" }
	${ info.PSEUD.PSEUD_OF != null ? `<isPseudOf rdf:resource="${ info.PSEUD.PSEUD_OF }"/>` : "" }
</Pseud>
	</isCorpusOf>
	` : "" }${ projects.call(info, path, iri) || "<!-- empty -->" }
</Corpus>
</rdf:RDF>
`
  }
  catch ( error ) {
    if ( !error instanceof NotFound )
      throw new Error ("", { cause: error })
} }

for ( const { isDirectory, name } of Deno.readDirSync(".") ) {
  if ( !isDirectory )
    continue
  else {
    const document= corpus(`./${ name }/`)
    if ( document != null ) {
      console.log(`Writing corpus: ./${ name }/:bns/index.rdf`)
      Deno.mkdirSync(`./${ name }/:bns`, { recursive: true })
      Deno.writeTextFileSync
        ( `./${ name }/:bns/index.rdf`
        , document )
      try {
        if ( Deno.statSync(`./${ name }/:shared`) )
          ;  //  do nothing
      }
      catch ( error ) {
        if ( error instanceof NotFound )
          Deno.symlinkSync("../shared", `./${ name }/:shared`)
        else
          throw new Error ("", { cause: error })
      }
      try {
        if ( Deno.statSync(`./${ name }/:bns/index.xhtml`) )
          ;  //  do nothing
      }
      catch ( error ) {
        if ( error instanceof NotFound )
          try {  //  ok if this doesn’t succeed
            Deno.copyFileSync
              ( "./templates/BNS-Corpus.xhtml"
              , `./${ name }/:bns/index.xhtml` )
          }
          catch { }
        else
          throw new Error ("", { cause: error })
} } } }
