property spriteNum, mySprite, myMember, getPDLError, myStandardMember, myRolloverMember, myMouseDownMember, myDisabledMember, myMouseDownSound, myMouseUpSound, myActiveFlag, myXRayFlag, myMessageType, myMessage, myToolTipMember, myToolTipSprite, myMouseDownNoteNum, theMouseWasUp, myMouseDown, myRollover, mySubscribersList
global goCurs, gxBeatnik

on beginSprite me
  Initialize(me)
end

on exitFrame me
  if myActiveFlag then
    CheckForRollover(me)
  end if
end

on endSprite me
  call(#PushButton_ClosingDown, mySubscribersList, me, spriteNum, myMessage)
end

on Initialize me
  mySprite = sprite(me.spriteNum)
  myMember = mySprite.member
  if not voidp(getPDLError) then
    ErrorAlert(me, #getPDL_Invalid, myMember.type)
  end if
  repeat while the last char in myMessage = SPACE
    delete char -30000 of myMessage
  end repeat
  if not ["do", "no action"].getPos(myMessageType) then
    if myMessage contains SPACE then
      ErrorAlert(me, #spaceInMessage, myMessage)
    else
      myMessage = symbol(myMessage)
    end if
  end if
  myActiveFlag = myActiveFlag = #Active
  myXRayFlag = myXRayFlag = "let all mouse events through"
  myStandardMember = value(myStandardMember)
  myRolloverMember = value(myRolloverMember)
  myMouseDownMember = value(myMouseDownMember)
  myDisabledMember = value(myDisabledMember)
  myMouseDownSound = value(myMouseDownSound)
  myMouseUpSound = value(myMouseUpSound)
  if myActiveFlag then
    myMember = myStandardMember
    mySprite.member = myMember
  else
    myMember = myDisabledMember
    mySprite.member = myMember
  end if
  mySubscribersList = []
  sendAllSprites(#PushButton_OpenForBusiness, mySubscribersList, me, spriteNum, myMessage)
end

on CheckForRollover me
  mouseOverMe = rollOver(spriteNum)
  if mouseOverMe then
    if not myXRayFlag then
      mouseOverMe = the mouseMember = myMember
    end if
  end if
  if myRollover = mouseOverMe then
    if theMouseWasUp = the mouseUp then
      exit
    else
      theMouseWasUp = the mouseUp
      if mouseOverMe then
        if the mouseUp then
          if myMouseDown then
            Activate(me)
          else
            myMember = myRolloverMember
            mySprite.member = myMember
            goCurs.mChange(#finger, me)
            sendSprite(myToolTipSprite, #mDisplay, myToolTipMember)
            gxBeatnik.noteOn(1, 2, 0, 17, 127)
          end if
        else
          clickOn(me)
        end if
      else
        if the mouseUp then
          if myMouseDown then
            Disactivate(me)
          end if
        end if
      end if
    end if
  else
    myRollover = mouseOverMe
    if myMouseDown then
      if myRollover then
        myMember = myMouseDownMember
        mySprite.member = myMember
        goCurs.mChange(#finger, me)
        sendSprite(myToolTipSprite, #mDisplay, myToolTipMember)
        if myMouseDownNoteNum then
          gxBeatnik.noteOn(2, 2, 0, myMouseDownNoteNum, 127)
        end if
      else
        myMember = myStandardMember
        mySprite.member = myMember
        goCurs.mChange(#arrow, me)
        sendSprite(myToolTipSprite, #mRestore)
      end if
    else
      if not (the mouseDown) and myRollover then
        myMember = myRolloverMember
        mySprite.member = myMember
        goCurs.mChange(#finger, me)
        sendSprite(myToolTipSprite, #mDisplay, myToolTipMember)
        gxBeatnik.noteOn(1, 2, 0, 17, 127)
      else
        myMember = myStandardMember
        mySprite.member = myMember
        goCurs.mChange(#arrow, me)
        sendSprite(myToolTipSprite, #mRestore)
      end if
    end if
  end if
end

on clickOn me
  myMouseDown = 1
  myMember = myMouseDownMember
  mySprite.member = myMember
  if not voidp(myMouseDownSound) then
    puppetSound(myMouseDownSound)
  end if
  if myMouseDownNoteNum then
    gxBeatnik.noteOn(2, 2, 0, myMouseDownNoteNum, 127)
  end if
  updateStage()
end

on Activate me
  myMouseDown = 0
  theMouseWasUp = 0
  myMember = myStandardMember
  mySprite.member = myMember
  if not voidp(myMouseUpSound) then
    puppetSound(myMouseUpSound)
  end if
  updateStage()
  case myMessageType of
    "do":
      do(myMessage)
    "sendAllSprites":
      sendAllSprites(myMessage, me, spriteNum)
    "call the actorList":
      call(myMessage, the actorList, me, spriteNum)
  end case
  call(#PushButton_Activated, mySubscribersList, me, spriteNum, myMessage)
end

on Disactivate me
  myMouseDown = 0
  myMember = myStandardMember
  mySprite.member = myMember
  goCurs.mChange(#arrow, me)
  sendSprite(myToolTipSprite, #mRestore)
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
    myMember = myStandardMember
    mySprite.member = myMember
    call(#PushButton_Enabled, mySubscribersList, me, spriteNum, myMessage)
  else
    myMember = myDisabledMember
    mySprite.member = myMember
    goCurs.mChange(#arrow, me)
    call(#PushButton_Disabled, mySubscribersList, me, spriteNum, myMessage)
  end if
end

on PushButton_GetReference me, theList
  case ilk(theList) of
    #list:
      theList.append(me)
    #propList:
      theList.addProp(me.spriteNum, me)
    otherwise:
      return me
  end case
  return theList
end

on PushButton_Subscribe me, callingBehavior, theMessage
  if not voidp(theMessage) then
    if theMessage <> myMessage then
      exit
    end if
  end if
  if mySubscribersList.getPos(callingBehavior) then
    exit
  else
    if objectp(callingBehavior) then
      mySubscribersList.append(callingBehavior)
      return me
    end if
  end if
end

on PushButton_Unsubscribe me, callingBehavior
  mySubscribersList.deleteOne(callingBehavior)
end

on ErrorAlert me, theError, data
  case theError of
    #getPDLError:
      alert("Error: This behavior works only with the following members types:  " & PermittedMemberTypes(me) & RETURN & RETURN & "Hit OK and then delete this behavior from the sprite.  See the Help system for details on deleting behaviors.")
      if the optionDown then
        return [#getPDLError: [#comment: "ERROR:   Wrong member type.   Click 'Cancel'.", #format: #string, #range: [EMPTY], #default: EMPTY]]
      end if
    otherwise:
      case theError of
        #invalidMemberType:
          if the runMode = "Author" then
            behaviorName = string(me)
            delete word 1 of behaviorName
            delete char -30001 of behaviorName
            delete char -30001 of behaviorName
            alert("BEHAVIOR ERROR: Frame " & the frame & ", Sprite " & me.spriteNum & RETURN & RETURN & "Behavior " & behaviorName & " only works with Field and Text members." & RETURN & RETURN & "Current member type = #" & data)
          end if
          abort()
        #spaceInMessage:
          if the runMode = "Author" then
            alert("BEHAVIOR ERROR: Frame " & the frame & ", Sprite " & me.spriteNum & RETURN & "Behavior " & behaviorName & RETURN & RETURN & "Message includes spaces: " & QUOTE & data & QUOTE & RETURN & "Only the first word will be used in sendAllSprite calls:" & RETURN & RETURN & "sendAllSprites (#" & data.word[1] & ", <me>, " & spriteNum & ")")
          end if
      end case
  end case
end

on getPropertyDescriptionList me
  if not (the currentSpriteNum) then
    exit
  end if
  theMember = sprite(the currentSpriteNum).member
  memberType = theMember.type
  permittedTypes = PermittedMemberTypes(me)
  if not permittedTypes.getPos(memberType) then
    return ErrorAlert(me, #getPDLError, permittedTypes)
  end if
  theMemberNum = theMember.number
  suitableMembersList = GetSuitableMembers(me, permittedTypes)
  descriptionList = [#myStandardMember: [#comment: "- GRAPHICS - Standard member for sprite:", #format: #member, #range: suitableMembersList, #default: theMember], #myRolloverMember: [#comment: "Rollover member:", #format: #member, #range: suitableMembersList, #default: member(theMemberNum + 1)], #myMouseDownMember: [#comment: "MouseDown member:", #format: #member, #range: suitableMembersList, #default: member(theMemberNum + 2)], #myDisabledMember: [#comment: "Disabled member:", #format: #member, #range: suitableMembersList, #default: member(theMemberNum + 3)], #myToolTipMember: [#comment: "ToolTip member:", #format: #member, #range: suitableMembersList, #default: member(theMemberNum + 4)], #myToolTipSprite: [#comment: "ToolTip sprite:", #format: #integer, #default: 59], #myMouseDownNoteNum: [#comment: "Mouse Down Note:", #format: #integer, #default: 0]]
  soundsAvailable = GetSuitableMembers(me, [#sound])
  if soundsAvailable.count() then
    soundsAvailable.addAt(1, #none)
    descriptionList.addProp(#myMouseDownSound, [#comment: "- SOUNDS - Sound to play on mouseDown:", #format: #sound, #range: soundsAvailable, #default: member(theMemberNum + 4)])
    descriptionList.addProp(#myMouseUpSound, [#comment: "Sound to play on mouseUp:", #format: #sound, #range: soundsAvailable, #default: member(theMemberNum + 5)])
  end if
  descriptionList.addProp(#myActiveFlag, [#comment: "- INTERACTION - Button is initially", #format: #symbol, #range: [#Active, #inactive], #default: #Active])
  descriptionList.addProp(#myXRayFlag, [#comment: "Sprites which cover the button", #format: #string, #range: ["block all mouse events", "let all mouse events through"], #default: 0])
  descriptionList.addProp(#myMessageType, [#comment: "Action on mouseUp:", #format: #string, #range: ["do", "sendAllSprites", "call the actorList", "no action"], #default: "sendAllSprites"])
  descriptionList.addProp(#myMessage, [#comment: EMPTY, #format: #string, #default: "YourCustomMessage"])
  return descriptionList
end

on GetSuitableMembers me, permittedTypes
  cursor(4)
  suitableMembersList = []
  maxCastLib = the number of castLibs
  repeat with theCastLib = 1 to maxCastLib
    maxMember = the number of castMembers of castLib theCastLib
    repeat with memberNumber = 1 to maxMember
      theMember = member(memberNumber, theCastLib)
      if permittedTypes.getPos(theMember.type) then
        if theMember.name = EMPTY then
          suitableMembersList.append(theMember)
          next repeat
        end if
        suitableMembersList.append(theMember.name)
      end if
    end repeat
  end repeat
  cursor(-1)
  return suitableMembersList
end

on PermittedMemberTypes me
  return [#bitmap, #filmLoop, #flash, #movie, #picture, #quickTimeMedia, #shape, #vectorShape]
end
