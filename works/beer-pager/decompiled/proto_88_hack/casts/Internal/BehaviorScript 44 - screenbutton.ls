property mySprite, mySpriteNum, myMember, myMemberNum, myStandardMember, myInactiveMember, myMouseDownMember, pMyCallBack, pActive, myDir, myDirOffsets, myCenter, pCalendarMenuSpr
global oCurMeeting, gCurScreen, oCalendarClass, oCalendar2Class, oPrefsClass, oLoginClass, oregisterClass, oTuner2Class, oFriendsClass, oPlacesClass, gNavMenuHiSpr, oDialogueClass, oConnectoScope, gState

on beginSprite me
  Initialize(me)
end

on Initialize me
  mySpriteNum = me.spriteNum
  mySprite = sprite(mySpriteNum)
  myMember = mySprite.member
  myMemberNum = mySprite.member
  myStandardMember = value(myStandardMember)
  myMouseDownMember = value(myMouseDownMember)
  myInactiveMember = value(myInactiveMember)
  myMember = myStandardMember
  mActivate(me)
end

on mouseUp me
  if pActive then
    mySprite.member = myStandardMember
    doMyCallBack(me)
  end if
end

on mouseDown me
  if pActive then
    mySprite.member = myMouseDownMember
    mbrName = myStandardMember.name
    if mbrName contains "save" then
      playSound(#save)
    else
      if mbrName contains "cancel" then
        playSound(2, 1, 21, 100)
      else
        if mbrName contains "ok" then
          playSound(#read)
        else
          if mbrName contains "add" then
            playSound(2, 1, 5, 100)
          else
            if mbrName contains "delete" then
              playSound(2, 1, 59, 100)
            else
              if mbrName contains "forgot" then
                playSound(2, 1, 5, 100)
              else
                if mbrName contains "log in" then
                  playSound(2, 1, 16, 100)
                else
                  if mbrName contains "check" then
                    playSound(#checkMessages)
                  else
                    if mbrName contains "next" then
                      playSound(#next)
                    else
                      if mbrName contains "previous" then
                        playSound(#previous)
                      else
                        if mbrName contains "list" then
                          playSound(#listView)
                        else
                          if mbrName contains "read" then
                            playSound(#read)
                          else
                            if mbrName contains "show all" then
                              playSound(#showAll)
                            else
                              playSound(2, 1, 119, 100)
                            end if
                          end if
                        end if
                      end if
                    end if
                  end if
                end if
              end if
            end if
          end if
        end if
      end if
    end if
    updateStage()
  end if
end

on mouseUpOutSide me
  mySprite.member = myStandardMember
end

on deHilite me
  mySprite.member = myStandardMember
  updateStage()
end

on mActivate me
  pActive = 1
  mySprite.member = myStandardMember
end

on mDeActivate me
  pActive = 0
  mySprite.member = myInactiveMember
end

on doMyCallBack me
  netCommands = [#login, #M_open, #M_invite, #T_check, #T_delete, #T2_accept, #T2_decline, #F_submit, #F_save, #F_delete, #P_add, #P_save, #P_delete, #C_delete, #C2_cancel, #S_save, #I2_send, #R_register]
  netRequired = getPos(netCommands, pMyCallBack)
  if gState = #dialogue then
    screenName = "Dialogue"
  else
    screenName = gCurScreen
  end if
  mouseDownScriptToDo = "o" & screenName & "Class.mDoMyMouseDown(pMyCallBack)"
  do(mouseDownScriptToDo)
end

on getPropertyDescriptionList me
  if not (the currentSpriteNum) then
    exit
  end if
  theMember = sprite(the currentSpriteNum).member
  theMemberNum = theMember.number
  descriptionList = [#myStandardMember: [#comment: "Standard member:", #format: #member, #default: member(theMemberNum)], #myMouseDownMember: [#comment: "MouseDown member:", #format: #member, #default: member(theMemberNum + 1)], #myInactiveMember: [#comment: "Inactive:", #format: #member, #default: member(theMemberNum + 2)], #pMyCallBack: [#comment: "What callback?:", #format: #symbol, #default: #none, #range: [#Di_Button1, #Di_Button2, #login, #L_newuser, #L_forgot, #L_cancel, #M_power, #F_submit, #F_save, #F_delete, #F_cancel, #P_cancel, #P_add, #P_save, #P_delete, #I1_all, #I1_none, #I1_cancel, #I1_2, #I1_3, #I2_1, #I2_3, #I2_cancel, #I3_1, #I3_2, #I3_cancel, #T_check, #T_delete, #T_Read, #T2_next, #T2_last, #T2_cancel, #T2_accept, #T2_decline, #C_all, #C_delete, #C_read, #C2_back, #C2_last, #C2_next, #C2_cancel, #S_cancel, #S_save, #R_register, #R_next, #R_cancel, #R2_prev]]]
  return descriptionList
end
