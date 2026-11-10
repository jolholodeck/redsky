global gCanShoot, gSpritePutter, gSpriteBall, gBlank, gBallDirection, gBallSpeed, gBallIsMoving, gMyDist, gDirectionList, gSpeedList, gWhichFoot, gSpriteCourse, gSpriteFakeBall, gDoesBounce, gSpriteHole, gSpriteListWater, gSpriteListSand, gSpriteFairway, gSpriteRightFoot, gSpriteLeftFoot, gSpriteTigerLeftFoot, gSpriteTigerRightFoot, gStepTime, gTigerTime, gTigerIsWalking, gSpriteRollover1, gSpriteRollover2, gIsOnRollOver, gBallStart, gBallShoot, gSpriteNextHole, gSpriteTigerTalk, gSpriteText, gIdleTime, gTigerSpoke, gIdleSuspended

on startMovie
  cursor(200)
  setGlobals()
  set gIdleSuspended to 0
  set the keyDownScript to "demoExitKey()"
end

on demoExitKey
  if (the key = RETURN) or (the key = ENTER) then
    set gIdleSuspended to 1
    ReturnToWork()
    abort()
  end if
end

on setGlobals
  set gTigerTime to 0
  set gStepTime to 0
  set gDirectionList to list([0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1])
  set gMyDist to 0
  set gWhichFoot to 1
  set gDoesBounce to 0
  set gSpeedList to list()
  set gCanShoot to 0
  set gBlank to 10
  set gBallDirection to 0
  set gBallSpeed to 0
  set gBallIsMoving to 0
  set gTigerIsWalking to 0
  set gIsOnRollOver to 0
  set gIdleTime to the timer + 100
  set gTigerSpoke to 0
  set gSpriteText to 24
  set gSpriteTigerTalk to 36
  set gSpriteRightFoot to 32
  set gSpriteLeftFoot to 33
  set gSpriteTigerLeftFoot to 34
  set gSpriteTigerRightFoot to 35
  set gSpriteListSand to list(17, 18)
  set gSpriteListWater to list()
  set gSpriteFairway to 16
  set gSpritePutter to 25
  set gSpriteCourse to 15
  set gSpriteBall to 23
  set gSpriteFakeBall to 9
  set gSpriteHole to 21
  set gSpriteRollover1 to 27
  set gSpriteRollover2 to 28
  set gSpriteNextHole to 26
end

on shootBall
  if gBallIsMoving then
    return 
  end if
  set gBallShoot to the loc of sprite gSpriteBall
  set gIdleTime to the timer + 60000
  set the visible of sprite gSpriteText to 0
  set the visible of sprite gSpriteTigerTalk to 0
  set gBallIsMoving to 1
  setBallDirection("putt")
  put gBallDirection
  set gBallSpeed to gMyDist * 5
  if not (sprite gSpriteBall intersects sprite(gSpriteFairway)) then
    set gBallSpeed to integer(gBallSpeed / 2)
    puppetSound(1, 13)
  else
    puppetSound(1, 17)
  end if
  buildRollList()
  movePutter()
  updateStage()
  moveBall()
  repeat while gDoesBounce
    moveBall()
  end repeat
end

on buildRollList
  set gSpeedList to list()
  append(gSpeedList, gBallSpeed * 2)
  repeat while gBallSpeed > 1
    append(gSpeedList, gBallSpeed)
    set gBallSpeed to gBallSpeed - 1
  end repeat
  repeat with x = 1 to 10
    append(gSpeedList, gBallSpeed)
  end repeat
end

on setBallDirection fromWhere
  if fromWhere = "putt" then
    if the castNum of sprite gSpritePutter = 5 then
      if the locV of sprite gSpritePutter < the locV of sprite gSpriteBall then
        set gBallDirection to 5
      else
        set gBallDirection to 1
      end if
    else
      if the castNum of sprite gSpritePutter = 6 then
        if the locV of sprite gSpritePutter > the locV of sprite gSpriteBall then
          set gBallDirection to 2
        else
          set gBallDirection to 6
        end if
      else
        if the castNum of sprite gSpritePutter = 7 then
          if the locH of sprite gSpritePutter > the locH of sprite gSpriteBall then
            set gBallDirection to 7
          else
            set gBallDirection to 3
          end if
        else
          if the castNum of sprite gSpritePutter = 8 then
            if the locH of sprite gSpritePutter < the locH of sprite gSpriteBall then
              set gBallDirection to 4
            else
              set gBallDirection to 8
            end if
          end if
        end if
      end if
    end if
  end if
end

on setBallSpeed fromWhere
end

on movePutter
  set the loc of sprite gSpritePutter to the loc of sprite gSpriteBall
end

on moveBall
  set the castNum of sprite gSpriteBall to 47 + (50 - the castNum of sprite gSpriteBall)
  set the castNum of sprite gSpritePutter to 10
  set myBase to getAt(gDirectionList, gBallDirection)
  set currentSpeed to getAt(gSpeedList, 1)
  set myChange to myBase * currentSpeed
  set the loc of sprite gSpriteFakeBall to the loc of sprite gSpriteFakeBall + myChange
  updateStage()
  set gDoesBounce to 0
  if not (sprite gSpriteFakeBall within sprite(gSpriteCourse)) then
    set BOUNCE to 1
    puppetSound(1, 11)
    set gDoesBounce to 1
    set stopMe to 0
    set antiMove to myBase * -1
    repeat while not stopMe
      set the loc of sprite gSpriteFakeBall to the loc of sprite gSpriteFakeBall + antiMove
      updateStage()
      if sprite gSpriteFakeBall within sprite(gSpriteCourse) then
        set stopMe to 1
      end if
      set BOUNCE to BOUNCE + 1
    end repeat
  end if
  set the loc of sprite gSpriteBall to the loc of sprite gSpriteFakeBall
  if gDoesBounce then
    repeat with x = 1 to 8
      if sprite gSpriteBall intersects sprite(x) then
        set myWall to x
        exit repeat
      end if
    end repeat
    if myWall = (gBallDirection + 1) then
      set gBallDirection to gBallDirection + 2
    else
      if myWall = (gBallDirection + 2) then
        set gBallDirection to gBallDirection + 4
      else
        if myWall = (gBallDirection + 3) then
          set gBallDirection to gBallDirection + 6
        else
          set gBallDirection to gBallDirection + 2
        end if
      end if
    end if
    if gBallDirection > 8 then
      set gBallDirection to gBallDirection - 8
    end if
    addAt(gSpeedList, 2, BOUNCE)
  end if
  deleteAt(gSpeedList, 1)
  if not count(gSpeedList) then
    set gBallIsMoving to 0
    set gTigerIsWalking to 1
  end if
  checkHole()
  checkWater()
  checkSand()
end

on moveTiger
  if gTigerTime < the timer then
    if the locH of sprite gSpriteTigerLeftFoot < (the locH of sprite gSpriteBall - 30) then
      set myPoint to point(27, 0)
      if the locH of sprite gSpriteTigerLeftFoot < the locH of sprite gSpriteTigerRightFoot then
        set mySprite to gSpriteTigerLeftFoot
        set myCast to 55
      else
        set mySprite to gSpriteTigerRightFoot
        set myCast to 56
      end if
    else
      if the locH of sprite gSpriteTigerLeftFoot > (the locH of sprite gSpriteBall + 30) then
        set myPoint to point(-27, 0)
        if the locH of sprite gSpriteTigerLeftFoot > the locH of sprite gSpriteTigerRightFoot then
          set mySprite to gSpriteTigerLeftFoot
          set myCast to 57
        else
          set mySprite to gSpriteTigerRightFoot
          set myCast to 58
        end if
      else
        if the locV of sprite gSpriteTigerLeftFoot < (the locV of sprite gSpriteBall - 85) then
          set myPoint to point(0, 27)
          if the locV of sprite gSpriteTigerLeftFoot < the locV of sprite gSpriteTigerRightFoot then
            set mySprite to gSpriteTigerLeftFoot
            set myCast to 51
          else
            set mySprite to gSpriteTigerRightFoot
            set myCast to 52
          end if
        else
          if the locV of sprite gSpriteTigerLeftFoot > (the locV of sprite gSpriteBall - 58) then
            set myPoint to point(0, -27)
            if the locV of sprite gSpriteTigerLeftFoot > the locV of sprite gSpriteTigerRightFoot then
              set mySprite to gSpriteTigerLeftFoot
              set myCast to 53
            else
              set mySprite to gSpriteTigerRightFoot
              set myCast to 54
            end if
          else
            if not gTigerSpoke then
              set the loc of sprite gSpriteTigerTalk to the loc of sprite gSpriteTigerRightFoot
              set the visible of sprite gSpriteTigerTalk to 1
              set the castNum of sprite gSpriteTigerTalk to 173
            else
              if (random(3) = 1) and (gTigerSpoke = 2) then
                set the loc of sprite gSpriteTigerTalk to the loc of sprite gSpriteTigerRightFoot
                set the visible of sprite gSpriteTigerTalk to 1
                set the castNum of sprite gSpriteTigerTalk to 173 + gTigerSpoke
              end if
            end if
            set gTigerSpoke to 1
            set gTigerIsWalking to 0
          end if
        end if
      end if
    end if
    if gTigerIsWalking then
      set the loc of sprite mySprite to the loc of sprite mySprite + myPoint
      set the castNum of sprite mySprite to myCast
    end if
    set gTigerTime to the timer + 5
  end if
end

on checkHole
  if sprite gSpriteBall within sprite(gSpriteHole) then
    set the loc of sprite gSpriteBall to point(-100, -100)
    puppetSound(1, 16)
    set the castNum of sprite gSpriteText to 169
    set the visible of sprite gSpriteText to 1
    set gBallIsMoving to 0
    set gDoesBounce to 0
    updateStage()
    set myTimer to the timer + 5
    repeat while myTimer > the timer
    end repeat
    set the loc of sprite gSpriteBall to gBallStart
    set the loc of sprite gSpriteFakeBall to gBallStart
  else
    if sprite gSpriteBall intersects gSpriteHole and not gBallIsMoving then
      puppetSound(1, 25)
    end if
  end if
end

on checkSand
  repeat with x = 1 to count(gSpriteListSand)
    if sprite gSpriteBall within sprite(getAt(gSpriteListSand, x)) then
      if count(gSpeedList) > 1 then
        set myLoss to count(gSpeedList) / 2
        repeat with x = 1 to integer(myLoss)
          deleteAt(gSpeedList, 1)
        end repeat
      end if
      set gTigerSpoke to 2
      puppetSound(1, 18)
    end if
  end repeat
end

on checkWater
  repeat with x = 1 to count(gSpriteListWater)
    if sprite gSpriteBall within sprite(getAt(gSpriteListWater, x)) then
      set the castNum of sprite gSpriteBall to 15
      puppetSound(1, 19)
      set gBallIsMoving to 0
      set gDoesBounce to 0
      updateStage()
      set myTime to the timer + 15
      repeat while myTime > the timer
        nothing()
      end repeat
      set the loc of sprite gSpriteBall to gBallShoot
      set the loc of sprite gSpriteFakeBall to gBallShoot
      set gTigerSpoke to 3
    end if
  end repeat
end

on enterFrame
  if gIdleSuspended then
    exit
  end if
  if not gBallIsMoving then
    checkPutter()
    checkRollover()
    if gIdleTime < the timer then
      doIdle()
    end if
  end if
  pass()
end

on doIdle
  set myCast to the castNum of sprite gSpriteText + 1
  if (myCast > 43) or (myCast < 41) then
    set myCast to 41
  end if
  set the castNum of sprite gSpriteText to myCast
  set the visible of sprite gSpriteText to 1
  set gIdleTime to the timer + 300
end

on checkRollover
  if gIsOnRollOver then
    if rollOver(gIsOnRollOver + gSpriteRollover1 - 1) then
      nothing()
    else
      puppetSound(1, 21)
      set the castNum of sprite (gSpriteRollover1 + gIsOnRollOver - 1 + 10) to 98 + ((gIsOnRollOver * 2) - 1)
      set gIsOnRollOver to 0
    end if
  else
    repeat with x = 1 to 2
      if rollOver(gSpriteRollover1 + x - 1) then
        set gIsOnRollOver to x
        puppetSound(1, 20)
        set the castNum of sprite (gSpriteRollover1 + x - 1 + 10) to 98 + ((gIsOnRollOver * 2) - 2)
      end if
    end repeat
  end if
end

on checkPutter
  set gMyDist to abs(the mouseH - the locH of sprite gSpriteBall) + abs(the mouseV - the locV of sprite gSpriteBall)
  set gMyDist to integer((12 + gMyDist) / 10)
  if gMyDist < 5 then
    set myH to the mouseH - the locH of sprite gSpriteBall
    set myV to the mouseV - the locV of sprite gSpriteBall
    if myH > 0 then
      set myQuad to 2
    else
      set myQuad to -2
    end if
    if myV > 0 then
      set myQuad to myQuad - 1
    else
      set myQuad to myQuad + 1
    end if
    if myV = 0 then
      set myV to 0.001
    end if
    if myH = 0 then
      set myH to 0.001
    end if
    if ((abs(myV) / abs(myH)) + (abs(myH) / abs(myV))) < 3 then
      set myCast to 9 - abs(myQuad)
    else
      set myCast to 7
    end if
    if (myCast = 7) and (abs(myV) > abs(myH)) then
      set myCast to 5
    end if
    set the castNum of sprite gSpritePutter to myCast
    set the loc of sprite gSpritePutter to point(the mouseH, the mouseV)
    cursor(200)
    set gCanShoot to 1
    set the mouseUpScript to "shootBall"
    set the castNum of sprite gSpriteRightFoot to gBlank
    set the castNum of sprite gSpriteLeftFoot to gBlank
  else
    set gCanShoot to 0
    set the castNum of sprite gSpritePutter to gBlank
    set the mouseUpScript to EMPTY
    if gMyDist > 1 then
      footSteps()
    end if
  end if
end

on footSteps
  if gStepTime < the timer then
    set myPoint to point(the mouseH, the mouseV)
    set oldPoint to the loc of sprite gSpriteRightFoot + gWhichFoot
    if (abs(getAt(myPoint, 1) - getAt(oldPoint, 1)) + abs(getAt(myPoint, 2) - getAt(oldPoint, 2))) < 5 then
      nothing()
    else
      if (the mouseH < 0) or (the mouseV < 0) or (the mouseH > the stageRight) or (the mouseV > (the stageBottom - 25)) then
        set the castNum of sprite gSpriteRightFoot to gBlank
        set the castNum of sprite gSpriteLeftFoot to gBlank
      else
        set myH to getAt(myPoint, 1) - getAt(oldPoint, 1)
        set myV to getAt(myPoint, 2) - getAt(oldPoint, 2)
        if myH > 0 then
          set myQuad to 2
        else
          set myQuad to -2
        end if
        if myV > 0 then
          set myQuad to myQuad - 1
        else
          set myQuad to myQuad + 1
        end if
        if myV = 0 then
          set myV to 0.001
        end if
        if myH = 0 then
          set myH to 0.001
        end if
        if ((abs(myV) / abs(myH)) + (abs(myH) / abs(myV))) < 3 then
          set myCast to 9
        else
          set myCast to 7
        end if
        if (myCast = 7) and (abs(myV) > abs(myH)) then
          set myCast to 5
        end if
        if (getAt(myPoint, 1) > getAt(oldPoint, 1)) and (myCast = 7) then
          set myCast to 6
        end if
        if (getAt(myPoint, 2) > getAt(oldPoint, 2)) and (myCast = 5) then
          set myCast to 4
        end if
        if (getAt(myPoint, 2) > getAt(oldPoint, 2)) and (getAt(myPoint, 1) > getAt(oldPoint, 1)) and (myCast = 9) then
          set myCast to 8
        end if
        if (getAt(myPoint, 2) < getAt(oldPoint, 2)) and (getAt(myPoint, 1) > getAt(oldPoint, 1)) and (myCast = 9) then
          set myCast to 10
        end if
        if (getAt(myPoint, 2) > getAt(oldPoint, 2)) and (getAt(myPoint, 1) < getAt(oldPoint, 1)) and (myCast = 9) then
          set myCast to 11
        end if
        set myCast to myCast - 3
        set thisCast to 76 + (myCast * 2) - 2
        set gWhichFoot to 1 - gWhichFoot
        set the castNum of sprite (gSpriteRightFoot + gWhichFoot) to thisCast + gWhichFoot
        set the loc of sprite (gSpriteRightFoot + gWhichFoot) to point(the mouseH, the mouseV)
        set gStepTime to the timer + 6
        set the volume of sound 2 to 100
        puppetSound(2, 67 + gWhichFoot)
      end if
    end if
  end if
end
