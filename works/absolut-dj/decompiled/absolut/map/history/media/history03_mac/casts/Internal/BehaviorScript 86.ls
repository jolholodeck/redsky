on mouseUp
  global gCurrentYear, gMyYear
  if rollOver(20) then
    nothing()
  else
    set gMyYear to 0
    set gCurrentYear to 0
    case the currentSpriteNum of
      82:
        go("0")
      83:
        go("1")
      84:
        go("2")
      85:
        go("3")
      86:
        go("4")
      87:
        go("5")
      88:
        go("6")
      89:
        go("7")
      90:
        go("8")
      91:
        go("9")
      92:
        go("10")
      93:
        go("11")
    end case
  end if
end
