property iSpr, iFadeTime, iState, iFadeLevel, iStampNum, iLoc
global kPi, k2pi, kNbSwatches, kSwatchAngInc, kSwatchAngTol, kMinPalRadius, kMaxPalRadius, kGravity, kInertia, klPalBgdCasts, kPalSwatchBaseCast, kPalThumbBaseCast, kPalBgdSpr, kPalSwatchSpr, kPalThumbSpr, kBaseStampSpr, kNbStampSprs, kStampFadeTime, kStampFadeInc, palette, StampMap, Shaker

on new me, stampNum, loc
  set iStampNum to stampNum
  set iFadeTime to the timer + kStampFadeTime
  set iState to #onScreen
  set iFadeLevel to 100
  set iLoc to loc
  return me
end

on mTrack me, spr
  case iState of
    #onScreen:
      set the blend of sprite spr to 100
      set the memberNum of sprite spr to kPalThumbBaseCast + iStampNum
      set the loc of sprite spr to iLoc
      if the iStamping of Shaker then
        if the timer > iFadeTime then
          set iState to #fade
        end if
      end if
    #fade:
      set iFadeLevel to max(iFadeLevel - kStampFadeInc, 0)
      set the blend of sprite spr to iFadeLevel
      set the memberNum of sprite spr to kPalThumbBaseCast + iStampNum
      set the loc of sprite spr to iLoc
      if iFadeLevel <= 0 then
        set iState to #dead
        exit
      end if
    #dead:
  end case
end
