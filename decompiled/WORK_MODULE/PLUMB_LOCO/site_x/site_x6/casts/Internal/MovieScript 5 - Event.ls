global palette, StampMap, Shaker, kStageRect, gIdleSuspended

on idle
  if gIdleSuspended then
    exit
  end if
  set mPt to point(mouseH(), mouseV())
  mTrack(Shaker, mPt)
  if the iStamping of Shaker then
    mTrack(palette, mPt, 1)
    mTrack(StampMap)
    if the mouseDown then
      if inside(mPt, kStageRect) then
        repeat while the mouseDown
          set trackPt to point(mouseH(), mouseV())
          mTrack(palette, trackPt, 0)
          updateStage()
        end repeat
        mAddStamp(StampMap, the iCurSwatch of palette, the iCurLoc of palette)
      end if
    end if
  else
    mTrack(Browser)
  end if
  updateStage()
end
