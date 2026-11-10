property iAscore, iUscore, iAgames, iUgames, iAsets, iUsets, iNbSets, iScoreStrings, iAscoreFld, iUscoreFld, iAsetFld, iUsetFld, iScoreStartCast
global static, gScoreSpr, gBgdOffH, gBgdOffV, gBgdOffPt

on new me
  set iScoreStrings to ["15", "30", "40"]
  set iScoreStartCast to 91
  set iNbSets to 1
  set iAscore to 0
  set iUscore to 0
  set iAgames to 0
  set iUgames to 0
  set iAsets to 0
  set iUsets to 0
  set iAscoreFld to 271
  set iUscoreFld to 272
  set iAsetFld to 281
  set iUsetFld to 291
  set the text of field iAscoreFld to "0"
  set the text of field iUscoreFld to "0"
  repeat with fld = iAsetFld to iAsetFld + 4
    set the text of field fld to " "
  end repeat
  repeat with fld = iUsetFld to iUsetFld + 4
    set the text of field fld to " "
  end repeat
  return me
end

on mScore me, player, nbPoints
  if player = #Andre then
    set iAscore to iAscore + nbPoints
    if iAscore <= 3 then
      set the text of field iAscoreFld to getAt(iScoreStrings, iAscore)
      return #inProgress
    end if
    if iAscore = iUscore then
      set the text of field iAscoreFld to "40"
      set the text of field iUscoreFld to "40"
      return #equal
    end if
    if iAscore = (iUscore + 1) then
      set the text of field iAscoreFld to "40A"
      set the text of field iUscoreFld to "40"
      return #adv
    end if
    if iAscore > (iUscore + 3) then
      mTrigger(Face, #laugh)
      mTriggerStatic(static)
    end if
    set the text of field iAscoreFld to "0"
    set the text of field iUscoreFld to "0"
    set iAscore to 0
    set iUscore to 0
    set iAgames to iAgames + 1
    mHilite(me, 0)
    set the text of field (iAsetFld + iNbSets - 1) to string(iAgames)
    set the text of field (iUsetFld + iNbSets - 1) to string(iUgames)
    if iAgames <= 5 then
      return #game
    end if
    if iAgames <= (iUgames + 1) then
      return #game
    end if
    mTrigger(Face, #laugh)
    mTriggerStatic(static)
    set iAgames to 0
    set iUgames to 0
    set iAsets to iAsets + 1
    if iNbSets < 3 then
      set iNbSets to iNbSets + 1
      if iNbSets = 3 then
        set the iStaticFreq of static to 300
      end if
      return #set
    end if
    mTriggerStatic(static)
    if iNbSets >= 5 then
      return #match
    end if
    if iAsets <= (iUsets + 1) then
      set iNbSets to iNbSets + 1
      return #set
    end if
    return #match
  else
    set iUscore to iUscore + nbPoints
    if iUscore <= 3 then
      set the text of field iUscoreFld to getAt(iScoreStrings, iUscore)
      mHilite(me, iUscore)
      return #inProgress
    end if
    if iAscore = iUscore then
      set the text of field iAscoreFld to "40"
      set the text of field iUscoreFld to "40"
      mHilite(me, 3)
      return #equal
    end if
    if iUscore = (iAscore + 1) then
      set the text of field iUscoreFld to "40A"
      set the text of field iAscoreFld to "40"
      mHilite(me, 3)
      mTrigger(Face, #frown)
      return #adv
    end if
    set the text of field iAscoreFld to "0"
    set the text of field iUscoreFld to "0"
    mHilite(me, 4, 1)
    doPause(2)
    mHilite(me, 3, 1)
    doPause(2)
    mHilite(me, 2, 1)
    doPause(2)
    mHilite(me, 1, 1)
    doPause(2)
    mHilite(me, 0, 1)
    mTrigger(Face, #frown)
    set iAscore to 0
    set iUscore to 0
    set iUgames to iUgames + 1
    set the text of field (iAsetFld + iNbSets - 1) to string(iAgames)
    set the text of field (iUsetFld + iNbSets - 1) to string(iUgames)
    if iUgames <= 5 then
      return #game
    end if
    if iUgames <= (iAgames + 1) then
      return #game
    end if
    set iAgames to 0
    set iUgames to 0
    set iUsets to iUsets + 1
    if iNbSets < 3 then
      set iNbSets to iNbSets + 1
      return #set
    end if
    if iNbSets >= 5 then
      return #match
    end if
    if iUsets <= (iAsets + 1) then
      set iNbSets to iNbSets + 1
      return #set
    end if
    return #match
  end if
end

on mHilite me, whatScore, forceUpdate
  if whatScore <= 0 then
    set the locH of sprite gScoreSpr to -1000
    if forceUpdate then
      updateStage()
    end if
    exit
  end if
  if whatScore > 4 then
    set whatScore to 4
  end if
  set the castNum of sprite gScoreSpr to iScoreStartCast + whatScore - 1
  set the loc of sprite gScoreSpr to gBgdOffPt
  if forceUpdate then
    updateStage()
  end if
end
