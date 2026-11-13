on switchCastmems
  repeat with i = 161 to 195
    set old to member i of castLib "gfx.Ant"
    set new to member i of castLib "paletized"
    set savedReg to the regPoint of old
    set the picture of member old to the picture of member new
    set the regPoint of old to savedReg
  end repeat
end
