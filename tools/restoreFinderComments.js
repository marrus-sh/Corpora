#!/usr/bin/env -S deno run --allow-read --allow-write --allow-run
import
  { parse as YAML
  , JSON_SCHEMA }
from "https://deno.land/std@0.194.0/yaml/mod.ts"
import format from "./format.js"

/**
 *  Not found.
 */
const { NotFound }= Deno.errors

/**
 *  The “path” argument passed to this script.
 */
const [ pathArg ]= Deno.args

/**
 *  The actual base path used.
 *
 *  This is the same as `pathArg` but never has a trailing slash.
 */
const path= pathArg.endsWith("/") ? pathArg.substring
  ( 0, pathArg.length - 1 )
  : pathArg

/**
 *  Sets the Finder comment for the directory at the provided path.
 */
const setCommentForDirectory= async ( path ) => {
  const info= YAML
    ( await Deno.readTextFile(`${ path }/@.yml`)
    , { schema: JSON_SCHEMA } )
  const { ID, KIND, N, SHORTTITLE, TITLE }= info;
  const result= (( ) => {
    let result= KIND ?? "Branch"
    if ( KIND != "Note" && KIND != "Corpus" ) {
      const n= N ?? path.substring(path.lastIndexOf("/") + 1)
      result+= ` ${ format(n, KIND) }`
    }
    if ( KIND == "Corpus" )
      result+= ` ${info.DOMAIN} (${info.DATE})`
    else {
      if ( ID != null )
        result+= ` ${ID}`
      if ( (SHORTTITLE ?? TITLE) != null )
        result+= ` | ${
          SHORTTITLE?.TEXT ?? SHORTTITLE ?? TITLE?.TEXT ?? TITLE
        }`
    }
    return result
  })()
  const { code, stderr }= await new Deno.Command
    ( "osascript"
    , { args:
        [ "-e"
        , `set dir to POSIX file "${ await Deno.realPath(path) }"
set dir to dir as alias
tell application "Finder" to set comment of dir to "${ result }"` ] } )
    .output()
  if ( code !== 0 ) {
    console.error((new TextDecoder).decode(stderr));
    throw new Error
      ( `Script execution returned nonzero exit code: ${ code }.` )
  }
  else
    console.log(result)
  for (
    const { name, isDirectory }
    of (await Array.fromAsync(Deno.readDir(path)))
      .sort(( a, b ) => a.name > b.name ? 1 : -1)
  ) {
    if ( isDirectory ) {
      try {
        if ( !(await Deno.stat(`${ path }/${ name }/@.yml`)).isFile )
          throw null
        }
      catch ( error ) {
        if ( error == null || error instanceof NotFound )
          continue
        else
          throw new Error ("", { cause: error })
      }
      await setCommentForDirectory(`${ path }/${ name }`)
  } }
  try {
    if ( !(await Deno.statSync(`${ path }/:notes`)).isDirectory )
      throw null
    }
  catch ( error ) {
    if ( error == null || error instanceof NotFound )
      return
    else
      throw new Error ("", { cause: error })
  }
  for (
    const { name, isDirectory }
    of (await Array.from(Deno.readDir(`${ path }/:notes`)))
      .sort(( a, b ) => a.name > b.name ? 1 : -1)
  ) {
    if ( isDirectory ) {
      try {
        if (
          !(await Deno.stat(`${ path }/:notes/${ name }/@.yml`)).isFile )
          throw null
      }
      catch ( error ) {
        if ( error == null || error instanceof NotFound )
          continue
        else
          throw new Error ("", { cause: error })
      }
      await setCommentForDirectory(`${ path }/:notes/${ name }`)
} } }

await setCommentForDirectory(path)
