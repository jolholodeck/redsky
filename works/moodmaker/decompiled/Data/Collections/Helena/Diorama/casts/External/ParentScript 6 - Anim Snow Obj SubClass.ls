property layer, SnowMgr, StageWidth, StageHeight, sprNum, mbr, PlaceholderMbr, MbrFlakeXL, State, StateLog, NextTime, FPS, TimeOrigin, XOffset, YOffset, XCoord, YCoord, ScaleFactor, XInput, YIncr, Dir, MvmntFactor
global goDiorama, goK, gDebug

on new me, obj, spr, layerType
  SnowMgr = obj
  sprNum = spr
  layer = layerType
  PlaceholderMbr = SnowMgr.PlaceholderMbr
  FPS = SnowMgr.LLayerData[layer].FPS
  ScaleFactor = SnowMgr.LLayerData[layer].ScaleFactor
  case layer of
    #mid, #back:
      MvmntFactor = 1.5 * ScaleFactor
    #fore:
      MvmntFactor = 2 * ScaleFactor
  end case
  Dir = [-1, 1][random(2)]
  XInput = 0
  YIncr = 3 * ScaleFactor
  mbr = SnowMgr.LLayerData[layer].mbr
  MbrFlakeXL = member("snowflake_XL", goK.iLibNumCollDio)
  StateLog = [:]
  TimeOrigin = the milliSeconds
  SetState(me, #Ready)
  return me
end

on Dispose me
  setSprProps(sprNum, [#mbr: PlaceholderMbr, #loc: point(-500, -500), #rotation: 0, #flipH: 0, #flipV: 0, #stretch: 0, #visible: 1], 0)
end

on start me
  if State = #playing then
    exit
  end if
  bgRect = sprite(goDiorama.LAnimObjs.Background.spr).rect
  XOffset = bgRect[1]
  YOffset = bgRect[2]
  StageWidth = bgRect[3] - bgRect[1]
  StageHeight = bgRect[4] - bgRect[2]
  mPickStartPsn(me)
  if layer = #fore then
    case random(3) of
      1:
        whichMbr = MbrFlakeXL
      otherwise:
        whichMbr = mbr
    end case
    setSprProps(sprNum, [#loc: point(XCoord, YCoord), #mbr: whichMbr, #ink: #bgTrans, #visible: 0], 0)
  else
    sprH = member(mbr).height * ScaleFactor
    sprW = member(mbr).width * ScaleFactor
    setSprProps(sprNum, [#loc: point(XCoord, YCoord), #mbr: mbr, #height: sprH, #width: sprW, #ink: #bgTrans, #visible: 0], 0)
  end if
  NextTime = the milliSeconds + (1000 / float(FPS))
  SetState(me, #playing)
end

on mPickStartPsn me
  XInput = 0
  XCoord = random(StageWidth) + XOffset
  case sprNum mod 6 of
    1:
      horizBandNudge = -1 * (random(5) + 30)
    2:
      horizBandNudge = -1 * (random(5) + 35)
    3:
      horizBandNudge = -1 * (random(7) + 40)
    4:
      horizBandNudge = -1 * (random(8) + 47)
    5:
      horizBandNudge = -1 * (random(7) + 55)
    6:
      horizBandNudge = -1 * (random(8) + 62)
  end case
  YCoord = horizBandNudge + YOffset
  flipH = random(2) - 1
  flipV = random(2) - 1
  setSprProps(sprNum, [#flipH: flipH, #flipV: flipV], 0)
end

on mFinish me
  case State of
    #Ready:
      exit
    #playing:
      SetState(me, #finish)
  end case
end

on Thread me
  case State of
    #Ready:
    #playing, #finish:
      if the milliSeconds > NextTime then
        PlayNextFrame(me)
        NextTime = the milliSeconds + (1000 / float(FPS - random(4) + 1))
      end if
  end case
end

on PlayNextFrame me
  if YCoord > ((StageHeight * ScaleFactor) + YOffset + 10) then
    case State of
      #playing:
        mPickStartPsn(me)
        if layer = #fore then
          case random(3) of
            1:
              whichMbr = MbrFlakeXL
            otherwise:
              whichMbr = mbr
          end case
          setSprProps(sprNum, [#mbr: whichMbr], 0)
        end if
      #finish:
        SetState(me, #Ready)
        setSprProps(sprNum, [#flipH: 0, #flipV: 0, #mbr: PlaceholderMbr, #loc: point(-500, -500), #stretch: 0, #visible: 1], 0)
        exit
    end case
  else
    XCoord = XCoord + (Dir * sin(XInput) * MvmntFactor)
    case layer of
      #mid, #back:
        XInput = XInput + 0.10000000000000001
      #fore:
        XInput = XInput + 0.20000000000000001
    end case
    YCoord = YCoord + YIncr
    newBlend = 100
    case layer of
      #mid, #back:
        if YCoord > ((StageHeight * ScaleFactor) + YOffset) then
          newBlend = max(sprite(sprNum).blend - 20, 0)
        end if
      #fore:
    end case
    if YCoord > (YOffset + 10) then
      myVisible = 1
    end if
  end if
  setSprProps(sprNum, [#loc: point(XCoord, YCoord), #blend: newBlend, #visible: myVisible], 0)
end

on SetState me, newState
  thisTime = (the milliSeconds - TimeOrigin) / 1000
  StateLog.addProp(newState, thisTime)
  State = newState
end
