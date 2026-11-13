global goSysEnvirons

on startMovie
  set the keyDownScript to "FilterKeys"
  set the mouseDownScript to "FilterClicks"
end

on DoQuit
  set the keyDownScript to EMPTY
  set the mouseDownScript to EMPTY
  go("exit")
end

on FilterKeys
  case the key of
    SPACE:
      DoQuit()
  end case
end

on FilterClicks
  DoQuit()
end
