on mouseDown
  global gDotSpr, gMandalaSpr, gRadius, gLevel, gCoverUpSpr, gCurrCircle, gFilmSpr, myDist
  if myDist < 47 then
    exit
  else
    setCurrCircle()
    put "gCurrCircle" && gCurrCircle
    puppetSprite(gFilmSpr, 1)
    set myMember to gCurrCircle & ".1"
    set the memberNum of sprite gFilmSpr to the number of member myMember
    set the visible of sprite gDotSpr to 1
    puppetSprite(gMandalaSpr, 1)
    set the blend of sprite gMandalaSpr to 100
    set the blend of sprite gCoverUpSpr to 100
    puppetSprite(gCoverUpSpr, 1)
    set the visible of sprite gCoverUpSpr to 1
    set the memberNum of sprite gMandalaSpr to the number of member "mandala4"
    put "Mandala spr member #=" && myMember
    set the volume of sound 1 to 255
    set the volume of sound 2 to 255
    set myMarker to "Circle" & gCurrCircle & "Play"
    go(myMarker)
    put "clickOut script: going to marker" && myMarker
  end if
end
