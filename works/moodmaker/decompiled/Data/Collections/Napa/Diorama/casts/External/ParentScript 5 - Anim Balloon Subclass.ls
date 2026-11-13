property ancestor, Velocity, fadeIn, fadeOut, FadeIncrement, initFlag, InitialX, InitialY, MaxBlend
global goDiorama, goK

on new me, animName
  ancestor = script("Anim Class").new(animName)
  Velocity = 1
  fadeIn = 260
  fadeOut = 260
  FadeIncrement = 3
  initFlag = 1
  return me
end

on PlayNextFrame me
  if initFlag then
    InitialX = ancestor.OffsetX
    InitialY = ancestor.OffsetY
    MaxBlend = ancestor.spr.blend
    ancestor.spr.blend = 1
    initFlag = 0
  end if
  if the milliSeconds < ancestor.NextTime then
    exit
  end if
  ancestor.NextTime = the milliSeconds + (1000 / ancestor.FPS)
  ancestor.frame = ancestor.frame + 1
  if ancestor.frame > ancestor.SeqData.frames.count then
    ancestor.GetNextSequence()
    ancestor.frame = 0
    ancestor.NextTime = the milliSeconds
    ancestor.OffsetX = ancestor.OffsetX + Velocity
    if (ancestor.OffsetX > 340) or (ancestor.spr.blend = 0) then
      ancestor.spr.blend = 1
      ancestor.OffsetX = InitialX
      ancestor.SetState(#Ready)
      exit
    end if
    if ancestor.OffsetX < fadeIn then
      ancestor.spr.blend = min(MaxBlend, ancestor.spr.blend + FadeIncrement)
    end if
    if ancestor.OffsetX > fadeOut then
      ancestor.spr.blend = max(0, ancestor.spr.blend - FadeIncrement)
    end if
    exit
  end if
  ancX = ancestor.OffsetX
  ancY = ancestor.OffsetY
  setSprProps(ancestor.spr, [#mbr: member(ancestor.SeqData.frames[ancestor.frame], goK.iLibNumCollDio), #loc: point(goDiorama.XCoord + ancestor.OffsetX, goDiorama.YCoord + ancestor.OffsetY)], 0)
end

on stop me
  ancestor.spr.blend = 0
  ancestor.stop()
end

on Dispose me
  setSprProps(ancestor.spr, [#mbr: ancestor.PlaceholderMbr, #loc: point(-500, -500)], 0)
end
