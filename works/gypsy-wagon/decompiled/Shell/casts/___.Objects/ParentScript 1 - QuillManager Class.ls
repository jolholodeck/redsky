property charTable, asciiMap, RasterMap, quillSprite, soundChan, quillMode, menuQueue, textOnscreen, renderQueue, scheduleQueue, nextSchedEvent, eraserHasRegion, eraserQueue, eraserRasterVal, eraserX, eraserY, eDeltaX, eDeltaY, eWalkX1, eWalkY1, eWalkX2, eWalkY2, eraserStep, eraserDir, eMaxX, eMaxY, objPaused
global gdmoQuillSndChan, gdmoQuillAltSndChan, gdmoTheAnt, gdmoLeftArrowOnscreen, gdmoRghtArrowOnscreen, gdmoMenuTitleSprite, gdmoLeftArrowSprite, gdmoRghtArrowSprite

on new this, sptChan, sndChan
  global gdmoQuillCharTable, gdmoQuillAsciiMap, gdmoPaperRasterMap
  set the objPaused of this to 0
  set the charTable of this to gdmoQuillCharTable
  set the asciiMap of this to gdmoQuillAsciiMap
  set the RasterMap of this to gdmoPaperRasterMap
  set the quillSprite of this to sptChan
  set the soundChan of this to sndChan
  set the quillMode of this to #resting
  set the menuQueue of this to 0
  set the textOnscreen of this to 0
  set the renderQueue of this to []
  set the scheduleQueue of this to []
  set the nextSchedEvent of this to the maxinteger
  set the eraserHasRegion of this to 0
  set the eraserQueue of this to []
  set the eraserRasterVal of this to #eraserNoVal
  set the eraserX of this to 0.0
  set the eraserY of this to 0.0
  set the eWalkX1 of this to 0.0
  set the eWalkY1 of this to 0.0
  set the eWalkX2 of this to 0.0
  set the eWalkY2 of this to 0.0
  set the eMaxX of this to 0.0
  set the eMaxY of this to 0.0
  set the eraserDir of this to 0.0
  set the eraserStep of this to the width of member "Eraser" / 2
  repeat with chn = sptChan to sptChan + 4
    puppetSprite(chn, 1)
  end repeat
  return this
end

on objUpdate this
  global gdmoMenuAreaTopY, gdmoMenuAreaBotY, gdmoSmokeIsPlaying, gdmoPrestoSplashPuppeted
  if the objPaused of this then
    exit
  end if
  case the quillMode of this of
    #resting:
      if objectp(menuQueue) and (gdmoSmokeIsPlaying = 0) then
        menuScheduleRender(menuQueue, this)
        set the quillMode of this to #writing
        displayCurrentMenuTitle()
        set sptChan to the quillSprite of this
        repeat with chn = sptChan to sptChan + 4
          set the ink of sprite chn to 36
          set the blend of sprite chn to 100
          set the trails of sprite chn to 1
        end repeat
        set menuQueue to 0
      end if
    #writing:
      set renderCnt to count(the renderQueue of this)
      if renderCnt < 3 then
        set now to the timer
        if the nextSchedEvent of this < now then
          set listCount to count(the scheduleQueue of this)
          repeat while (listCount > 0) and (renderCnt < 3)
            set event to getAt(the scheduleQueue of this, 1)
            if getAt(event, 1) < now then
              set gfxObj to getAt(event, 2)
              set rndObj to new(script "RenderTextClass", gfxObj)
              append(the renderQueue of this, rndObj)
              deleteAt(the scheduleQueue of this, 1)
              set listCount to count(the scheduleQueue of this)
              set renderCnt to renderCnt + 1
              set the textOnscreen of this to 1
              set sndChan to 0
              if soundBusy(gdmoQuillSndChan) = 0 then
                set sndChan to gdmoQuillSndChan
              else
                if soundBusy(gdmoQuillAltSndChan) = 0 then
                  set sndChan to gdmoQuillAltSndChan
                end if
              end if
              if sndChan > 0 then
                case random(4) of
                  1:
                    puppetSound(sndChan, member "pen1.aiff")
                  2:
                    puppetSound(sndChan, member "pen2.aiff")
                  3:
                    puppetSound(sndChan, member "pen3.aiff")
                  4:
                    puppetSound(sndChan, member "pen4.aiff")
                end case
              end if
              next repeat
            end if
            if listCount > 0 then
              set the nextSchedEvent of this to getAt(getAt(the scheduleQueue of this, 1), 1)
            else
              set the nextSchedEvent of this to the maxinteger
            end if
            set listCount to 0
          end repeat
        end if
      end if
      set antPt to antGetPosition(gdmoTheAnt)
      set antX to getAt(antPt, 1)
      set antY to getAt(antPt, 2)
      set completedRenders to []
      set numToRender to count(the renderQueue of this)
      if numToRender > 5 then
        set numToRender to 5
      end if
      repeat with renderIter = 1 to numToRender
        set sptChan to the quillSprite of this + (renderIter - 1)
        set rendObj to getAt(the renderQueue of this, renderIter)
        set px to the penX of rendObj
        set py to the penY of rendObj
        set numChar to the numChars of rendObj
        set charIdx to the charIndex of rendObj
        set cTabRec to the cTableRec of rendObj
        set numStrk to the numStrokes of rendObj
        set strkIdx to the strokeIndex of rendObj
        set rastVal to the rasterValue of rendObj
        if strkIdx = 0 then
          set ch to char charIdx of (the textString of rendObj)
          set cTabRec to getAt(gdmoQuillCharTable, charTableGetIndex(ch))
          set numStrk to count(cTabRec)
          set strkIdx to 3
        end if
        set spt to getAt(cTabRec, strkIdx)
        set pyd to py + getBaselineDroop(px, py)
        set the loc of sprite sptChan to point(px, pyd)
        set the member of sprite sptChan to spt
        set the blend of sprite sptChan to 100
        if abs(antY - pyd) < 20 then
          if antX > px then
            set minSafeX to px + the width of member spt + 25
            if antX < minSafeX then
              antSetPosition(gdmoTheAnt, minSafeX, antY)
            end if
          else
            set minSafeX to px - 25
            if antX > minSafeX then
              antSetPosition(gdmoTheAnt, minSafeX, antY)
            end if
          end if
        end if
        case rastVal of
          #leftArrow:
            set gdmoLeftArrowOnscreen to 1
          #rghtArrow:
            set gdmoRghtArrowOnscreen to 1
          otherwise:
            set rp to the regPoint of member spt
            set x1 to px - getAt(rp, 1)
            set y1 to pyd - getAt(rp, 2) - 8
            set x2 to x1 + the width of member spt
            set y2 to y1 + the height of member spt
            setValForArea(the RasterMap of this, x1, y1, x2, y2, rastVal)
        end case
        set strkIdx to strkIdx + 1
        if strkIdx > numStrk then
          set cwidth to getAt(cTabRec, 1)
          set ckern to getAt(cTabRec, 2)
          set px to px + cwidth - ckern
          set strkIdx to 0
          set charIdx to charIdx + 1
        end if
        if charIdx > numChar then
          append(completedRenders, renderIter)
          case rastVal of
            #leftArrow:
              puppetSprite(gdmoLeftArrowSprite, 1)
              set the visible of sprite gdmoLeftArrowSprite to 1
              set the loc of sprite gdmoLeftArrowSprite to point(205, 369)
              set the member of sprite gdmoLeftArrowSprite to member "left.arrow.laydown"
            #rghtArrow:
              puppetSprite(gdmoRghtArrowSprite, 1)
              set the visible of sprite gdmoRghtArrowSprite to 1
              set the loc of sprite gdmoRghtArrowSprite to point(431, 385)
              set the member of sprite gdmoRghtArrowSprite to member "right.arrow.laydown"
          end case
          next repeat
        end if
        set the penX of rendObj to px
        set the penY of rendObj to py
        set the charIndex of rendObj to charIdx
        set the cTableRec of rendObj to cTabRec
        set the numStrokes of rendObj to numStrk
        set the strokeIndex of rendObj to strkIdx
      end repeat
      set numDone to count(completedRenders)
      repeat with i = 1 to numDone
        set idx to numDone - i + 1
        deleteAt(the renderQueue of this, getAt(completedRenders, idx))
      end repeat
      if (count(the scheduleQueue of this) = 0) and (count(the renderQueue of this) = 0) then
        set the quillMode of this to #resting
      end if
    #erasing:
      if the eraserHasRegion of this = 0 then
        if count(the eraserQueue of this) > 0 then
          set eraseVal to getAt(the eraserQueue of this, 1)
          deleteAt(the eraserQueue of this, 1)
          set regionToErase to 0
          case eraseVal of
            #menuTitle:
              set regionToErase to getRegionOfSprite(gdmoMenuTitleSprite)
              set the trails of sprite gdmoMenuTitleSprite to 1
              updateStage()
              set the loc of sprite gdmoMenuTitleSprite to point(-1000, 300)
              puppetSprite(gdmoMenuTitleSprite, 0)
            #leftArrow:
              set regionToErase to getRegionOfSprite(gdmoLeftArrowSprite)
              set the trails of sprite gdmoLeftArrowSprite to 1
              updateStage()
              set the loc of sprite gdmoLeftArrowSprite to point(-1000, 300)
              puppetSprite(gdmoLeftArrowSprite, 0)
              set gdmoLeftArrowOnscreen to 0
            #rghtArrow:
              set regionToErase to getRegionOfSprite(gdmoRghtArrowSprite)
              set the trails of sprite gdmoRghtArrowSprite to 1
              updateStage()
              set the loc of sprite gdmoRghtArrowSprite to point(-1000, 300)
              puppetSprite(gdmoRghtArrowSprite, 0)
              set gdmoRghtArrowOnscreen to 0
            otherwise:
              set regionToErase to getBoundingBoxForVal(the RasterMap of this, eraseVal)
          end case
          if objectp(regionToErase) then
            quillEraseRegionInit(this, regionToErase)
            set the eraserRasterVal of this to eraseVal
          end if
        else
          set the textOnscreen of this to 0
          set the quillMode of this to #resting
          set sptChan to the quillSprite of this
          repeat with chn = sptChan to sptChan + 4
            set the loc of sprite chn to point(-1000, 300)
          end repeat
        end if
      else
        set ex to the eraserX of this
        set ey to the eraserY of this
        set ex1 to the eWalkX1 of this
        set ey1 to the eWalkY1 of this
        set ex2 to the eWalkX2 of this
        set ey2 to the eWalkY2 of this
        set emx to the eMaxX of this
        set emy to the eMaxY of this
        set eStep to the eraserStep of this
        set numPasses to 5
        repeat with i = 1 to numPasses
          set sptChan to the quillSprite of this + (i - 1)
          case the eraserDir of this of
            0:
              set ey to ey - eStep
              set ex to ex + eStep
              if (ex > ex1) or (ey < ey1) then
                set ex to ex1
                set ey to ey1
                set ex1 to ex1 + (eStep * 2)
                if ex1 > emx then
                  set ex1 to emx
                  set ey1 to ey1 + eStep
                end if
                set the eraserDir of this to 1
              end if
            1:
              set ey to ey + eStep
              set ex to ex - eStep
              if (ex < ex2) or (ey > ey2) then
                set ex to ex2
                set ey to ey2
                set ey2 to ey2 + (eStep * 2)
                if ey2 > emy then
                  set ey2 to emy
                  set ex2 to ex2 + eStep
                end if
                set the eraserDir of this to 0
              end if
          end case
          set the loc of sprite sptChan to point(ex, ey)
        end repeat
        if ex2 < emx then
          set the eraserX of this to ex
          set the eraserY of this to ey
          set the eWalkX1 of this to ex1
          set the eWalkY1 of this to ey1
          set the eWalkX2 of this to ex2
          set the eWalkY2 of this to ey2
          if soundBusy(soundChan) = 0 then
            case random(3) of
              1:
                puppetSound(soundChan, "eraser1.aiff")
              2:
                puppetSound(soundChan, "eraser2.aiff")
              3:
                puppetSound(soundChan, "eraser3.aiff")
            end case
          end if
        else
          set rastVal to the eraserRasterVal of this
          case rastVal of
            #text1:
              clearValFromMap(the RasterMap of this, rastVal)
            #text2:
              clearValFromMap(the RasterMap of this, rastVal)
          end case
          set the eraserRasterVal of this to #eraserNoVal
          set the eraserHasRegion of this to 0
          if gdmoPrestoSplashPuppeted and (rastVal = #paperEdge) then
            set gdmoPrestoSplashPuppeted to 0
            objPlay(gdmoTheAnt)
            objShow(gdmoTheAnt)
            objReset(gdmoTheAnt)
          end if
        end if
      end if
  end case
end

on objPlay this
  set the objPaused of this to 0
end

on objPause this
  set the objPaused of this to 1
  sound stop the soundChan of this
end

on objReset this
end

on objHide this
  set sptChan to the quillSprite of this
  repeat with chn = sptChan to sptChan + 4
    set the loc of sprite chn to point(-1000, 300)
    puppetSprite(chn, 0)
  end repeat
end

on objShow this
  set sptChan to the quillSprite of this
  repeat with chn = sptChan to sptChan + 4
    puppetSprite(chn, 1)
  end repeat
end

on objDelete this
  set sptChan to the quillSprite of this
  repeat with chn = sptChan to sptChan + 4
    set the loc of sprite chn to point(-1000, 300)
    set the blend of sprite chn to 100
    set the trails of sprite chn to 0
    puppetSprite(chn, 0)
  end repeat
  sound stop the soundChan of this
end
