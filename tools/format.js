export default ( n , KIND ) => {
  if ( KIND == "Note" )
    return `${ n }`
  else if ( KIND == "Concept" || KIND == "Version" || KIND == "Draft" )
    return `${ n }${ "°′″"[{ Concept: 0, Version: 1, Draft: 2 }[KIND]] }`
  else if ( typeof n == "string" && +n != n )
    return /^-?(?:[1-9][0-9]{3,}|0[0-9]{3})-(?:0[1-9]|1[0-2])(?:-(?:0[1-9]|[12][0-9]|3[01]))?(?:Z|[-+](?:(?:0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$/.test(n) ? n
      : `'${ n }`
  else switch ( KIND ) {
    case "Project":
      return `${ n }`.padStart(3, "0")
    case "Book":
      return n > 0 && n <= 24 ? String.fromCharCode
        ( 0x390 + n + (n >= 18) )
        : n == 25 ? "Ϛ"
        : n == 26 ? "Ϟ"
        : n == 27 ? "Ϡ"
        : n == 28 ? "Ϸ"
        : `${ n }`
    case "Volume":
      if ( n > 0 && n <= 99 )
        return "".concat
          ( (( ) => {
              switch ( Math.floor(n / 10) ) {
                case 9:
                  return "ⅬⅩⅬ"
                case 8:
                  return "ⅬⅩⅩⅩ"
                case 7:
                  return "ⅬⅩⅩ"
                case 6:
                  return "ⅬⅩ"
                case 5:
                  return "Ⅼ"
                case 4:
                  return "ⅩⅬ"
                case 3:
                  return "ⅩⅩⅩ"
                case 2:
                  return "ⅩⅩ"
                case 1:
                  return "Ⅹ"
                default:
                  return ""
            } })()
          , (( ) => {
              switch ( n % 10 ) {
                case 9:
                  return "ⅤⅠⅤ"
                case 8:
                  return "ⅤⅠⅠⅠ"
                case 7:
                  return "ⅤⅠⅠ"
                case 6:
                  return "ⅤⅠ"
                case 5:
                  return "Ⅴ"
                case 4:
                  return "ⅠⅤ"
                case 3:
                  return "ⅠⅠⅠ"
                case 2:
                  return "ⅠⅠ"
                case 1:
                  return "Ⅰ"
                default:
                  return ""
            } })() )
      else
        return `${ n }`
    case "Arc":
      return n > 0 && n <= 24 ? String.fromCharCode
        ( 0x3B0 + n + (n >= 18) )
        : n == 25 ? "ϛ"
        : n == 26 ? "ϟ"
        : n == 27 ? "ϡ"
        : n == 28 ? "ϸ"
        : `${ n }`
    case "Side":
      return n > 0 && n <= 26 ? String.fromCharCode(0x40 + n)
        : n == 27 ? "Þ"
        : n == 28 ? "Ð"
        : n == 29 ? "Æ"
        : n == 30 ? "Œ"
        : n == 31 ? "Ŋ"
        : n == 32 ? "Ƒ"
        : `${ n }`
    case "Chapter":
      return `${ n }`.padStart(2, "0")
    case "Section":
      return n > 0 && n <= 26 ? String.fromCharCode(0x60 + n)
        : n == 27 ? "þ"
        : n == 28 ? "ð"
        : n == 29 ? "æ"
        : n == 30 ? "œ"
        : n == 31 ? "ŋ"
        : n == 32 ? "ƒ"
        : `${ n }`
    case "Verse":
      if ( n > 0 && n <= 99 )
        return "".concat
          ( (( ) => {
              switch ( Math.floor(n / 10) ) {
                case 9:
                  return "ⅬⅩⅬ"
                case 8:
                  return "ⅬⅩⅩⅩ"
                case 7:
                  return "ⅬⅩⅩ"
                case 6:
                  return "ⅬⅩ"
                case 5:
                  return "Ⅼ"
                case 4:
                  return "ⅩⅬ"
                case 3:
                  return "ⅩⅩⅩ"
                case 2:
                  return "ⅩⅩ"
                case 1:
                  return "Ⅹ"
                default:
                  return ""
            } })()
          , (( ) => {
              switch ( n % 10 ) {
                case 9:
                  return "ⅤⅠⅤ"
                case 8:
                  return "ⅤⅠⅠⅠ"
                case 7:
                  return "ⅤⅠⅠ"
                case 6:
                  return "ⅤⅠ"
                case 5:
                  return "Ⅴ"
                case 4:
                  return "ⅠⅤ"
                case 3:
                  return "ⅠⅠⅠ"
                case 2:
                  return "ⅠⅠ"
                case 1:
                  return "Ⅰ"
                default:
                  return ""
            } })() )
      else
        return `${ n }`
    default:
      return `${ n }`
} }
