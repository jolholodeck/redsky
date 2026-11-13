global gdmoQuillSndChan, gdmoQuillAltSndChan, gdmoTheAnt, gdmoLeftArrowOnscreen, gdmoRghtArrowOnscreen, gdmoMenuTitleSprite, gdmoLeftArrowSprite, gdmoRghtArrowSprite

on quillQueueMenu this, menu
  set the menuQueue of this to menu
  quillEraseCurrentMenu(this)
end

on quillEmptyWritingQueues this
  set the scheduleQueue of this to []
  set the renderQueue of this to []
end

on quillEmptyErasingQueues this
  set the eraserQueue of this to []
end

on quillHideQuillSprites this
  set sptChan to the quillSprite of this
  repeat with chn = sptChan to sptChan + 4
    set the loc of sprite chn to point(-1000, 300)
  end repeat
end

on quillEraseCurrentMenu this
  global gdmoPrestoSplash, gdmoPrestoSplashPuppeted
  if the quillMode of this = #erasing then
    exit
  end if
  quillEmptyWritingQueues(this)
  quillHideQuillSprites(this)
  if gdmoPrestoSplashPuppeted then
    set the loc of sprite gdmoPrestoSplash to point(-1000, 300)
    puppetSprite(gdmoPrestoSplash, 0)
    quillQueueRasterValErase(this, #paperEdge)
  else
    quillQueueRasterValErase(this, #text1)
    quillQueueRasterValErase(this, #text2)
    if gdmoLeftArrowOnscreen then
      puppetSprite(gdmoLeftArrowSprite, 1)
      set the loc of sprite gdmoLeftArrowSprite to point(205, 369)
      set the member of sprite gdmoLeftArrowSprite to member "left.arrow.laydown"
      quillQueueRasterValErase(this, #leftArrow)
    end if
    if gdmoRghtArrowOnscreen then
      puppetSprite(gdmoRghtArrowSprite, 1)
      set the loc of sprite gdmoRghtArrowSprite to point(431, 385)
      set the member of sprite gdmoRghtArrowSprite to member "right.arrow.laydown"
      quillQueueRasterValErase(this, #rghtArrow)
    end if
  end if
  set the quillMode of this to #erasing
end

on quillScheduleText this, launchTime, gTextObj
  set c to count(the scheduleQueue of this)
  repeat with i = 1 to c
    set t to getAt(getAt(the scheduleQueue of this, i), 1)
    if t > launchTime then
      exit repeat
    end if
  end repeat
  addAt(the scheduleQueue of this, i, list(launchTime, gTextObj))
  set the nextSchedEvent of this to getAt(getAt(the scheduleQueue of this, 1), 1)
end

on quillQueueRasterValErase this, eraseVal
  append(the eraserQueue of this, eraseVal)
end

on quillEraseRegionInit this, regionToErase
  set upLeftX to getAt(regionToErase, 1)
  set upLeftY to getAt(regionToErase, 2)
  set the eraserX of this to upLeftX
  set the eraserY of this to upLeftY
  set the eWalkX1 of this to upLeftX + the eraserStep of this
  set the eWalkY1 of this to upLeftY
  set the eWalkX2 of this to upLeftX
  set the eWalkY2 of this to upLeftY + the eraserStep of this
  set the eMaxX of this to getAt(regionToErase, 3)
  set the eMaxY of this to getAt(regionToErase, 4)
  set the eraserDir of this to 0
  set sptChan to the quillSprite of this
  repeat with qspt = sptChan to sptChan + 4
    set the member of sprite qspt to member "Eraser"
    set the ink of sprite qspt to 8
    set the blend of sprite qspt to 0
    set the trails of sprite qspt to 0
    set the loc of sprite qspt to point(-1000, 300)
  end repeat
  set the eraserHasRegion of this to 1
end
