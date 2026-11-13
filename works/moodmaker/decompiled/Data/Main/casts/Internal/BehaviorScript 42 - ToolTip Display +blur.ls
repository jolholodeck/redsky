property spriteNum, mySprite, myDefaultMember, myDefaultBlurMember, mBlnLockDisplay

on beginSprite me
  mySprite = sprite(me.spriteNum)
  myDefaultMember = mySprite.member
  mBlnLockDisplay = 0
end

on mDisplay me, mbr, blnLock
  if mBlnLockDisplay then
    mBlnLockDisplay = 0
    exit
  end if
  if voidp(blnLock) then
    blnLock = 0
  end if
  if blnLock then
    mBlnLockDisplay = 1
  end if
  if mySprite.member = mbr then
    exit
  end if
  mySprite.member = mbr
  stopEvent()
end

on mRestore me
  if mySprite.member = myDefaultMember then
    exit
  end if
  mySprite.member = myDefaultMember
  stopEvent()
end

on mSetDefault me, mbr
  myDefaultMember = mbr
  myDefaultBlurMember = member(myDefaultMember.memberNum + 1, myDefaultMember.castLibNum)
  me.mRestore()
end

on mWait me, theDelay
  t = the milliSeconds
  repeat while the milliSeconds < (t + theDelay)
  end repeat
end
