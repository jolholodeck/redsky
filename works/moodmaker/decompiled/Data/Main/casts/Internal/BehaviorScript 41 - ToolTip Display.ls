property spriteNum, mySprite, myDefaultMember, mBlnLockDisplay

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
  mySprite.member = mbr
  stopEvent()
end

on mRestore me
  mySprite.member = myDefaultMember
  stopEvent()
end

on mSetDefault me, mbr
  myDefaultMember = mbr
  me.mRestore()
end
