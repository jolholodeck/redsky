property spriteNum, mySprite, myOffMember, myOffOverMember, myOffDownMember, myOffCommand, myOnMember, myOnOverMember, myOnDownMember, myOnCommand, myToolTipMember, myToolTipSprite, myActiveFlag, theMouseWasUp, myRollover, myState, ourID, ourGroupList, ourMouseDown
global goCurs, gxBeatnik

on beginSprite me
  Initialize(me)
end

on exitFrame me
  if myActiveFlag and not myState then
    CheckForRollover(me)
  end if
end

on mouseUp me
  if ourMouseDown[1] then
    Toggle(me)
  end if
end

on mouseUpOutSide me
  CheckGroupForClick(me)
end

on Initialize me
  mySprite = sprite(me.spriteNum)
  ourGroupList = []
  myActiveFlag = myActiveFlag = #Active
  myOffMember = member(myOffMember)
  myOffOverMember = member(myOffOverMember)
  myOffDownMember = member(myOffDownMember)
  myOnMember = member(myOnMember)
  myOnOverMember = member(myOnOverMember)
  myOnDownMember = member(myOnDownMember)
  sendAllSprites(#ToggleButton_GroupRollCall, ourID, ourGroupList)
  call(#ToggleButton_MouseDownList, ourGroupList, [0])
end

on CheckForRollover me
  mouseOverMe = rollOver(spriteNum)
  if myRollover = mouseOverMe then
    if theMouseWasUp = the mouseUp then
      exit
    else
      theMouseWasUp = the mouseUp
      if mouseOverMe then
        if the mouseUp then
          case myState of
            1:
              mySprite.member = myOnOverMember
            0:
              mySprite.member = myOffOverMember
          end case
          goCurs.mChange(#finger, me)
          sendSprite(myToolTipSprite, #mDisplay, myToolTipMember)
        else
          clickOn(me)
        end if
      end if
    end if
  else
    myRollover = mouseOverMe
    if ourMouseDown[1] then
      if myRollover then
        case myState of
          1:
            mySprite.member = myOnDownMember
          0:
            mySprite.member = myOffDownMember
        end case
        goCurs.mChange(#finger, me)
        sendSprite(myToolTipSprite, #mDisplay, myToolTipMember)
      else
        case myState of
          1:
            mySprite.member = myOnMember
          0:
            mySprite.member = myOffMember
        end case
        goCurs.mChange(#arrow, me)
        sendSprite(myToolTipSprite, #mRestore)
      end if
    else
      if not (the mouseDown) and myRollover then
        case myState of
          1:
            mySprite.member = myOnOverMember
          0:
            mySprite.member = myOffOverMember
        end case
        goCurs.mChange(#finger, me)
        sendSprite(myToolTipSprite, #mDisplay, myToolTipMember)
      else
        case myState of
          1:
            mySprite.member = myOnMember
          0:
            mySprite.member = myOffMember
        end case
        goCurs.mChange(#arrow, me)
        sendSprite(myToolTipSprite, #mRestore)
      end if
    end if
  end if
end

on clickOn me
  ourMouseDown[1] = 1
  case myState of
    1:
      mySprite.member = myOnDownMember
      goCurs.mChange(#arrow, me)
    0:
      mySprite.member = myOffDownMember
  end case
end

on Toggle me, whichState
  if voidp(whichState) then
    myState = not myState
  else
    myState = whichState
  end if
  ourMouseDown[1] = 0
  theMouseWasUp = 1
  case myState of
    1:
      if myRollover then
        mySprite.member = myOnOverMember
      else
        mySprite.member = myOnMember
      end if
      sendSprite(myToolTipSprite, #mSetDefault, myToolTipMember)
      goCurs.mChange(#arrow, me)
      updateStage()
      do(myOnCommand)
    0:
      if myRollover then
        mySprite.member = myOffOverMember
      else
        mySprite.member = myOffMember
      end if
      updateStage()
      do(myOffCommand)
  end case
  if ourGroupList.count() then
    if myState then
      call(#ToggleButton_Off, ourGroupList, me)
    end if
  end if
end

on CheckGroupForClick me
  groupRollover = call(#ToggleButton_Rollover, ourGroupList, [])
  if not groupRollover.count() then
    ourMouseDown[1] = 0
  end if
end

on PushButton_ToggleActive me, trueOrFalse
  if voidp(trueOrFalse) then
    myActiveFlag = not myActiveFlag
  else
    case ilk(trueOrFalse) of
      #integer:
        myActiveFlag = trueOrFalse <> 0
      otherwise:
        return #invalidTypeError
    end case
  end if
  if myActiveFlag then
  else
    case myState of
      1:
        mySprite.member = myOnMember
      0:
        mySprite.member = myOffMember
    end case
    goCurs.mChange(#arrow, me)
    sendSprite(myToolTipSprite, #mRestore)
  end if
end

on ToggleButton_GroupRollCall me, groupID, groupList
  if groupID = ourID then
    ourGroupList = groupList
    ourGroupList.append(me)
  end if
  return groupList
end

on ToggleButton_MouseDownList me, mouseDownList
  ourMouseDown = mouseDownList
end

on ToggleButton_Rollover me, theList
  if the rollOver = spriteNum then
    theList.append(spriteNum)
  end if
  return theList
end

on ToggleButton_Off me, callingBehavior
  if callingBehavior = me then
    exit
  end if
  Toggle(me, 0)
end

on ToggleButton_State me, groupID, statesList
  if not voidp(groupID) then
    if groupID <> ourID then
      exit
    end if
  end if
  case ilk(statesList) of
    #void:
      return myState
    #list:
      statesList.append(myState)
    #propList:
      statesList.addProp(spriteNum, myState)
  end case
  return statesList
end

on ToggleButton_ActiveButton me, groupID, theList
  if not voidp(groupID) then
    if groupID <> ourID then
      exit
    end if
  end if
  if not listp(theList) then
    theList = [:]
  end if
  if not theList.count() and myState then
    theList.addProp(#sprite, spriteNum)
    theList.addProp(#behavior, me)
  end if
  return theList
end

on getPropertyDescriptionList me
  if not (the currentSpriteNum) then
    exit
  end if
  theMember = sprite(the currentSpriteNum).member
  theMemberNum = theMember.number
  return [#myOffMember: [#comment: "-OFF STATE- Standard member:", #format: #graphic, #default: theMember], #myOffOverMember: [#comment: "Rollover member:", #format: #graphic, #default: member(theMemberNum + 1)], #myOffDownMember: [#comment: "MouseDown member:", #format: #graphic, #default: member(theMemberNum + 2)], #myOnMember: [#comment: "-ON STATE- Standard member:", #format: #graphic, #default: member(theMemberNum + 3)], #myOnOverMember: [#comment: "Rollover member:", #format: #graphic, #default: member(theMemberNum + 4)], #myOnDownMember: [#comment: "MouseDown member:", #format: #graphic, #default: member(theMemberNum + 5)], #myOnCommand: [#comment: "-COMMAND SENT- when switched ON:", #format: #string, #default: "sendAllSprites #Toggle_On, the currentSpriteNum"], #myOffCommand: [#comment: "when switched OFF:", #format: #string, #default: "sendAllSprites #Toggle_Off, the currentSpriteNum"], #ourID: [#comment: "ID string for the group:", #format: #string, #default: EMPTY], #myToolTipMember: [#comment: "ToolTip member:", #format: #member, #default: EMPTY], #myToolTipSprite: [#comment: "ToolTip sprite:", #format: #integer, #default: EMPTY], #myActiveFlag: [#comment: "- INTERACTION - Button is initially", #format: #symbol, #range: [#Active, #inactive], #default: #Active]]
end
