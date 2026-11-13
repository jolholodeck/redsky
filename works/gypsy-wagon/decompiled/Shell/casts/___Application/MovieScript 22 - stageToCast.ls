on STCcopyScreenRegion rL, rT, rR, rB, castMember
  put "*** CAPTURING STAGE ***"
  put "copy rect: ", rT, rL, rB, rR
  if the number of member castMember = -1 then
    put "ERR:  cast <" & castMember & "> doesnt exist!  (aborting...)"
  else
    openXLib("StageToCast XObj")
    updateStage()
    if objectp(copyObj) then
      copyObj(mdispose)
    end if
    set copyObj to StageToCast(mnew, rT, rL, rB, rR)
    put "copyObj: ", copyObj
    set the picture of member "changeCastMember" to copyObj(mGetHandle)
    if objectp(copyObj) then
      copyObj(mdispose)
    end if
    closeXLib("StageToCast XObj")
    put "stage captured to cast: " & castMember
  end if
end
