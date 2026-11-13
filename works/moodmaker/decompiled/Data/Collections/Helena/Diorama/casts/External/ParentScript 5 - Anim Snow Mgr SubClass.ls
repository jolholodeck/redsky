property name, State, SavedState, StateLog, AutoStart, NextTime, TimeOrigin, frame, PlaceholderMbr, LAllSnowSeqs, LSeqData, SeqLog, CurSnowType, LSnowData, LLayerData, LSnowSprs, LSnowObjs
global goDiorama, goK, gDebug

on new me
  name = #snow
  TimeOrigin = the milliSeconds
  StateLog = [:]
  SeqLog = []
  PlaceholderMbr = member("_placeholder dot", goK.iLibNumCollDio)
  LAllSnowSeqs = [[#flurry], [#flurry, #snowball, #flurry], [#flurry, #snowball, #snowman, #snowball, #flurry]]
  LLayerData = [#back: [#FPS: 12, #offset: 0, #ScaleFactor: 1.0 / 2, #mbr: member("snowflake3", goK.iLibNumCollDio)], #mid: [#FPS: 15, #offset: 0, #ScaleFactor: 2.0 / 3, #mbr: member("snowflake3", goK.iLibNumCollDio)], #fore: [#FPS: 18, #offset: 0, #ScaleFactor: 1, #mbr: member("snowflake1", goK.iLibNumCollDio)]]
  LSnowSprs = [#back: [], #mid: [], #fore: []]
  LSnowData = [#flurry: [#onSprs: [], #offSprs: []], #snowball: [#onSprs: [], #offSprs: []], #snowman: [#onSprs: [], #offSprs: []]]
  return me
end

on mFillDataStrucs me
  repeat with i = 0 to 2
    add(LSnowSprs.fore, goDiorama.lastSpr - i)
  end repeat
  repeat with i = 4 to 9
    add(LSnowSprs.mid, goDiorama.lastSpr - i)
  end repeat
  repeat with i = 10 to 15
    add(LSnowSprs.back, goDiorama.lastSpr - i)
  end repeat
  repeat with lType in LSnowData
    typeName = getOne(LSnowData, lType)
    case typeName of
      #flurry:
        fore = 1
        mid = 2
        back = 2
      #snowball:
        fore = 2
        mid = 4
        back = 4
      #snowman:
        fore = 3
        mid = 6
        back = 6
    end case
    repeat with i = 1 to fore
      add(lType.onSprs, LSnowSprs.fore[i])
    end repeat
    repeat with i = fore + 1 to count(LSnowSprs.fore)
      add(lType.offSprs, LSnowSprs.fore[i])
    end repeat
    repeat with i = 1 to mid
      add(lType.onSprs, LSnowSprs.mid[i])
    end repeat
    repeat with i = mid + 1 to count(LSnowSprs.mid)
      add(lType.offSprs, LSnowSprs.mid[i])
    end repeat
    repeat with i = 1 to back
      add(lType.onSprs, LSnowSprs.back[i])
    end repeat
    repeat with i = back + 1 to count(LSnowSprs.back)
      add(lType.offSprs, LSnowSprs.back[i])
    end repeat
  end repeat
end

on Dispose me
  repeat with obj in LSnowObjs
    if objectp(obj) then
      Dispose(obj)
    end if
  end repeat
  LSnowObjs = []
end

on Init me
  mFillDataStrucs(me)
  LSnowObjs = [:]
  repeat with lLayer in LSnowSprs
    layerName = getOne(LSnowSprs, lLayer)
    repeat with spr in lLayer
      obj = new(script("Anim Snow Obj SubClass"), me, spr, layerName)
      addProp(LSnowObjs, spr, obj)
    end repeat
  end repeat
  SetState(me, #Ready)
end

on InitTiming me
  mSetTimer(me, #Seq)
end

on mSetTimer me, whichKind
  case whichKind of
    #Seq:
      pickOne = random(6)
      case pickOne of
        1:
          NextTime = the milliSeconds + ((30 + random(270)) * 1000)
        otherwise:
          NextTime = the milliSeconds + (1 * 60 * 1000)
      end case
    #type:
      NextTime = the milliSeconds + ((30 + random(20)) * 1000)
  end case
  return NextTime
end

on GetData me, intensity
  LSeqData = duplicate(LAllSnowSeqs[random(count(LAllSnowSeqs))])
  if intensity then
    intensityID = mCoerceIntensity(me, intensity)
    case intensityID of
      #flurry:
        LSeqData = [#flurry]
      #snowball:
        LSeqData = [#flurry, #snowball, #flurry]
      #snowman:
        LSeqData = [#flurry, #snowball, #snowman, #snowball, #flurry]
    end case
  end if
  GetNextSequence(me)
end

on GetNextSequence me
  if LSeqData <> [] then
    CurSnowType = LSeqData[1]
    deleteAt(LSeqData, 1)
  else
    return 0
  end if
  SeqLog.add(CurSnowType)
  return 1
end

on start me, intensity, overRideFlag
  SetState(me, #Starting)
  GetData(me, intensity)
  ProbOverride = goDiorama.ProbOverride
  mStartSnowObjs(me)
  mSetTimer(me, #type)
  SetState(me, #playing)
  mSnowStart(goDiorama)
  return 1
end

on mStartSnowObjs me
  repeat with spr in LSnowData[CurSnowType].onSprs
    start(getaProp(LSnowObjs, spr))
  end repeat
  repeat with spr in LSnowData[CurSnowType].offSprs
    mFinish(getaProp(LSnowObjs, spr))
  end repeat
end

on stop me, clearFlag
  if not clearFlag then
    repeat with obj in LSnowObjs
      mFinish(obj)
    end repeat
    SetState(me, #finish)
  else
    Dispose(me)
    Init(me)
    InitTiming(me)
    SetState(me, #Ready)
  end if
end

on mRefreshData me, intensity, duration
end

on pause me
  SavedState = State
  SetState(me, #Paused)
end

on Resume me
  SetState(me, SavedState)
  NextTime = max(NextTime, the milliSeconds)
end

on Thread me
  case State of
    #Starting:
    #Ready:
      if the milliSeconds > NextTime then
        if mCheckSnowStart(goDiorama) then
          InitTiming(me)
          start(me)
        end if
      end if
    #playing:
      if the milliSeconds > NextTime then
        Change(me, #next)
      end if
      repeat with obj in LSnowObjs
        Thread(obj)
      end repeat
    #finish:
      vote = 1
      repeat with obj in LSnowObjs
        vote = vote and (obj.State = #Ready)
        if not vote then
          exit repeat
        end if
      end repeat
      if vote then
        mSnowStop(goDiorama)
        SetState(me, #Ready)
        mSetTimer(me, #Seq)
      else
        repeat with obj in LSnowObjs
          Thread(obj)
        end repeat
      end if
    #Paused:
  end case
end

on PlayNextFrame me
end

on Change me, intensity
  CurSnowType = mCoerceIntensity(me, intensity)
  if voidp(CurSnowType) then
    stop(me)
    exit
  end if
  mStartSnowObjs(me)
  mSnowChange(goDiorama, CurSnowType)
  mSetTimer(me, #type)
end

on SetState me, newState
  thisTime = (the milliSeconds - TimeOrigin) / 1000
  StateLog.addProp(newState, thisTime)
  State = newState
end

on mCoerceIntensity me, tag
  case ilk(tag) of
    #integer:
      tag = max(min(tag, 100), 0)
      if tag < 33 then
        type = #flurry
      else
        if tag < 66 then
          type = #snowball
        else
          type = #snowman
        end if
      end if
    #symbol:
      case tag of
        #flurry, #Low:
          type = #flurry
        #snowball, #med:
          type = #snowball
        #snowman, #High:
          type = #snowman
        #next:
          if GetNextSequence(me) then
            type = CurSnowType
          else
            type = VOID
          end if
      end case
  end case
  return type
end
