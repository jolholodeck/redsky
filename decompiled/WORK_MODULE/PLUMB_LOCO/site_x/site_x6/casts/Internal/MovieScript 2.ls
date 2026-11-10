global kPi, k2pi

on getHyp delta
  set a to float(getAt(delta, 1))
  set b to float(getAt(delta, 2))
  return sqrt((a * a) + (b * b))
end

on insideCircle hitPt, centerPt, radius
  return getHyp(hitPt - centerPt) < radius
end

on insideRegion spr
  global gCurCursor
  set curs to gCurCursor
  if not rollOver(spr) then
    return 0
  end if
  hideCursor()
  updateStage()
  set oldInk to the ink of sprite spr
  set isPuppet to the puppet of sprite spr
  puppetSprite(spr, 1)
  set the ink of sprite spr to 8
  updateStage()
  set hit to rollOver() = spr
  set the ink of sprite spr to oldInk
  if not isPuppet then
    puppetSprite(spr, 0)
  end if
  setCursor(curs)
  updateStage()
  return hit
end

on constrainPoint pt, rect
  if inside(pt, rect) then
    return pt
  end if
  set L to getAt(rect, 1)
  set t to getAt(rect, 2)
  set r to getAt(rect, 3)
  set b to getAt(rect, 4)
  return point(min(max(getAt(pt, 1), L), r), min(max(getAt(pt, 2), t), b))
end

on slopeToAngle delta
  set u to float(getAt(delta, 1))
  set i to float(getAt(delta, 2))
  if u = 0 then
    return (PI / 2) + (PI * (i < 0))
  end if
  if i = 0 then
    return PI * (u < 0)
  end if
  set angle to atan(i / u)
  if u < 0 then
    return PI + angle
  end if
  if angle < 0 then
    return (2 * PI) + angle
  end if
  if angle > (2 * PI) then
    return angle - (2 * PI)
  end if
  return angle
end

on angleToSlope angle
  return list(cos(angle), sin(angle))
end

on vectToSlope V
  set angle to getAt(V, 1)
  set m to getAt(V, 2)
  return list(cos(angle) * m, sin(angle) * m)
end

on slopeToVect delta
  return list(slopeToAngle(delta), getHyp(delta))
end

on degToRad d
  return d * 0.01745
end

on radToDeg r
  return r * 57.29581999999999908
end

on addvector V, w
  return slopeToVect(vectToSlope(V) + vectToSlope(w))
end

on symAngle angle, s
  if s = #V then
    set angle to PI - angle
  else
    set angle to (2 * PI) - angle
  end if
  return angle
end

on dotProduct V, w
  set m to V * w
  return getAt(m, 1) + getAt(m, 2)
end

on splitVector V, w
  set p to dotProduct(V, w) * 1.0
  set h to getAt(w, 1)
  set V to getAt(w, 2)
  set L to (h * h) + (V * V)
  if L = 0 then
    set L to 1
  end if
  set a to w * (p / L)
  set e to V - a
  setAt(a, 1, integer(getAt(a, 1)))
  setAt(a, 2, integer(getAt(a, 2)))
  setAt(e, 1, integer(getAt(e, 1)))
  setAt(e, 2, integer(getAt(e, 2)))
  return list(a, e)
end

on collide p, q, V, w
  set e to p - q
  set a to point(getAt(e, 2), -getAt(e, 1))
  set x to splitVector(V, a)
  set y to splitVector(w, a)
  return list(getAt(x, 1) + getAt(y, 2), getAt(y, 1) + getAt(x, 2))
end

on plotParabole dx, dy, nbSteps
  set dx to dx * 1.0
  set dy to dy * 1.0
  if dx = 0 then
    set dx to 1.0
  end if
  if dy = 0 then
    set dy to 1.0
  end if
  set nbSteps to nbSteps * 1.0
  set totalSteps to (nbSteps * 2) + 1
  set fourP to dx * dx / dy
  set inc to abs(dx / nbSteps)
  set out to []
  if dx < 0 then
    set curX to dx
    repeat with x = 1 to totalSteps
      set curY to curX * curX / fourP
      add(out, point(curX, curY))
      set curX to curX + inc
    end repeat
  else
    set curX to dx
    repeat with x = 1 to totalSteps
      set curY to curX * curX / fourP
      add(out, point(curX, curY))
      set curX to curX - inc
    end repeat
  end if
  setAt(out, totalSteps, point(-dx, dy))
  return out
end

on plotLinearPath startLoc, endLoc, nbSteps
  set delta to endLoc - startLoc
  set dx to getAt(delta, 1) + 0.0
  set dy to getAt(delta, 2) + 0.0
  set stepX to dx / nbSteps
  set stepY to dy / nbSteps
  set path to []
  add(path, startLoc)
  set curX to getAt(startLoc, 1)
  set curY to getAt(startLoc, 2)
  set curLoc to startLoc
  repeat with x = 1 to nbSteps - 2
    set curX to curX + stepX
    set curY to curY + stepY
    add(path, point(integer(curX), integer(curY)))
  end repeat
  add(path, endLoc)
  return path
end

on flipAngle angle
  return (integer(angle * 1000) + 3142) mod 6284 / 1000.0
end

on turnToAngle curAngle, destAngle, tolerance
  if curAngle > destAngle then
    if (curAngle - destAngle) < tolerance then
      return 0
    end if
  else
    if (destAngle - curAngle) < tolerance then
      return 0
    end if
  end if
  set oppAngle to curAngle + kPi
  if oppAngle > (2 * kPi) then
    set oppAngle to oppAngle - (2 * kPi)
  end if
  if curAngle > kPi then
    if (destAngle > curAngle) or (destAngle < oppAngle) then
      return 1
    else
      return -1
    end if
  else
    if (destAngle < curAngle) or (destAngle > oppAngle) then
      return -1
    else
      return 1
    end if
  end if
end

on wrapAngle angle
  if angle < 0 then
    set angle to angle + k2pi
  end if
  return integer(angle * 1000) mod 6283 / 1000.0
end
