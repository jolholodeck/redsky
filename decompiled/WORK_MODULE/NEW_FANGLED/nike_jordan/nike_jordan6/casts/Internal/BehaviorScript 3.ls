on mouseDown
  global gCurrCircle, gCoverUpSpr, gFilmSpr, gDotSpr, myDist, gMandalaSpr
  if myDist < 47 then
    exit
  else
    setCurrCircle()
    puppetSprite(gFilmSpr, 1)
    puppetSprite(gMandalaSpr, 1)
    puppetSprite(gCoverUpSpr, 1)
    set myMember to gCurrCircle & ".1"
    set the memberNum of sprite gFilmSpr to the number of member myMember
    set the memberNum of sprite gCoverUpSpr to the number of member "mandala.overlay"
    set the visible of sprite gCoverUpSpr to 1
    set the memberNum of sprite gMandalaSpr to the number of member "mandala4"
    set the visible of sprite gDotSpr to 1
    set myMarker to "Circle" & gCurrCircle & "Play"
    go(myMarker)
  end if
end
