global gBottleList, gNumberOfBottles, gMyCurrent

on startMovie
  set gNumberOfBottles to 3
  set gBottleList to list()
  set gMyCurrent to 0
  placeBottles()
  puppetSound(1, 25)
  preloadNetThing("coldcut06.dcr")
end

on placeBottles
  repeat with x = 1 to 72
    set myColor to random(4)
    append(gBottleList, myColor)
  end repeat
  repeat with x = 1 to gNumberOfBottles
    set newBottle to random(64)
    setAt(gBottleList, newBottle, 5)
  end repeat
end

on exitFrame
  checkMouse()
  moveHighlight()
end

on mouseUp
  checkClick()
end

on moveHighlight
  set the width of sprite 117 to the width of sprite 117 + 4
  if the width of sprite 117 > 68 then
    set the width of sprite 117 to 4
  end if
end

on checkMouse
  set myVert to 0
  repeat with x = 3 to 10
    if rollOver(x) then
      set myVert to x - 2
      exit repeat
    end if
  end repeat
  if myVert then
    set myHor to 0
    repeat with x = 11 to 19
      if rollOver(x) then
        set myHor to x - 10
        exit repeat
      end if
    end repeat
  end if
  if myVert and myHor then
    set mySprite to myHor + (myVert * 9) - 9 + 19
    if (mySprite <> gMyCurrent) and (the castNum of sprite mySprite > 45) then
      set the castNum of sprite mySprite to 46
      updateStage()
      set the castNum of sprite mySprite to 49 + getAt(gBottleList, mySprite - 19)
      puppetSound(1, 25)
      set gMyCurrent to mySprite
    end if
  else
    set gMyCurrent to 0
  end if
end

on checkClick
  set myVert to 0
  repeat with x = 3 to 10
    if rollOver(x) then
      set myVert to x - 2
      exit repeat
    end if
  end repeat
  if myVert then
    set myHor to 0
    repeat with x = 11 to 19
      if rollOver(x) then
        set myHor to x - 10
        exit repeat
      end if
    end repeat
  end if
  if myVert and myHor then
    set mySprite to myHor + (myVert * 9) - 9 + 19
    set myCast to 40 + getAt(gBottleList, mySprite - 19)
    if the castNum of sprite mySprite < 46 then
      set myCast to 46
    end if
    set the castNum of sprite mySprite to myCast
    puppetSound(1, 26)
    set gMyCurrent to mySprite
  else
    set gMyCurrent to 0
  end if
end
