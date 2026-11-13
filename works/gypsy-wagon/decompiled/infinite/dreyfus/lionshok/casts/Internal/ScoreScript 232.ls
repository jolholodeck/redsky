on mouseUp
  global afterClose, section
  clearShortcutHIlite()
  set afterClose to "tr open"
  go(section & " close")
end
