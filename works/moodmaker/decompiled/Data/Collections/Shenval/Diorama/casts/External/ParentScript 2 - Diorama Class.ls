property ProbOverride, TestIntensity, State, mode, LAnimObjs, LAnimNames, Cst, firstSpr, lastSpr, XCoord, YCoord, UsePreloading, LAnimLimits, TimeIdx, timeIncr, TimeLastAnimStarted
global goK

on new me
  if not (the shiftDown) then
    mode = #RunTime
  else
    if the shiftDown and (the runMode = "Author") then
      mode = #AuthorTime
    end if
  end if
  LAnimNames = [#Background, #Cloud, #leaf1, #leaf2, #leaf3, #leaf4, #leaf5, #branches, #squirrel1, #squirrel2, #Squirrel3, #Flock, #worker]
  ProbOverride = 0
  LAnimLimits = [#squirrel: 2, #Leaves: 3, #worker: 1, #all: 15]
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
  repeat with name in LAnimNames
    case name of
      #Background:
        LAnimObjs[name] = new(script("Anim BG SubClass"))
      otherwise:
        LAnimObjs[name] = new(script("Anim Class"), name)
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

on stepFrame me
  case State of
    #Starting:
    #Running:
      me.RandomTrigger()
      repeat with anim in LAnimObjs
        anim.Thread()
      end repeat
    #Paused:
  end case
end

on RandomTrigger me
  if not ProbOverride then
    if TimeLastAnimStarted < (the milliSeconds - (7 * 1000)) then
      overRideFlag = 1
    end if
    if the milliSeconds > TimeIdx then
      readyAnims = me.GetAnims(#Ready)
      if readyAnims.count > 0 then
        animNum = random(readyAnims.count)
        animName = readyAnims[animNum]
        if mCheckLimit(me, animName) then
          theResult = start(LAnimObjs[animName], VOID, overRideFlag)
        end if
      end if
      TimeIdx = TimeIdx + timeIncr
    end if
    if theResult then
      TimeLastAnimStarted = the milliSeconds
    end if
  end if
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
    newState = Params.State
    repeat with animTag in lAnimsToChange
      mUpdateLimit(me, animTag, mCoerceIntensity(me, intensity))
      case animTag of
        #Leaves, #squirrel:
          lSubTags = mGetSubSpeciesName(me, animTag)
          lObjs = []
          repeat with tag in lSubTags
            add(lObjs, getaProp(LAnimObjs, tag))
          end repeat
          shuffleList(lObjs)
        otherwise:
          lObjs = [LAnimObjs[animTag]]
      end case
      if testFlag then
        lObjs = [LAnimObjs[Params.name]]
      end if
      repeat with thisObj in lObjs
        case newState of
          #on:
            case thisObj.State of
              #Ready:
                if mCheckLimit(me, #all) then
                  if mCheckLimit(me, animTag) then
                    thisObj.start(intensity, testFlag)
                  end if
                end if
              #playing:
                thisObj.mRefreshData(intensity)
                thisObj.Change(intensity)
            end case
          #off:
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
        end case
      end repeat
    end repeat
  end repeat
end

on StopAll me, clearFlag
  repeat with thisAnim in me.GetAnims(#playing)
    LAnimObjs[thisAnim].stop(clearFlag)
  end repeat
end

on SetOffset me, newX, newY
  XCoord = newX
  YCoord = newY
  repeat with anim in LAnimObjs
    anim.UpdateLoc()
    updateStage()
  end repeat
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

on GetState me
  return State
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

on GetAnimNames me, lObjs
  if not listp(lObjs) then
    lObjs = LAnimObjs
  end if
  lNames = []
  repeat with anim in lObjs
    lNames.add(anim.name)
  end repeat
  return lNames
end

on mSoundToAnims me, sound
  case sound of
    #wind:
      return [#Cloud, #Leaves, #branches]
    #squirrel, #animals, #squirrel1, #squirrel2, #Squirrel3:
      return [#squirrel]
    #birds, #Flock:
      return [#Flock]
    #people, #workers, #worker, #worker1, #Worker23, #worker4Right, #worker4Left:
      return [#worker]
    #leaf1, #leaf2, #leaf3, #leaf4, #leaf5:
      return [#Leaves]
    #branches:
      return [#branches]
    #Cloud:
      return [#Cloud]
    otherwise:
      return 0
  end case
end

on mGetSubSpeciesName me, type
  case type of
    #Leaves:
      lNames = [#leaf1, #leaf2, #leaf3, #leaf4, #leaf5]
    #squirrel:
      lNames = [#squirrel1, #squirrel2, #Squirrel3]
    #worker:
      lNames = [#worker1, #Worker23, #worker4Left, #worker4Right]
  end case
  return lNames
end

on mChangeProbOverride me, flag
  ProbOverride = flag
  TimeIdx = the milliSeconds
end

on mChangeTestIntensity me, newIntensity
  TestIntensity = newIntensity
end

on mCheckLimit me, type
  case type of
    #Leaves, #leaf1, #leaf2, #leaf3, #leaf4, #leaf5:
      limit = getaProp(LAnimLimits, #Leaves)
      checkList = mGetSubSpeciesName(me, #Leaves)
    #squirrel, #squirrel1, #squirrel2, #Squirrel3:
      limit = getaProp(LAnimLimits, #squirrel)
      checkList = mGetSubSpeciesName(me, #squirrel)
    #worker:
      limit = getaProp(LAnimLimits, #worker)
      checkList = mGetSubSpeciesName(me, #worker)
    #all:
      limit = getaProp(LAnimLimits, #all)
      checkList = GetAnimNames(me)
    otherwise:
      return 1
  end case
  howMany = 0
  lPlaying = GetAnims(me, #playing)
  lSpeciesPlaying = []
  repeat with name in checkList
    if getOne(lPlaying, name) then
      add(lSpeciesPlaying, name)
      howMany = howMany + 1
    end if
  end repeat
  if howMany < limit then
    return 1
  else
    if howMany > limit then
      repeat with i = 1 to howMany - limit
        killMe = lSpeciesPlaying[random(count(lSpeciesPlaying))]
        stop(LAnimObjs[killMe], 1)
      end repeat
    end if
    return 0
  end if
end

on mUpdateLimit me, type, intensityID
  case type of
    #Leaves:
      intensityList = [#Low: 2, #med: 3, #High: 4]
    #squirrel:
      intensityList = [#Low: 1, #med: 2, #High: 3]
    #worker:
      intensityList = [#Low: 1, #med: 1, #High: 1]
    otherwise:
      exit
  end case
  setaProp(LAnimLimits, type, getaProp(intensityList, intensityID))
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
