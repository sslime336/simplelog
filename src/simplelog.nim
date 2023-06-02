import std / [terminal, macros]
import std / times

proc getWakeupPos(): (string, string) =
  let entries = getStackTraceEntries()
  let entry =
    if entries.len() == 0:
      (filename: currentSourcePath(), line: getStackTrace())
    else:
      ($entries[0].filename, $entries[0].line)
  result = (entry.filename, entry.line)

var timer* = proc(): string = $epochTime()

macro genLogFace(faceName: untyped, tag: string, color: ForegroundColor) = quote do:
  when not defined(release) and not defined(js):
    proc `faceName`*(msg: string) =
      let (filename, line) = getWakeupPos()
      stdout.styledWriteLine(`color`, timer() & " " & `tag` & " " & filename & ":" & line & " " & msg)
  else:
    proc `faceName`*(msg: string) =
      stdout.styledWriteLine(`color`, timer() & " " & `tag` & " " & msg)

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
