#  Branching Notational System Corpora  #

This repository contains a number of resources which together provide a
  mechanism for generating and distributing corpora of works which have
  been organized according to the Branching Notational System (B·N·S).
The basic mechanism is as follows :—

01. A corpus authority organizes resources into a branching directory
      system in a subfolder of this repository which reflects their
      representation in the B·N·S model.
    Notes must be placed in a `:notes` directory inside the directory
      for the branch they annotate.
    Otherwise, directory naming is pretty flexible (shorter is better).

    > Here <dfn>corpus authority</dfn> means “the person in charge of
        maintaining the corpus”, as distinct from the person the corpus
        is actually *about*.
    > A <dfn>corpus</dfn> is simply a collection of works and their
        underlying metadata.

02. Additionally, the corpus authority supplies metadata in each
      directory via a special `@.yml` file.
    The recognized contents of this file are described below.

03. The `tools/build.js` script is run, generating an R·D·F∕X·M·L file
      in the `:bns` directory for each corpus which describes its
      formal B·N·S metadata.
    Optionally, files for project indices may be generated as well.
    (This script requires [Deno](https://deno.land).)

04. The build script will automatically copy in index files for corpora
      and projects if none are present.
    However, these can be edited to adjust styling, ⁊·c.

The resulting corpora directories form a static site which can be
  served trivially.
The only requirement (unfortunately not the case in every environment,
  for example `python3 -m http.server`) is that servers can serve an
  `index.xhtml` file (not simply the more conventional `index.html`)
  when a user navigates to a directory, and that they do so with an
  X·M·L media type (ideally `application/xhtml+xml`).
More complex redirect rules may be considered desireable, but are by no
  means necessary.

For an example of this in practice, see the `~example` directory, which
  can be viewed online at
  <https://marrus-sh.github.io/Corpora/~example/>.

##  Metadata Model  ##

> **Note:**
> The following does *not* provide a comprehensive, accurate, complete,
>   or normative account of the B·N·S Ontology or its vocabulary terms.
> Persons interested in such an technical∣theoretical account should
>   consult the actual ontology definition.

###  `@.yml` Metadata  ###

Rather than defining verbose metadata files for resources, the build
  script makes use of minimal `@.yml` files in each directory to
  construct its metadata.
The following table gives a rough overview of what metadata you can
  define for which types of resource.
A **☑** means a metadata term is **recommended**; you may get strange
  behaviour if it is improperly defined.
A **☒** means a metadata term is **not recommended**; if you define
  it, it will likely get ignored.
A **☐** means that a metadata term is **optional**.

> **Note:**
> These are not formal requirements (but you should follow them).

|  Property   | Corpora? | Project? | Branch? | Note? |
| :---------: | :------: | :------: | :-----: | :---: |
|    KIND     | ☑ | ☑ | ☑ | ☑ |
|   DOMAIN    | ☑ | ☒ | ☒ | ☒ |
|    DATE     | ☑ | ☒ | ☒ | ☒ |
|      N      | ☒ | ☑ | ☑ | ☒ |
|     ID      | ☑ | ☑ | ☐ | ☑ |
|  AUTHORITY  | ☑ | ☒ | ☒ | ☒ |
|    PSEUD    | ☑ | ☒ | ☒ | ☒ |
|    TITLE    | ☑ | ☑ | ☐ | ☐ |
| SHORTTITLE  | ☐ | ☐ | ☐ | ☐ |
|    COVER    | ☐ | ☐ | ☐ | ☒ |
|  THEMESONG  | ☒ | ☐ | ☐ | ☒ |
| DESCRIPTION | ☐ | ☐ | ☐ | ☒ |
|   MIXTAPE   | ☒ | ☐ | ☐ | ☒ |
|   FANDOM    | ☒ | ☐ | ☐ | ☒ |
| INSPIRATION | ☒ | ☐ | ☐ | ☒ |
|  AVAILABLE  | ☒ | ☐ | ☐ | ☒ |
|    FILE     | ☒ | ☒ | ☐ | ☑ |
|    INDEX    | ☒ | ☑ | ☒ | ☒ |

> **Note:**
> `FILE` should (only) be included on “leaf” branches (ones with no
>   further branching).

The meaning of each of these properties is described below.

####  `KIND`  ####

The class of resource, as described above.
Valid values include `"Corpus"`, `"Project"`, `"Book"`, `"Concept"`,
  `"Volume"`, `"Arc"`, `"Version"`, `"Side"`, `"Chapter"`, `"Draft"`,
  `"Section"`, `"Verse"`, and `"Note"`.

####  `DOMAIN`  ####

A domain name which the corpus *authority* (not the person the corpus
  is about, unless they are the same person) definitely controlled.
You can also use an email address here, although I don’t recommend it.
The value you give here will *not* ever be resolved; it is simply a way
  of uniquely identifying the person who made the corpus in a way which
  is globally‐unique.

If you can, it is best if you use a domain unique to this corpus, and
  ideally the one you will be hosting it on.

####  `DATE`  ####

A date in which the corpus authority definitely controlled the domain
  above, and “after” which no backwards‐incompatible changes were made.
This is to say, if you shuffle around the numbering of a corpus, so
  that what *used* to be Project 001 is now Project 005, you need to
  update the date.

“After” is in quotes because all that actually matters is that the
  dates are different.
**Two corpora with identical domains and dates must not contradict each
  other.**
This is easy to ensure if you only use domains you control and use
  dates corresponding to actual changes.

In general, you **should not** introduce backwards‐incompatible changes
  into corpora you control, and should strive to keep the domain and
  date the same.

> **Note:**
> The format for dates is the usual ISO `YYYY-MM-DD`.
> The month and day are optional, so `YYYY-MM` and `YYYY` are also
>   allowed.

####  `N`  ####

The index, or “number”, of the project or branch.

If an integer, this indicates an *ordered* branch.
Projects **must** have nonnegative integer indices.

Branches can also have two other kind of branch indices.
A date of the format `YYYY-MM` or `YYYY-MM-DD` indicates a *dated*
  branch.
(You can’t use a date of a year only, because it is indistinguishable
  from an integer.)
And an X·M·L NCName indicates an *unordered* branch.
You can test if something is a valid NCName with the
  [NCName Validator app](https://go.kibi.family/Apps/NCName).

> **Note:**
> Older applications may have more restrictive definitions of what
>   constitutes an X·M·L NCName, but it shouldn’t impact the rendering
>   or display of corpora.

There is a special convention for NCName’s:
If an NCName begins with an underscore followed by an integer or date
  and finishes with another NCName, it is considered a *variant* of the
  branch with the corresponding integer or date.
This primarily comes into play with revisions (concepts, versions,
  drafts).
For example, a draft with `N: _3a` may be thought of as the `a` variant
  of the draft with `N: 3`.
(`a` in this case might be a shorthand for “annotated”.)

Integer indices are often rendered with a special format, depending on
  the kind of branch :—

| Branch Kind | Format |
| :---------: | :----: |
| Project | Three‐digit number (`004`) |
| Book | Uppercase greek letter (`Δ`) |
| Volume | Uppercase roman numeral (`ⅠⅤ`) |
| Arc | Lowercase greek letter (`δ`) |
| Side | Uppercase latin letter (`D`) |
| Chapter | Two‐digit number (`04`) |
| Section | Lowercase latin letter (`d`) |
| Verse | Lowercase roman numeral (`ⅰⅴ`) |

In instances where this formatting is applied, NCName indices are
  prefixed with a single straight apostrophe (`'`) to make them
  distinct.
Concepts, versions, and drafts not specially formatted, and are instead
  suffixed with a degree (`°`), prime (`′`), and double·prime (`″`),
  respectively.

> **Note:**
> Do not apply formatting to indices when you input them into your
>   `@.yml` file; just input the integer or NCName directly.

####  `ID`  ####

An identifier, or “codename”.
Identifiers **must** be valid NCNames.
You can test if something is a valid NCName with the
  [NCName Validator app](https://go.kibi.family/Apps/NCName).

> **Note:**
> Older applications may have more restrictive definitions of what
>   constitutes an X·M·L NCName, but it shouldn’t impact the rendering
>   or display of corpora.

Identifiers are optional for branches, which are instead identified by
  index.
If supplied, they **should not** change.

It is **recommended**, but **not required**, that corpus and note
  identifiers only use characters which are acceptable in U·R·I’s.

####  `AUTHORITY`  ####

An I·R·I identifying the authority responsible for the corpus.
This is totally optional.

####  `PSEUD`  ####

An object which identifies the pseud that the corpus describes.

The term “pseud” derives from “pseudonym” and is meant to emphasize the
  fact that corpora do not describe “people” proper, but rather
  abstract people‐as‐authors, i·e acting in a particular authorship
  capacity.
One person may have multiple pseuds, and one pseud may belong to
  multiple people.
However, each corpus can describe only one pseud.

The pseud object **should** have the following structure :—

```yml
PSEUD:
  IRI: https://example.com/link/to/my/pseud
  PSEUD_OF: https://example.com/link/to/me  #  optional
  TITLE:
    TEXT: My Pseud
    LANG: en
```

####  `TITLE`  ####

The full name or title of some thing, represented as an object with two
  properties.
`TEXT` gives the title text, and `LANG` gives the language.

####  `SHORTTITLE`  ####

A shortened or abbreviated title for some thing, as an object of the
  same form as `TITLE`.

####  `COVER`  ####

A cover image or similar media.
A typical example follows :—

```yml
COVER:
  IRI: cover.png
  KIND: Image
  FORMAT: image/png
```

####  `THEMESONG`  ####

A themesong associated with the resource (for example, the song of a
  songfic).
This should be an object with an X·M·L `CITATION`, providing a
  bibliographic citation for the song.
An `AVAILABLE` property may also be provided, as specified below.

You can specify multiple themesongs by using an array of objects.

####  `DESCRIPTION`  ####

A description for the resource, as an object with a single property,
  `CONTENTS`.
The value of `CONTENTS` will be interpreted as X·M·L.
The following template is **recommended** :—

```yml
DESCRIPTION:
  CONTENTS: |-
    <div xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
    	<p>A description of the resource.</p>
    </div>
```

####  `MIXTAPE`  ####

An ordered list of associated songs.
Mixtapes can have a `TITLE` and `COVER`, as described above.
They can also have an `AVAILABLE`, as specified below.

The `TRACK` property has the same format as `THEMESONG` (there will
  typically be multiple tracks).
Tracks should also typically be numbered using the `N` property.
If `N` is not specified on tracks, the mixtape is considered unordered.

You can specify multiple mixtapes by using an array of objects.

####  `FANDOM`  ####

A list of I·R·I’s, each of which points to a resource describing a work
  which this resource is a fanwork of.
These I·R·I’s *should* be Linked Data ‐ aware.
One good source of I·R·I’s is [Wikidata](https://www.wikidata.org/),
  where the appropriate value can be accessed by right‐clicking on
  “Wikidata item” in the sidebar and copying the link.

####  `INSPIRATION`  ####

A less‐strong form of `FANDOM`, with identical format.

####  `AVAILABLE`  ####

A website where the given resource is available.
This will be an object with two properties :— `URL`, giving the U·R·L
  of the site, and `SITELABEL`, providing a label.

Generally, bestpractice is to *not* specify this on drafts, even if the
  draft is made available somewhere, but rather to specify it “one
  level up”—typically publishing sites are not strictly versioned, and
  which exact draft they host could change at a later time.

If a resource is available in multiple places, you can specify them
  with an array of objects.

####  `FILE`  ####

A file associated with a resource.
Typically, drafts, sections, verses, or notes will have files.
Having a file may suppress the display of other metadata, like
  descriptions.

Files **should** have a `KIND` of either `"Audio"`, `"Image"`,
  `"Text"`, or `"Video"`.
(Interactive files like games are not yet supported.)
For single files, this should be coupled with an `IRI`, giving the path
  to the file, and a `FORMAT`, giving the media type.

Multiple files are also supported, and have a `KIND` of either
  `"Sequence"` or `"Set"` *in addition to* the kind from the list above
  (as an array).
The `FORMAT` still specifies the format (which **must** be the same for
  all files), but `IRI`s are specified on objects on `_NN` properties,
  where `NN` is a positive integer with no leading zeros.
This sounds confusing, so here is an example :—

```yml
FILE:
- IRI: text.html
  KIND: Text
  FORMAT: text/html
- KIND: [ Text, Sequence ]
  FORMAT: image/png
  _1: { IRI: page101.png }
  _2: { IRI: page102.png }
  _3: { IRI: page103.png }
  _4: { IRI: page104.png }
- IRI: text.rtf
  KIND: Text
  FORMAT: application/rtf
```

As shown above, you can specify multiple files by using an array of
  objects.

####  `INDEX`  ####

(Not to be confused with `N`, above.)

The `INDEX` property signals to the build script to generate an index
  file (`index.rdf`) in the project directory.
Its value **should** be a (non·exhaustive) array of objects whose
  `BRANCH` property gives the canonical Tag U·R·I for a branches with
  files within the project.

The canonical Tag U·R·I is automatically determined by the build script
  from the types and indices of its ancestor project and branches.
It is displayed in the lower‐right of the full corpus viewer, and can
  be copied from there.
