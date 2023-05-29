import std / [strformat, terminal]
import std / macros

{.hint[XDeclaredButNotUsed]: off.}

proc getWakeupPos(): (string, string) =
  let entry = getStackTraceEntries()[0]
  result = ($entry.filename, $entry.line)

macro genLogFace(faceName: untyped, tag: string, color: ForegroundColor) = quote do:
  proc `faceName`*(msg: string) =
    let (filename, line) = getWakeupPos()
    stdout.styledWriteLine(`color`, `tag` & " " & filename & ":" & line & " " & msg)

genLogFace(trace, "[TRACE]", fgWhite)
genLogFace(info,  "[ INFO]", fgBlue)
genLogFace(debug, "[DEBUG]", fgGreen)
genLogFace(warn,  "[ WARN]", fgYellow)
genLogFace(error, "[ERROR]", fgRed)

when isMainModule:
  trace "here is a trace message"
  info "here is a info message"
  debug "here is a debug message"
  warn "here is a warn message"
  error "here is an error message"
