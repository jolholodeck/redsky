on mouseUp
  global afterClose, section
  clearShortcutHIlite()
  set afterClose to "kn open"
  go(section & " close")
end
