property name, MasterStartProb, CurStartProb, ProbOverride, UseIntensityFactoring, intensityID, State, StateLog, frame, PlaceholderMbr, spr, InkEffect, OffsetX, OffsetY, Fade, blend, LSeqs, CurSeq, SeqData, SeqLog, FPS, NextTime, FpsLow, FpsMedium, FpsHigh, TimeOrigin, Blockers, IsDebugMode, AutoStart, IsClickable
global goDiorama, goK

on new me, whichAnim
  name = whichAnim
  TimeOrigin = the milliSeconds
  PlaceholderMbr = member("_placeholder dot", goK.iLibNumCollDio)
  return me
end

on Dispose me
  setSprProps(spr, [#mbr: member("_placeholder dot", goK.iLibNumCollDio), #loc: point(-500, -500)], 0)
end

on Init me
  StateLog = [:]
  me.SetState(#Starting)
  Config = value(member(string(name), goK.iLibNumCollDio).text)
  ErrorCheck(Config, listp(Config), "Bad config field for Anim: " & name)
  Blockers = Config.Blockers
  MasterStartProb = Config.StartProb
  CurStartProb = MasterStartProb
  UseIntensityFactoring = Config.UseIntensityFactoring
  CurSeq = Config.CurSeq
  spr = sprite(Config.sprNum)
  InkEffect = Config.InkEffect
  spr.blend = Config.blend
  OffsetX = Config.OffsetX
  OffsetY = Config.OffsetY
  spr.loc = point(goDiorama.XCoord + OffsetX, goDiorama.YCoord + OffsetY)
  AutoStart = Config.AutoStart
  me.GetData()
  me.GetNextSequence(1)
end

on InitTiming me, data
  Config = value(member(string(name), goK.iLibNumCollDio).text)
  ErrorCheck(Config, listp(Config), "Bad config field for Anim: " & name)
  FpsLow = Config.FpsLow
  FpsMedium = Config.FpsMedium
  FpsHigh = Config.FpsHigh
  FPS = Config.FpsMedium
  NextTime = the milliSeconds
end

on GetData me
  case goDiorama.mode of
    #AuthorTime:
      txt = "["
      Sequences = GetSequences(spr, "Anim Seq")
      ErrorCheck(Sequences, Sequences.count <> 0, "No anim Seqs behaviors on " & name)
      repeat with thisSeq in Sequences
        theseProps = extractProps(thisSeq)
        ErrorCheck(theseProps, listp(theseProps), "Bad sequence found")
        txt = txt & theseProps
        if thisSeq <> Sequences[Sequences.count] then
          txt = txt & ","
        end if
      end repeat
      txt = txt & "]"
      ErrorCheck(ilk(value(txt)), ilk(value(txt)) = #list, "Bad author-time anim LSeqs for " & name)
      member(string(name) & " Seqs", goK.iLibNumCollDio).text = txt
      LSeqs = value(txt)
    #RunTime:
      LSeqs = value(member(name & " Seqs", goK.iLibNumCollDio).text)
      ErrorCheck(LSeqs, listp(LSeqs), "Bad runtime anim LSeqs for " & name)
  end case
  ErrorCheck(LSeqs, listp(LSeqs), "Bad LSeqs for Anim: " & name)
  me.SetState(#Ready)
end

on start me, duration, intensity, overRideFlag
  if name = #tractor then
  end if
  me.GetData()
  ProbOverride = goDiorama.ProbOverride
  lAnimsPlaying = goDiorama.GetAnims(#playing)
  repeat with thisBlocker in Blockers
    if getOne(lAnimsPlaying, thisBlocker) then
      return 0
    end if
  end repeat
  me.GetNextSequence(1)
  NextTime = the milliSeconds
  if not voidp(intensity) then
    Change(me, intensity)
  end if
  if not ProbOverride then
    if not overRideFlag then
      roll = random(100)
      if CurStartProb < roll then
        return 0
      end if
    end if
  end if
  thisFade = SeqData.Fade
  case SeqData.Fade of
    #in:
      blend = 0
    #out:
      blend = 100
    #none:
      blend = 100
  end case
  if not string(name) contains "balloon" then
    spr.blend = blend
  end if
  me.SetState(#playing)
  return 1
end

on stop me
  if (SeqData = LSeqs[1]) and (frame = 0) then
    me.SetState(#Ready)
  else
    case name of
      #Windmill, #Leaves:
        SeqData.next = 0
      #rain, #Rain1, #Rain2, #Rain3:
        me.GetNextSequence(0, #Extro)
      otherwise:
        lastSeq = LSeqs[LSeqs.count]
        lastSeqNext = lastSeq.next
        lastSeq.next = 0
    end case
  end if
end

on GetNextSequence me, initFlag, seqName
  if initFlag then
    frame = 0
    SeqData = LSeqs[CurSeq]
    SeqLog = [SeqData.name]
  else
    if voidp(seqName) then
      if SeqData.next = 0 then
        CurSeq = 1
        SeqData = []
        spr.loc = point(-500, -500)
        SetState(me, #Ready)
        if name = #tractor then
          EndOfLap(me)
        end if
        exit
      end if
      if listp(SeqData.next) then
        distrib = SeqData.next
        NextSeq = WeightedDistribution(distrib)
        if (name = #Ladybug) and (NextSeq = #stop) then
          SeqData.next = 0
          GetNextSequence(me)
          exit
        end if
      else
        NextSeq = SeqData.next
      end if
    else
      NextSeq = seqName
    end if
    repeat with thisSeq in LSeqs
      if thisSeq.name = NextSeq then
        SeqData = thisSeq
        exit repeat
      end if
    end repeat
  end if
  ErrorCheck(SeqData, listp(SeqData), "Bad sequence LSeqs. Name: " & name & " CurSeq: " & CurSeq)
  if SeqData.UsePreloading then
    PreloadMembers(SeqData.frames, goK.iLibNumCollDio)
  end if
  frame = 0
  SeqLog.add(SeqData.name)
end

on pause me, flag
end

on Resume me, flag
  NextTime = max(NextTime, the milliSeconds)
end

on Thread me
  case State of
    #Starting:
    #Ready:
    #Paused:
    #playing:
      PlayNextFrame(me)
  end case
end

on PlayNextFrame me
  if the milliSeconds < NextTime then
    exit
  end if
  Wait = 1000 / float(FPS)
  NextTime = the milliSeconds + Wait
  frame = frame + 1
  totalFrames = SeqData.frames.count
  if frame > totalFrames then
    if (name = #Leaves) and (intensityID = #High) then
      NextTime = the milliSeconds
      if SeqData.next = 0 then
        GetNextSequence(me, 0, #still)
      else
        GetNextSequence(me)
      end if
    else
      if (name = #rain) and (SeqData.name = #still) then
        mStartRain(goDiorama)
      end if
      NextTime = the milliSeconds + (RandomRange(SeqData.MinDelay, SeqData.MaxDelay) * 1000)
      GetNextSequence(me)
    end if
    exit
  end if
  case SeqData.Fade of
    #in:
      totalFrames = SeqData.frames.count
      inc = 100 / float(SeqData.frames.count)
      blend = min(100, blend + inc)
      spr.blend = blend
    #out:
      totalFrames = SeqData.frames.count
      inc = 100 / float(SeqData.frames.count)
      blend = max(0, blend - inc)
      spr.blend = blend
  end case
  if goDiorama.GetState() <> #Paused then
    setSprProps(spr, [#mbr: member(SeqData.frames[frame], goK.iLibNumCollDio), #ink: InkEffect, #loc: point(goDiorama.XCoord + OffsetX, goDiorama.YCoord + OffsetY)], 0)
  end if
end

on Change me, intensity
  case name of
    #tractor:
      exit
  end case
  intensityID = mCoerceIntensity(me, intensity)
  case intensityID of
    #Low:
      FPS = FpsLow
    #med:
      FPS = FpsMedium
    #High:
      FPS = FpsHigh
  end case
  if UseIntensityFactoring then
    mUpdateStartProb(me, intensityID)
  end if
end

on UpdateLoc me
  spr.loc = point(goDiorama.XCoord + OffsetX, goDiorama.YCoord + OffsetY)
end

on SetState me, newState
  if (name = #tractor) and (newState = #Ready) then
  end if
  thisTime = (the milliSeconds - TimeOrigin) / 1000
  StateLog.addProp(newState, thisTime)
  State = newState
end

on mRefreshData me, duration
  case name of
    #Leaves, #Windmill, #Grass:
      start(me, duration)
    #rain, #Rain1, #Rain2, #Rain3:
      secondSeq = LSeqs[1].next
      GetNextSequence(me, 0, secondSeq)
  end case
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
      case int of
        #Low:
          intensityID = #Low
        #med:
          intensityID = #med
        #High:
          intensityID = #High
        otherwise:
          intensityID = #med
      end case
    otherwise:
      intensityID = #med
  end case
  return intensityID
end

on mUpdateStartProb me, intensityID
  case intensityID of
    #Low:
      CurStartProb = max(0, MasterStartProb - (MasterStartProb / 2))
    #med:
      CurStartProb = MasterStartProb
    #High:
      CurStartProb = min(100, MasterStartProb + (MasterStartProb / 2))
  end case
end
