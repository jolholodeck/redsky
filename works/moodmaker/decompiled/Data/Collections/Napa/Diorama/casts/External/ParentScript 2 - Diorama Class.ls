property ProbOverride, TestIntensity, State, mode, LAnimObjs, AnimNames, Cst, firstSpr, lastSpr, XCoord, YCoord, UsePreloading, LAnimLimits, LRainData, TimeIdx, timeIncr, TimeLastAnimStarted
global goK

on new me
  if not (the shiftDown) then
    mode = #RunTime
    AnimNames = [#Background, #Grass, #Windmill, #tractor, #Bird1, #Bird2, #Geese, #Ladybug, #Leaves, #Balloon1, #Balloon2, #rain, #Rain1, #Rain2, #Rain3]
  else
    if the shiftDown and (the runMode = "Author") then
      if not (the controlDown) then
        mode = #AuthorTime
        AnimNames = [#Background, #Grass, #Windmill, #tractor, #Bird1, #Bird2, #Geese, #Ladybug, #Leaves, #Balloon1, #Balloon2, #rain, #Rain1, #Rain2, #Rain3]
      else
        mode = #AuthorTime
        AnimNames = [#rain, #Rain1, #Rain2, #Rain3]
      end if
    end if
  end if
  ProbOverride = 0
  State = #SettingUp
  firstSpr = goK.iLsprNum.diorama[1]
  lastSpr = getLast(goK.iLsprNum.diorama)
  Cst = goK.iLibNumCollDio
  XCoord = 0
  YCoord = 0
  UsePreloading = 0
  TestIntensity = VOID
  TimeIdx = the milliSeconds
  timeIncr = 2000
  TimeLastAnimStarted = 0
  LAnimObjs = [:]
  LRainData = [#State: #offw]
  (the actorList).add(me)
  return me
end

on Dispose me
  repeat with thisAnim in LAnimObjs
    thisAnim.Dispose()
    LAnimObjs.deleteProp(thisAnim)
    thisAnim = 0
  end repeat
  LAnimObjs = [:]
  LAnimNames = []
  LAnimLimits = [:]
  ProbOverride = 0
  TimeIdx = 0
  timeIncr = 0
  TimeLastAnimStarted = 0
  (the actorList).deleteOne(me)
end

on SetupAnims me
  repeat with name in AnimNames
    case name of
      #Background:
        LAnimObjs[name] = new(script("Anim BG SubClass"))
      #tractor:
        LAnimObjs[name] = script("Anim Tractor Subclass").new(name)
      #Balloon1:
        LAnimObjs[name] = script("Anim Balloon Subclass").new(name)
      #Balloon2:
        LAnimObjs[name] = script("Anim Balloon Subclass").new(name)
      otherwise:
        LAnimObjs[name] = script("Anim Class").new(name)
    end case
    ErrorCheck(LAnimObjs[name], objectp(LAnimObjs[name]), "Problem instantiating animation object: " & name)
    LAnimObjs[name].Init()
    LAnimObjs[name].InitTiming()
    if LAnimObjs[name].AutoStart then
      LAnimObjs[name].start()
    end if
  end repeat
  ErrorCheck(LAnimObjs, listp(LAnimObjs), "Diorama.LAnimObjs is not a valid list.")
  State = #Running
end

on Change me, paramsList, testFlag
  repeat with Params in paramsList
    lAnimsToChange = mSoundToAnims(me, Params.name)
    if not lAnimsToChange then
      next repeat
    end if
    if not voidp(getaProp(Params, #intensity)) then
      intensity = Params.intensity
    else
      if voidp(TestIntensity) then
        intensity = 100
      else
        intensity = TestIntensity
      end if
    end if
    if findPos(Params, #duration) > 0 then
      duration = Params.duration
    else
      duration = 30000
    end if
    newState = Params.State
    intensityID = mCoerceIntensity(me, intensity)
    if lAnimsToChange = [#rain] then
      case newState of
        #on:
          lAnimsToChange = [#rain]
          setaProp(LRainData, #State, #Starting)
          setaProp(LRainData, #intensity, intensityID)
          case intensityID of
            #Low:
              setaProp(LRainData, #objs, [#Rain3])
              lAnimsToStop = [#Rain1, #Rain2]
            #med:
              setaProp(LRainData, #objs, [#Rain3, #Rain2])
              lAnimsToStop = [#Rain1]
            #High:
              setaProp(LRainData, #objs, [#Rain3, #Rain2, #Rain1])
              lAnimsToStop = []
          end case
          repeat with whichRain in lAnimsToStop
            checkRain = LAnimObjs[whichRain]
            if checkRain.State = #playing then
              stop(checkRain)
            end if
          end repeat
          if LAnimObjs.rain.State = #playing then
            lAnimsToChange = LRainData.objs
          end if
          if LAnimObjs.Leaves.State = #playing then
            stop(LAnimObjs.Leaves)
          end if
          repeat with animTag in [#Windmill, #Grass]
            checkMe = LAnimObjs[animTag]
            if checkMe.State = #playing then
              SetState(checkMe, #Paused)
            end if
          end repeat
        #off:
          lAnimsToChange = [#rain, #Rain3, #Rain2, #Rain1]
          setaProp(LRainData, #State, #off)
      end case
    end if
    repeat with animTag in lAnimsToChange
      thisObj = LAnimObjs[animTag]
      if ilk(LAnimObjs.getaProp(animTag), #void) then
        next repeat
      end if
      case newState of
        #on:
          case thisObj.State of
            #Ready:
              thisObj.start(duration, intensityID, testFlag)
            #playing:
              thisObj.mRefreshData(duration)
              thisObj.Change(intensityID)
          end case
        #off:
          if getOne([#rain, #Rain1, #Rain2, #Rain3], animTag) then
            if thisObj.State = #playing then
              stop(thisObj)
            end if
            repeat with animTag in [#Windmill, #Grass]
              startMe = LAnimObjs[animTag]
              if startMe.State = #Paused then
                SetState(startMe, #playing)
              end if
            end repeat
          else
            if thisObj.State = #playing then
              if testFlag then
                thisObj.Change(TestIntensity)
                if ProbOverride = 1 then
                  stop(thisObj, 1)
                end if
              else
                newIntensity = #Low
                thisObj.Change(newIntensity)
              end if
            else
              if thisObj.State = #Ready then
                thisObj.Change(TestIntensity)
              end if
            end if
          end if
      end case
    end repeat
  end repeat
end

on StopAll me
  repeat with thisAnim in me.GetAnims(#playing)
    LAnimObjs[thisAnim].stop()
  end repeat
end

on stepFrame me
  case State of
    #Starting:
    #Running:
      RandomTrigger(me)
      repeat with anim in LAnimObjs
        Thread(anim)
      end repeat
    #Paused:
  end case
end

on RandomTrigger me
  if not ProbOverride then
    if the milliSeconds > TimeIdx then
      if LRainData.State <> #requested then
        readyAnims = GetAnims(me, #Ready)
        if readyAnims.count > 0 then
          animName = readyAnims[random(readyAnims.count)]
          if getOne([#rain, #Rain1, #Rain2, #Rain3, #tractor], animName) then
          else
            theResult = start(LAnimObjs[animName], VOID, VOID)
            TimeIdx = TimeIdx + timeIncr
          end if
        end if
      end if
    end if
  end if
end

on SetOffset me, newX, newY
  XCoord = newX
  YCoord = newY
  repeat with anim in LAnimObjs
    anim.UpdateLoc()
    updateStage()
  end repeat
end

on GetState me
  return State
end

on pause me
  State = #Paused
  repeat with anim in LAnimObjs
    anim.pause()
  end repeat
end

on Resume me
  State = #Running
  TimeIdx = the milliSeconds
  TimeLastAnimStarted = the milliSeconds
  repeat with anim in LAnimObjs
    anim.Resume()
  end repeat
end

on GetAnims me, thisState
  animList = []
  repeat with thisAnim in LAnimObjs
    if thisAnim.State = thisState then
      animList.add(thisAnim.name)
    end if
  end repeat
  return animList
end

on GetAnimNames me
  names = []
  repeat with anim in LAnimObjs
    names.add(anim.name)
  end repeat
  return names
end

on mSoundToAnims me, sound
  case sound of
    #wind:
      return [#Grass, #Windmill, #Leaves, #Balloon1, #Balloon2]
    #rain:
      return [#rain]
    #birds:
      return [#Bird1, #Bird2, #Geese]
    #rain, #Ladybug, #tractor, #Grass, #Windmill, #Leaves, #Balloon1, #Balloon2, #Bird1, #Bird2, #Geese:
      return [sound]
    otherwise:
      return 0
  end case
end

on mChangeProbOverride me, flag
  ProbOverride = flag
  TimeIdx = the milliSeconds
end

on mChangeTestIntensity me, newIntensity
  TestIntensity = newIntensity
end

on mCoerceIntensity me, int
  case ilk(int) of
    #integer:
      int = max(min(int, 100), 0)
      if int < 33 then
        intensityID = #Low
      else
        if int < 66 then
          intensityID = #med
        else
          intensityID = #High
        end if
      end if
    #symbol:
      if getOne([#Low, #med, #High], int) then
        intensityID = int
      else
        intensityID = #med
      end if
    otherwise:
      intensityID = #med
  end case
  return intensityID
end

on mCheckRainStart me, argIntensity
  setaProp(LRainData, #State, #requested)
  launchVote = 1
  repeat with animTag in [#tractor, #Bird1, #Bird2, #Ladybug]
    if LAnimObjs[animTag].State = #playing then
      launchVote = 0
      exit repeat
    end if
  end repeat
  if launchVote then
    Change(me, [[#name: #rain, #State: #on, #intensity: argIntensity]])
    return 1
  else
    return 0
  end if
end

on mAbortRainSTart me
  setaProp(LRainData, #State, #off)
end

on mStartRain me
  if LRainData.State = #Starting then
    setaProp(LRainData, #State, #playing)
    intensity = getaProp(LRainData, #intensity)
    lObjsToStart = getaProp(LRainData, #objs)
    repeat with obj in lObjsToStart
      start(LAnimObjs[obj], VOID, intensity)
    end repeat
  end if
end
