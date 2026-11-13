property mySpr, myMem, iSelItem, ispriteType, iTextFieldMem, iTextSpr, pUpArrowOffMem, pUpArrowOnMem, pUpArrowPressMem, pDownArrowOffMem, pDownArrowOnMem, pDownArrowPressMem
global oCurMeeting

on beginSprite me
  me.iSelItem = 1
  me.mySpr = me.spriteNum
  me.myMem = (the member of sprite me.mySpr).name
  pUpArrowOffMem = "time_up_arrow_off"
  pUpArrowOnMem = "time_up_arrow_on"
  pUpArrowPressMem = "time_up_arrow_down"
  pDownArrowOffMem = "time_down_arrow_off"
  pDownArrowOnMem = "time_down_arrow_on"
  pDownArrowPressMem = "time_down_arrow_down"
  if me.ispriteType = #upArrow then
    me.iTextSpr = me.mySpr - 1
    me.iTextFieldMem = sprite(me.mySpr - 1).member.name
  else
    if me.ispriteType = #downArrow then
      me.iTextSpr = me.mySpr - 2
      me.iTextFieldMem = sprite(me.mySpr - 2).member.name
    else
      me.iTextFieldMem = myMem
    end if
  end if
  return me
end

on getBehaviorDescription me
  return "TIME INPUT BEHAVIOR v0.9" & RETURN & "The behaviors of the various elements mimic that of the MacOS Date & Time Control Panel Time input field. Drop on to an editable text field, an up arrow, and a down arrow sprite.There are three states for the arrows: a default, dim state when the time field doesn't have keyboard focus, an active state, and a button-down state." & RETURN & "The default names for these bitmaps are:" & RETURN & "time_up_arrow_off" & RETURN & "time_up_arrow_on" & RETURN & "time_up_arrow_down" & RETURN & "time_down_arrow_off" & RETURN & "time_down_arrow_on" & RETURN & "time_down_arrow_down" & RETURN & RETURN & "The sprites must be adjacent to each other in the following order:" & RETURN & "text field" & RETURN & "up arrow" & RETURN & "down arrow" & RETURN & RETURN
end

on getPropertyDescriptionList
  propList = [#ispriteType: [#comment: "Current sprite acts as:", #format: #symbol, #range: [#textField, #upArrow, #downArrow], #default: #textField]]
  return propList
end

on mouseDown me
  case me.ispriteType of
    #upArrow, #downArrow:
      playSound(#scrollUp)
      if me.ispriteType = #upArrow then
        Dir = 1
      else
        Dir = -1
      end if
      changeArrow(me, #down)
      updateStage()
      sendSprite(me.iTextSpr, #mIncrementSel, Dir)
      waitForTimer(me, 30 * 1, #mouseUp)
      repeat while the mouseDown
        sendSprite(me.iTextSpr, #mIncrementSel, Dir)
        updateStage()
        waitForTimer(me, 5)
        playSound(#scrollUp)
      end repeat
  end case
end

on XmouseUpOutside me
  case me.ispriteType of
    #textField:
      selectTextItem(me, 1)
    #upArrow, #downArrow:
      changeArrow(me, #on)
  end case
end

on mouseUp me
  if not rollOver(mySpr) then
    XmouseUpOutside(me)
    exit
  end if
  case me.ispriteType of
    #textField:
      selectTextItem(me)
    #upArrow, #downArrow:
      changeArrow(me, #on)
  end case
  oCurMeeting.mUpdateMeetingData(#iWhen, member(iTextFieldMem).text)
end

on keyDown me
  case me.ispriteType of
    #textField:
      case me.iSelItem of
        1:
          if not ("0123456789" contains the key) then
            exit
          end if
          curNumString = member(me.myMem).item[me.iSelItem]
          curNum = integer(curNumString)
          if curNum >= 10 then
            x1 = char 1 of curNumString
            x2 = char 2 of curNumString
          else
            x1 = char 1 of curNumString
            x2 = char 1 of curNumString
          end if
          xn = the key
          if (integer(x2 & xn) <= 12) and (integer(x2 & xn) > 0) then
            tempNumString = x2 & xn
            set the selEnd to the selStart + 2
          else
            if (integer(x1 & xn) <= 12) and (integer(x1 & xn) > 0) then
              tempNumString = x1 & xn
              set the selEnd to the selStart + 2
            else
              if xn <> "0" then
                tempNumString = xn
              else
                tempNumString = curNumString
              end if
              set the selEnd to the selStart + 1
            end if
          end if
          if char 1 of tempNumString = "0" then
            delete char 1 of tempNumString
            set the selEnd to the selStart + 1
          end if
          put tempNumString into (member the myMem of me).item[the iSelItem of me]
          set the selStart to 0
        2:
          if not ("0123456789" contains the key) then
            exit
          end if
          curNumString = member(me.myMem).item[me.iSelItem]
          curNum = integer(curNumString)
          x1 = char 1 of curNumString
          x2 = char 2 of curNumString
          xn = the key
          if integer(x2 & xn) <= 59 then
            tempNumString = x2 & xn
          else
            tempNumString = "0" & xn
          end if
          put tempNumString into (member the myMem of me).item[the iSelItem of me]
          set the selStart to the number of chars in (member the myMem of me).item[1] + 1
          set the selEnd to the selStart + 2
        3:
          if not ("ap" contains the key) then
            exit
          end if
          if me.iSelItem = 3 then
            if the key = "a" then
              curAMPM = "AM"
            else
              curAMPM = "PM"
            end if
            put curAMPM into (member the myMem of me).item[the iSelItem of me]
          end if
          set the selStart to the number of chars in (member the myMem of me).item[1] + 4
      end case
  end case
  oCurMeeting.mUpdateMeetingData(#iWhen, member(iTextFieldMem).text)
end

on changeArrow me, Dir
  if me.ispriteType = #upArrow then
    if Dir = #on then
      newmem = pUpArrowOnMem
    else
      newmem = pUpArrowPressMem
    end if
  else
    if Dir = #down then
      newmem = pDownArrowPressMem
    else
      newmem = pDownArrowOnMem
    end if
  end if
  sprite(mySpr).member = newmem
end

on selectTextItem me, whichItem
  the itemDelimiter = ":"
  if not whichItem then
    whichItem = the mouseItem
  end if
  curItem = member(me.myMem).item[whichItem]
  numChars = the number of chars in curItem
  case the mouseItem of
    1:
      set the selStart to 0
    2:
      set the selStart to the number of chars in (member the myMem of me).item[1] + 1
    3:
      set the selStart to the number of chars in (member the myMem of me).item[1] + 4
  end case
  set the selEnd to the selStart + numChars
  me.iSelItem = whichItem
  sprite(mySpr + 1).member = pUpArrowOnMem
  sprite(mySpr + 2).member = pDownArrowOnMem
end

on mIncrementSel me, Dir
  if me.iSelItem = 1 then
    whatToChange = #min
  else
    if me.iSelItem = 2 then
      whatToChange = #Hour
    else
      whatToChange = #AMPM
    end if
  end if
  selText = member(me.myMem).item[me.iSelItem]
  case whatToChange of
    #min:
      newNum = integer(selText) + Dir
      if newNum > 12 then
        newNum = "1"
      else
        if newNum < 1 then
          newNum = "12"
        end if
      end if
    #Hour:
      x1 = char 1 of selText
      x2 = char 2 of selText
      newNum = integer(x1 & x2) + Dir
      if newNum > 59 then
        newNum = "00"
      else
        if newNum < 0 then
          newNum = "59"
        else
          if newNum < 10 then
            newNum = "0" & string(newNum)
          end if
        end if
      end if
    #AMPM:
      if selText = "AM" then
        newNum = "PM"
      else
        newNum = "AM"
      end if
  end case
  member(me.myMem).item[me.iSelItem] = newNum
  setSel(me, whatToChange)
end

on setSel me, whichPart
  case whichPart of
    #min:
      set the selStart to 0
      set the selEnd to the number of chars in (member the myMem of me).item[1]
    #Hour:
      set the selStart to the number of chars in (member the myMem of me).item[1] + 1
      set the selEnd to the selStart + 2
    #AMPM:
      set the selStart to the number of chars in (member the myMem of me).item[1] + 4
      set the selEnd to the selStart + 2
  end case
end

on setTimeText me, whatTime
  member(iTextFieldMem).text = whatTime
  myOffSet = offset("M", member(iTextFieldMem).text)
  member(iTextFieldMem).char[myOffSet - 2] = ":"
  oCurMeeting.mUpdateMeetingData(#iWhen, member(iTextFieldMem).text)
end

on waitForTimer me, myTicks, condition
  waitTime = the timer + myTicks
  repeat while the timer < waitTime
    case condition of
      #mouseUp:
        if the mouseUp then
          exit repeat
        end if
      otherwise:
    end case
  end repeat
end
