on mouseUp
  global afterClose, section
  set afterClose to "main"
  puppetSound(2, the number of member "close")
  go(section & " close")
end
