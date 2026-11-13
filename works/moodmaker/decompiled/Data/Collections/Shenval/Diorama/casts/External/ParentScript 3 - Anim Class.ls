property name, MasterStartProb, CurStartProb, UseIntensityFactoring, intensityID, State, StateLog, frame, PlaceholderMbr, spr, InkEffect, OffsetX, OffsetY, Fade, blend, LSeqs, CurSeq, SeqData, SeqLog, FPS, FpsLow, FpsMedium, FpsHigh, NextTime, TimeOrigin, Blockers, IsDebugMode, AutoStart
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
  SetState(me, #Starting)
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
  GetData(me)
  GetNextSequence(me, 1)
  if (name = #branches) or (name = #Cloud) then
    setSprProps(spr, [#mbr: member(SeqData.frames[1], goK.iLibNumCollDio), #loc: point(goDiorama.XCoord + OffsetX, goDiorama.YCoord + OffsetY), #ink: InkEffect], 0)
  end if
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
      ErrorCheck(ilk(value(txt)), ilk(value(txt)) = #list, "Bad author-time anim Seqs for " & name)
      member(string(name) & " Seqs", goK.iLibNumCollDio).text = txt
      LSeqs = value(txt)
    #RunTime:
      LSeqs = value(member(name & " Seqs", goK.iLibNumCollDio).text)
      ErrorCheck(LSeqs, listp(LSeqs), "Bad runtime anim Seqs for " & name)
  end case
  ErrorCheck(LSeqs, listp(LSeqs), "Bad Seqs for Anim: " & name)
  SetState(me, #Ready)
end

on start me, intensity, overRideFlag
  GetData(me)
  ProbOverride = goDiorama.ProbOverride
  repeat with thisBlocker in Blockers
    if getOne(goDiorama.GetAnims(#playing), thisBlocker) then
      return 0
    end if
  end repeat
  GetNextSequence(me, 1)
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
  spr.blend = blend
  SetState(me, #playing)
  return 1
end

on stop me, clearFlag
  if not clearFlag then
    if (SeqData = LSeqs[1]) and (frame = 0) then
      SetState(me, #Ready)
    else
      case name of
        otherwise:
          lastSeq = LSeqs[LSeqs.count]
          lastSeqNext = lastSeq.next
          lastSeq.next = 0
      end case
    end if
  else
    Dispose(me)
    Init(me)
    InitTiming(me)
  end if
end

on GetNextSequence me, initFlag, seqName
  if initFlag then
    frame = 0
    if name = #worker then
      SeqData = LSeqs[random(LSeqs.count)]
    else
      SeqData = LSeqs[CurSeq]
    end if
    SeqLog = [SeqData.name]
  else
    if voidp(seqName) then
      if SeqData.next = 0 then
        if name = #worker then
          CurSeq = random(LSeqs.count)
        else
          CurSeq = 1
        end if
        SeqData = []
        spr.loc = point(-500, -500)
        SetState(me, #Ready)
        exit
      end if
      if listp(SeqData.next) then
        distrib = SeqData.next
        NextSeq = WeightedDistribution(distrib)
        if (name = #worker) and (NextSeq = #stop) then
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

on pause me
end

on Resume me
  NextTime = max(NextTime, the milliSeconds)
end

on Thread me
  case State of
    #Starting:
      nothing()
    #Ready:
      nothing()
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
  totalFrames = SeqData.frames.count
  frame = frame + 1
  if frame > totalFrames then
    NextTime = the milliSeconds + (RandomRange(SeqData.MinDelay, SeqData.MaxDelay) * 1000)
    if (name = #worker) or (name = #branches) then
      mSetFPS(me)
    end if
    GetNextSequence(me)
    exit
  end if
  case SeqData.Fade of
    #in:
      inc = 100 / float(totalFrames)
      blend = min(100, blend + inc)
      spr.blend = blend
    #out:
      inc = 100 / float(totalFrames)
      blend = max(0, blend - inc)
      spr.blend = blend
  end case
  if goDiorama.GetState() <> #Paused then
    setSprProps(spr, [#mbr: member(SeqData.frames[frame], goK.iLibNumCollDio), #ink: InkEffect, #loc: point(goDiorama.XCoord + OffsetX, goDiorama.YCoord + OffsetY)], 0)
  end if
end

on Change me, intensity
  intensityID = mCoerceIntensity(me, intensity)
  case name of
    #branches, #Flock, #worker:
      mSetFPS(me, name)
    otherwise:
      case intensityID of
        #Low:
          FPS = FpsLow
        #med:
          FPS = FpsMedium
        #High:
          FPS = FpsHigh
      end case
  end case
  if UseIntensityFactoring then
    mUpdateStartProb(me, intensityID)
  end if
end

on mSetFPS me
  case name of
    #branches:
      case intensityID of
        #Low:
          FPS = FpsLow + (random(7) - 1)
        #med:
          FPS = FpsMedium + (random(13) - 1)
        #High:
          FPS = FpsHigh + (random(7) - 1)
      end case
    #Flock:
      FPS = FpsMedium + (random(7) - 1)
    #worker:
      case intensityID of
        #Low:
          FPS = FpsLow + random(3) - 1
        #med:
          FPS = FpsMedium + random(3) - 1
        #High:
          FPS = FpsHigh
      end case
  end case
end

on UpdateLoc me
  spr.loc = point(goDiorama.XCoord + OffsetX, goDiorama.YCoord + OffsetY)
end

on SetState me, newState
  thisTime = (the milliSeconds - TimeOrigin) / 1000
  StateLog.addProp(newState, thisTime)
  State = newState
end

on mRefreshData me, intensity, duration
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
