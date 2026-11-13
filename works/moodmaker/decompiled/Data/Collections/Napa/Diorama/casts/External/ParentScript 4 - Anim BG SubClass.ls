property name, UseIntensityFactoring, intensityID, State, StateLog, frame, PlaceholderMbr, spr, InkEffect, OffsetX, OffsetY, Fade, blend, LSeqs, SeqData, SeqLog, TimeOrigin, Blockers, IsDebugMode, AutoStart
global goDiorama, goK

on new me
  name = #Background
  TimeOrigin = the milliSeconds
  PlaceholderMbr = member("_placeholder dot", goK.iLibNumCollDio)
  return me
end

on Dispose me
  setSprProps(spr, [#mbr: PlaceholderMbr, #loc: point(-500, -500)], 0)
end

on Init me
  StateLog = [:]
  SetState(me, #Starting)
  Config = value(member(string(name), goK.iLibNumCollDio).text)
  ErrorCheck(Config, listp(Config), "Bad config field for Anim: " & name)
  Blockers = Config.Blockers
  spr = sprite(Config.sprNum)
  InkEffect = Config.InkEffect
  spr.blend = Config.blend
  OffsetX = Config.OffsetX
  OffsetY = Config.OffsetY
  AutoStart = Config.AutoStart
  GetData(me)
  GetNextSequence(me, 1)
  setSprProps(spr, [#mbr: member(SeqData.frames[1], goK.iLibNumCollDio), #loc: point(goDiorama.XCoord + OffsetX, goDiorama.YCoord + OffsetY), #ink: InkEffect], 0)
end

on InitTiming me, data
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
  ProbOverride = goDiorama.ProbOverride
  repeat with thisBlocker in Blockers
    if getOne(goDiorama.GetAnims(#playing), thisBlocker) then
      return 0
    end if
  end repeat
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
end

on GetNextSequence me, initFlag, seqName
  if initFlag then
    frame = 0
    SeqData = LSeqs[1]
    SeqLog = [SeqData.name]
  end if
  ErrorCheck(SeqData, listp(SeqData), "Bad sequence LSeqs. Name: " & name)
  if SeqData.UsePreloading then
    PreloadMembers(SeqData.frames, goK.iLibNumCollDio)
  end if
end

on Thread me
  case State of
    #Starting:
    #Ready:
    #playing:
  end case
end

on pause me
end

on Resume me
end

on UpdateLoc me
  spr.loc = point(goDiorama.XCoord + OffsetX, goDiorama.YCoord + OffsetY)
end

on SetState me, newState
  thisTime = (the milliSeconds - TimeOrigin) / 1000
  StateLog.addProp(newState, thisTime)
  State = newState
end
