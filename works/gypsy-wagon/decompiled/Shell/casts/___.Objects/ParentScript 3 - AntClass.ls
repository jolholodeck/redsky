property antNextUpdate, antAction, antTempAction, antTempTimer, antPanicLevel, antX, antY, antSpeed, antDir, antTargDir, antWayPointList, antHeadYaw, antTeleLaunchX, antTeleLaunchY, RasterMap, soundChan, antHeadSprite, antBodySprite, antWalkCycle, antTeleInCycle, antTeleOutCycle, antTeleInIndex, antTeleOutIndex, antHeadAnimIndex, antBodyAnimIndex, antFadeBlend, objPaused
global gdmoAntAntennaeTipOffset, gdmoAntHeadOffset, gdmoAntPiSection, gdmoNumAnimsRunning, gdmoPaperRasterMap, gdmoAntWalkCycle, gdmoAntWalkOnCycle, gdmoAntDeadTable, gdmoAntTeleportInCycle, gdmoAntTeleportOutCycle

on new this, headChan, bodyChan, sndChan
  set the objPaused of this to 0
  objReset(this)
  set the RasterMap of this to gdmoPaperRasterMap
  set the soundChan of this to sndChan
  set the antHeadSprite of this to headChan
  set the antBodySprite of this to bodyChan
  set the antWalkCycle of this to gdmoAntWalkCycle
  set the antTeleInCycle of this to gdmoAntTeleportInCycle
  set the antTeleOutCycle of this to gdmoAntTeleportOutCycle
  set gdmoAntAntennaeTipOffset to 16
  set gdmoAntHeadOffset to 5
  puppetSprite(the antBodySprite of this, 1)
  puppetSprite(the antHeadSprite of this, 1)
  return this
end

on addDeltaDir dir, deltaDir
  set nDir to dir + deltaDir
  if nDir < 1 then
    set nDir to 16 - nDir
  end if
  if nDir > 16 then
    set nDir to nDir - 15
  end if
  return nDir
end

on objUpdate this
  if the objPaused of this then
    exit
  end if
  if the timer < the antNextUpdate of this then
    exit
  end if
  set the antNextUpdate of this to the timer + 3
  case the antTempAction of this of
    #nothing:
      set panic to the antPanicLevel of this - 0.02
      if panic < 1.69999999999999996 then
        set panic to 1.69999999999999996
      end if
      set the antPanicLevel of this to panic
      set the antSpeed of this to panic
      set the antHeadYaw of this to 0
      if random(30) = 1 then
        set the antTempAction of this to #stoppedThinking
        set the antTempTimer of this to (random(20) + 15) / the antPanicLevel of this
      end if
      case the antAction of this of
        #runningToDestination:
          set somewhereToGo to 0
          repeat while somewhereToGo = 0
            if count(the antWayPointList of this) = 0 then
              set the antTempAction of this to #stoppedThinking
              set the antTempTimer of this to (random(20) + 15) / the antPanicLevel of this
              antSetRandomDestination(this)
              set somewhereToGo to 1
              next repeat
            end if
            set destpt to getAt(the antWayPointList of this, 1)
            set destX to getAt(destpt, 1)
            set destY to getAt(destpt, 2)
            set deltaX to destX - the antX of this
            set deltaY to destY - the antY of this
            if (abs(deltaX) + abs(deltaY)) < 6 then
              deleteAt(the antWayPointList of this, 1)
              next repeat
            end if
            set somewhereToGo to 1
          end repeat
          if abs(deltaX) < 0.01 then
            set deltaX to 0.01
          end if
          set angle to atan(deltaY / deltaX)
          set pieSlice to (angle / gdmoAntPiSection) + 5.0
          if deltaX < 0.0 then
            set pieSlice to pieSlice + 8.0
          end if
          if pieSlice > 16.0 then
            set pieSlice to pieSlice - 15.0
          end if
          antTurnToDirection(this, pieSlice)
        #exploringInDirection:
          if random(5) = 1 then
            set newDir to the antDir of this
            if random(2) = 1 then
              set newDir to newDir - 1.0
            else
              set newDir to newDir + 1.0
            end if
            if newDir < 1.0 then
              set newDir to 16.0 - newDir
            end if
            if newDir > 16.0 then
              set newDir to newDir - 15.0
            end if
            antTurnToDirection(this, newDir)
          else
            antTurnToDirection(this, the antTargDir of this)
          end if
      end case
      set collisionObj to antCheckDirectionalCollision(this, the antDir of this)
      if collisionObj <> #nothing then
        set the antTempAction of this to #encounter
        set the antTempTimer of this to random(30) / the antPanicLevel of this
      else
        antStepForward(this)
      end if
      antUpdateWalkAnimation(this)
    #walkingOn:
      set animIdx to the antHeadAnimIndex of this
      set crntAnim to getAt(gdmoAntWalkOnCycle, animIdx)
      set spt to the antHeadSprite of this
      set mbr to getAt(crntAnim, 1)
      if mbr = -99 then
        set the antHeadAnimIndex of this to 0
        set the antTempAction of this to #nothing
      else
        set the member of sprite spt to mbr
        set the loc of sprite spt to getAt(crntAnim, 2)
        set the antHeadAnimIndex of this to animIdx + 1
      end if
    #deadAndFading:
      set fadeVal to the antFadeBlend of this
      set spt to the antHeadSprite of this
      if fadeVal < 100 then
        set the blend of sprite spt to fadeVal
      end if
      set fadeVal to fadeVal - 5
      if fadeVal < 0 then
        set the loc of sprite spt to point(-1000, 300)
        set the blend of sprite spt to 100
        objReset(this)
      end if
      set the antFadeBlend of this to fadeVal
    #encounter:
      set the antTempTimer of this to the antTempTimer of this - 1
      if the antTempTimer of this > 0 then
        set headMove to random(3) - 2
        if headMove = the antHeadYaw of this then
          set headMove to -headMove
        end if
        set the antHeadYaw of this to the antHeadYaw of this + headMove
      else
        case random(3) of
          1:
            set the antTempTimer of this to random(15) * the antPanicLevel of this
            set the antTempAction of this to #stoppedThinking
          2:
            set the antTempTimer of this to random(4) + 4
            set the antTempAction of this to #backingUp
          3:
            set the antTempAction of this to #turning
        end case
      end if
      antUpdateWalkAnimation(this)
    #stoppedThinking:
      set the antTempTimer of this to the antTempTimer of this - 1
      if the antTempTimer of this < 1 then
        set the antTempAction of this to #nothing
        set the antHeadAnimIndex of this to 0
      else
        incHeadAnimIndex(this)
        if random(10) = 1 then
          set headMove to random(3) - 2
          if headMove = the antHeadYaw of this then
            set headMove to -headMove
          end if
          set the antHeadYaw of this to the antHeadYaw of this + headMove
        end if
      end if
      antUpdateWalkAnimation(this)
    #turning:
      if the antDir of this <> the antTargDir of this then
        antTurnToDirection(this, the antTargDir of this)
      else
        set the antTempAction of this to #nothing
      end if
      incBodyAnimIndex(this)
      antUpdateWalkAnimation(this)
    #backingUp:
      set the antTempTimer of this to the antTempTimer of this - 1
      if the antTempTimer of this > 0 then
        set backDir to addDeltaDir(the antDir of this, 8)
        if antCheckDirectionalCollision(this, backDir) = #nothing then
          antStepBackward(this)
        else
          set the antTempTimer of this to random(15) * the antPanicLevel of this
          set the antTempAction of this to #stoppedThinking
        end if
      else
        if the antPanicLevel of this > 1.5 then
          set the antTempTimer of this to random(15) * the antPanicLevel of this
          set the antTempAction of this to #stoppedThinking
        else
          set the antTempAction of this to #nothing
        end if
      end if
      antTurnToDirection(this, the antTargDir of this)
      incBodyAnimIndex(this)
      antUpdateWalkAnimation(this)
    #teleporting:
      set tinIdx to the antTeleInIndex of this
      if tinIdx > 0 then
        set crntAnim to getAt(the antTeleInCycle of this, tinIdx)
        set spt to the antHeadSprite of this
        set mbr to getAt(crntAnim, 1)
        if mbr = -99 then
          set tinIdx to 0
          set the loc of sprite spt to point(-1000, 300)
          set the antDir of this to 1
          antUpdateWalkAnimation(this)
        else
          set the loc of sprite spt to point(the antX of this, the antY of this)
          set the member of sprite spt to getAt(crntAnim, 1)
          set tinIdx to tinIdx + 1
        end if
      end if
      if tinIdx = 0 then
        set panic to the antPanicLevel of this + 0.5
        if panic > 2.5 then
          set panic to 3.5
        end if
        set the antPanicLevel of this to panic
        set the antSpeed of this to panic
        set the antTempTimer of this to random(10) * panic
        set the antTempAction of this to #stoppedThinking
      else
        set the antTeleInIndex of this to tinIdx
      end if
  end case
end

on antUpdateWalkAnimation this
  case the antTempAction of this of
    #walkingOn:
    #deadAndFading:
      set the loc of sprite the antHeadSprite of this to point(the antX of this, the antY of this)
    otherwise:
      set crntBody to getAt(the antWalkCycle of this, the antDir of this)
      set headDir to addDeltaDir(the antDir of this, the antHeadYaw of this)
      set crntHead to getAt(the antWalkCycle of this, headDir)
      set headX to the antX of this + (getAt(crntHead, 1) * gdmoAntHeadOffset)
      set headY to the antY of this + (getAt(crntHead, 2) * gdmoAntHeadOffset)
      set the memberNum of sprite the antHeadSprite of this to getAt(crntHead, 3 + the antHeadAnimIndex of this)
      set the loc of sprite the antHeadSprite of this to point(headX, headY)
      set the memberNum of sprite the antBodySprite of this to getAt(crntBody, 9 + the antBodyAnimIndex of this)
      set the loc of sprite the antBodySprite of this to point(the antX of this, the antY of this)
  end case
end

on antSetDestination this, destPoint
  set c to count(the antWayPointList of this)
  repeat with i = 1 to c
    deleteAt(the antWayPointList of this, 1)
  end repeat
  set the antWayPointList of this to list(destPoint)
  set the antAction of this to #runningToDestination
end

on antSetRandomDestination this
  case random(2) of
    1:
      antSetDestination(this, point(random(640), random(480)))
      set the antAction of this to #runningToDestination
    2:
      set the antTargDir of this to random(16) - 1
      set the antAction of this to #exploringInDirection
  end case
end

on antTurnToDirection this, newDir
  set yaw to abs(the antDir of this - newDir)
  set drot to 1
  if yaw > 8.0 then
    set drot to -1
  end if
  if newDir > the antDir of this then
    set the antDir of this to the antDir of this + drot
  end if
  if newDir < the antDir of this then
    set the antDir of this to the antDir of this - drot
  end if
  if the antDir of this < 1 then
    set the antDir of this to 16
  end if
  if the antDir of this > 16 then
    set the antDir of this to 1
  end if
end

on antCheckDirectionalCollision this, dir
  set retVal to #nothing
  set leftCorner to addDeltaDir(dir, -2)
  set rghtCorner to addDeltaDir(dir, 2)
  set crntAnim to getAt(the antWalkCycle of this, leftCorner)
  set ax to the antX of this + (getAt(crntAnim, 1) * gdmoAntAntennaeTipOffset)
  set ay to the antY of this + (getAt(crntAnim, 2) * gdmoAntAntennaeTipOffset)
  set val to getVal(the RasterMap of this, ax, ay)
  if val <> #nothing then
    set retVal to val
  end if
  set crntAnim to getAt(the antWalkCycle of this, rghtCorner)
  set ax to the antX of this + (getAt(crntAnim, 1) * gdmoAntAntennaeTipOffset)
  set ay to the antY of this + (getAt(crntAnim, 2) * gdmoAntAntennaeTipOffset)
  set val to getVal(the RasterMap of this, ax, ay)
  if val <> #nothing then
    set retVal to val
  end if
  set crntAnim to getAt(the antWalkCycle of this, dir)
  set ax to the antX of this + (getAt(crntAnim, 1) * gdmoAntAntennaeTipOffset)
  set ay to the antY of this + (getAt(crntAnim, 2) * gdmoAntAntennaeTipOffset)
  set val to getVal(the RasterMap of this, ax, ay)
  if val <> #nothing then
    set retVal to val
  end if
  set ax to the antX of this + (getAt(crntAnim, 1) * (gdmoAntAntennaeTipOffset / 2))
  set ay to the antY of this + (getAt(crntAnim, 2) * (gdmoAntAntennaeTipOffset / 2))
  set val to getVal(the RasterMap of this, ax, ay)
  if val <> #nothing then
    set retVal to val
  end if
  return retVal
end

on incBodyAnimIndex this
  set newIdx to the antBodyAnimIndex of this + 1
  if newIdx > 3 then
    set newIdx to 0
  end if
  set the antBodyAnimIndex of this to newIdx
end

on incHeadAnimIndex this
  set newIdx to the antHeadAnimIndex of this + 1
  if newIdx > 5 then
    set newIdx to 0
  end if
  set the antHeadAnimIndex of this to newIdx
end

on makeSureOnPaper this
  global gdmoPaperLftX, gdmoPaperRgtX, gdmoPaperTopY, gdmoPaperBotY
  if the antX of this < gdmoPaperLftX then
    set the antX of this to gdmoPaperLftX + 15
  end if
  if the antX of this > gdmoPaperRgtX then
    set the antX of this to gdmoPaperRgtX - 15
  end if
  if the antY of this < gdmoPaperTopY then
    set the antY of this to gdmoPaperTopY + 15
  end if
  if the antY of this > gdmoPaperBotY then
    set the antY of this to gdmoPaperBotY - 15
  end if
end

on antStepForward this
  set crntAnim to getAt(the antWalkCycle of this, the antDir of this)
  set the antX of this to the antX of this + (getAt(crntAnim, 1) * the antSpeed of this)
  set the antY of this to the antY of this + (getAt(crntAnim, 2) * the antSpeed of this)
  makeSureOnPaper(this)
  incBodyAnimIndex(this)
end

on antStepBackward this
  set crntAnim to getAt(the antWalkCycle of this, the antDir of this)
  set the antX of this to the antX of this - (getAt(crntAnim, 1) * the antSpeed of this)
  set the antY of this to the antY of this - (getAt(crntAnim, 2) * the antSpeed of this)
  makeSureOnPaper(this)
  incBodyAnimIndex(this)
end

on antGetPosition this
  return point(the antX of this, the antY of this)
end

on antSetPosition this, x, y
  set the antX of this to x
  set the antY of this to y
  makeSureOnPaper(this)
  antUpdateWalkAnimation(this)
  set panic to the antPanicLevel of this + 0.20000000000000001
  if panic > 2.5 then
    set panic to 2.5
  end if
  set the antPanicLevel of this to panic
  set the antSpeed of this to panic
  set the antTempTimer of this to random(15) * panic
  if the antTempAction of this = #nothing then
    set the antTempAction of this to #stoppedThinking
  end if
end

on antTeleportToPosition this, x, y
  if the antTempAction of this <> #deadAndFading then
    set the antTeleLaunchX of this to the antX of this
    set the antTeleLaunchY of this to the antY of this
    set the antX of this to x
    set the antY of this to y
    set the antTeleInIndex of this to 1
    set the antTempAction of this to #teleporting
    set spt1 to the antHeadSprite of this
    set spt2 to the antBodySprite of this
    set the antHeadAnimIndex of this to 0
    set the loc of sprite spt1 to point(-1000, 300)
    set the loc of sprite spt2 to point(-1000, 300)
    puppetSound(the soundChan of this, "teleport.aiff")
  end if
end

on objClicked this
  if the antTempAction of this <> #deadAndFading then
    set mbr to getAt(getAt(gdmoAntDeadTable, integer(the antDir of this)), random(3))
    set spt1 to the antHeadSprite of this
    set spt2 to the antBodySprite of this
    set the member of sprite spt1 to mbr
    set the loc of sprite spt1 to point(the antX of this, the antY of this)
    set the loc of sprite spt2 to point(-1000, 300)
    set the antTempAction of this to #deadAndFading
    set the antFadeBlend of this to 100 + 200
    puppetSound(the soundChan of this, "ant.crush")
  end if
end

on objPlay this
  set the objPaused of this to 0
end

on objPause this
  set the objPaused of this to 1
  sound stop the soundChan of this
end

on objReset this
  set the antNextUpdate of this to the timer
  set the antAction of this to #exploringInDirection
  set the antTempAction of this to #walkingOn
  set the antTempTimer of this to 0
  set the antPanicLevel of this to 2.0
  set atd to random(6) + 12
  if atd > 16 then
    set atd to atd - 15
  end if
  set the antX of this to 470.0
  set the antY of this to 393.0
  set the antSpeed of this to 2.0
  set the antDir of this to 1
  set the antTargDir of this to atd
  set the antWayPointList of this to []
  set the antHeadYaw of this to 0
  set the antTeleLaunchX of this to 0.0
  set the antTeleLaunchY of this to 0.0
  set the antHeadAnimIndex of this to 1
  set the antTeleInIndex of this to 0
  set the antTeleOutIndex of this to 0
  set the antBodyAnimIndex of this to 0
  set the antFadeBlend of this to 0
  set the blend of sprite the antHeadSprite of this to 100
  set the blend of sprite the antBodySprite of this to 100
  set the ink of sprite the antHeadSprite of this to 36
  set the ink of sprite the antBodySprite of this to 36
end

on objHide this
  set the loc of sprite the antBodySprite of this to point(-1000, 300)
  set the loc of sprite the antHeadSprite of this to point(-1000, 300)
  puppetSprite(the antBodySprite of this, 0)
  puppetSprite(the antHeadSprite of this, 0)
end

on objShow this
  puppetSprite(the antBodySprite of this, 1)
  puppetSprite(the antHeadSprite of this, 1)
end

on objDelete this
  objHide(this)
  sound stop the soundChan of this
end
