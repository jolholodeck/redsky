global error, target, goDiorama, gDebug, gKeyPressed

on w
  WritePropData(1, "Fade", "Data", "Collection Diorama")
end

on r
  target = [:]
  ReadPropData("Data", "Collection Diorama", target)
end

on WritePropData sprNum, behavName, fieldName, Cst
  spr = sprite(sprNum)
  behavs = spr.scriptInstanceList
  repeat with thisBehav in behavs
    if string(thisBehav) contains behavName then
      behav = thisBehav
    end if
  end repeat
  behavProps = behav.getPropertyDescriptionList()
  totalProps = behavProps.count()
  props = [:]
  repeat with i = 1 to totalProps
    thisPropName = getPropAt(behavProps, i)
    thisPropVal = getProp(behav, thisPropName)
    props.addProp(thisPropName, thisPropVal)
  end repeat
  if the number of member fieldName of castLib Cst <= 0 then
    mbr = new(#field, castLib(Cst))
    mbr.name = fieldName
  end if
  member(fieldName, Cst).text = string(props)
end

on ReadPropData fieldName, Cst, obj
  props = value(member(fieldName, Cst).text)
  repeat with i = 1 to props.count
    name = getPropAt(props, i)
    val = props[i]
    obj[name] = val
  end repeat
end

on WeightedDistribution distribs
  linearDistribs = []
  repeat with i = 1 to distribs.count
    repeat with j = 1 to getAt(distribs, i)
      linearDistribs.add(getPropAt(distribs, i))
    end repeat
  end repeat
  roll = random(linearDistribs.count)
  pick = linearDistribs[roll]
  linearDistribs = 0
  return pick
end

on PreloadMembers memberNums, Cst
  repeat with memberNum in memberNums
    member(memberNum, Cst).preLoad()
  end repeat
end

on VerifyPreload memberNums, Cst
  repeat with memberNum in memberNums
    if not member(memberNum, Cst).loaded then
      return 0
    end if
  end repeat
  return 1
end

on RandomRange min, max
  distance = max - min + 1
  roll = random(distance) - 1
  return min + roll
end

on buildList a, b
  myList = []
  if a < b then
    repeat with i = a to b
      add(myList, i)
    end repeat
    return myList
  end if
  if a > b then
    repeat with i = a down to b
      add(myList, i)
    end repeat
    return myList
  end if
  if a = b then
    myList = [a]
    return myList
  end if
end

on ZeroReg start, finish
  repeat with spr = start to finish
    sprite(spr).loc = point(0, 0)
  end repeat
end

on extractProps behav
  props = [:]
  behavProps = behav.getPropertyDescriptionList()
  totalProps = behavProps.count()
  repeat with i = 1 to totalProps
    thisProp = behavProps[i]
    thisPropName = getPropAt(behavProps, i)
    thisPropVal = getProp(behav, thisPropName)
    thisPropDefault = thisProp.default
    case thisPropName of
      #animName:
        thisPropVal = symbol(thisPropVal)
      #Blockers:
        thisPropVal = value(thisPropVal)
      #name:
        myType = ilk(value(thisPropVal))
        case myType of
          #void:
            thisPropVal = symbol(thisPropVal)
          #symbol:
            thisPropVal = value(thisPropVal)
        end case
      #next:
        myType = ilk(value(thisPropVal))
        case myType of
          #symbol, #void:
            thisPropVal = symbol(thisPropVal)
          #propList, #integer:
            thisPropVal = value(thisPropVal)
        end case
      #frames:
        if not (thisPropVal contains "-") then
          thisPropVal = value(thisPropVal)
        else
          thisPropVal = RangeToList(thisPropVal)
        end if
        if not (ilk(thisPropVal) = #list) then
          thisPropVal = [thisPropVal]
        end if
    end case
    if voidp(thisPropVal) then
      thisPropVal = thisPropDefault
    end if
    props.addProp(thisPropName, thisPropVal)
  end repeat
  ErrorCheck(props, listp(props), "Problem extracting props")
  return props
end

on RangeToList str
  oldDelimiter = the itemDelimiter
  the itemDelimiter = "-"
  start = value(item 1 of str)
  finish = value(item 2 of str)
  the itemDelimiter = oldDelimiter
  return buildList(start, finish)
end

on PreloadAnim data
end

on parseListData mbr
  if (mbr.type <> #text) and (mbr.type <> #field) then
    return -1
  end if
  dataStr = mbr.text
  if dataStr = EMPTY then
    return -2
  end if
  nbLines = the number of lines in dataStr
  out = EMPTY
  repeat with X = 1 to nbLines
    if line X of dataStr starts "--" then
      next repeat
    end if
    put line X of dataStr after dataStr
  end repeat
  lOut = value(out)
  if not listp(lOut) then
    return -3
  end if
  return lOut
end

on GetSequences spr, behav
  behavs = spr.scriptInstanceList
  seqs = []
  repeat with thisBehav in behavs
    if string(thisBehav) contains behav then
      seqs.add(thisBehav)
    end if
  end repeat
  return seqs
end

on dontExist mbr, Cst
  repeat with j = 1 to the number of castMembers of castLib Cst
    thisMember = member(j, Cst)
    if thisMember.type <> #empty then
      if thisMember.name = mbr then
        return 0
      end if
    end if
  end repeat
  return 1
end

on ErrorCheck thingy, condition, errorMsg
  if not condition then
    error = thingy
    alert(errorMsg)
    nothing()
    halt()
  else
    error = 0
  end if
end

on setRegPt p, flag
  if not ilk(p, #point) then
    p = point(0, 0)
  end if
  cln = the activeCastLib
  selMbrs = castLib(cln).selection
  i = 0
  repeat with eachRange in selMbrs
    repeat with mbr = getAt(eachRange, 1) to getAt(eachRange, 2)
      t = member(mbr, cln).type
      case t of
        #bitmap, #flash:
          member(mbr, cln).regPoint = p
          i = i + 1
          if flag = #OrgLoc then
            case t of
              #flash:
                member(mbr, cln).originMode = #point
                member(mbr, cln).originH = p[1]
                member(mbr, cln).originV = p[2]
            end case
          end if
      end case
    end repeat
  end repeat
  put "setRegPt: done (changed regPoint for " & i & " members)"
end

on moveRegPt p
  if not ilk(p, #point) then
    put "sorry, not a valid point"
    exit
  end if
  cln = the activeCastLib
  selMbrs = castLib(cln).selection
  i = 0
  repeat with eachRange in selMbrs
    repeat with mbr = getAt(eachRange, 1) to getAt(eachRange, 2)
      t = member(mbr, cln).type
      case t of
        #bitmap:
          member(mbr, cln).regPoint = member(mbr, cln).regPoint + p
          i = i + 1
      end case
    end repeat
  end repeat
  put "moveRegPt: done (moved regPoint for " & i & " members)"
end

on devcuteveryother
  cln = the activeCastLib
  selMbrs = castLib(cln).selection
  i = 0
  repeat with eachRange in selMbrs
    repeat with mbr = getAt(eachRange, 1) to getAt(eachRange, 2)
      t = member(mbr, cln).type
      case t of
        #bitmap:
          if i mod 2 then
            erase(member(mbr, cln))
          end if
          i = i + 1
      end case
    end repeat
  end repeat
end

on setSprProps LsprNums, Ldata, updateFlag
  if not listp(LsprNums) then
    LsprNums = [LsprNums]
  end if
  repeat with spr in LsprNums
    if ilk(Ldata) <> #propList then
      exit
    end if
    numData = count(Ldata)
    repeat with j = 1 to numData
      case getPropAt(Ldata, j) of
        #blend:
          sprite(spr).blend = getAt(Ldata, j)
        #ink:
          sprite(spr).ink = coerceSprInkID(getAt(Ldata, j))
        #forecolor:
          sprite(spr).forecolor = getAt(Ldata, j)
        #backcolor:
          sprite(spr).backcolor = getAt(Ldata, j)
        #constraint:
          sprite(spr).constraint = getAt(Ldata, j)
        #stretch:
          sprite(spr).stretch = getAt(Ldata, j)
        #flipH:
          sprite(spr).flipH = getAt(Ldata, j)
        #flipV:
          sprite(spr).flipV = getAt(Ldata, j)
        #rotation:
          sprite(spr).rotation = getAt(Ldata, j)
        #rect:
          sprite(spr).rect = getAt(Ldata, j)
        #top:
          sprite(spr).top = getAt(Ldata, j)
        #left:
          sprite(spr).left = getAt(Ldata, j)
        #bottom:
          sprite(spr).bottom = getAt(Ldata, j)
        #right:
          sprite(spr).right = getAt(Ldata, j)
        #height:
          sprite(spr).height = getAt(Ldata, j)
        #width:
          sprite(spr).width = getAt(Ldata, j)
        #moveable:
          sprite(spr).moveableSprite = getAt(Ldata, j)
        #editable:
          sprite(spr).editable = getAt(Ldata, j)
        #trails:
          sprite(spr).trails = getAt(Ldata, j)
        #loc:
          sprite(spr).loc = getAt(Ldata, j)
        #locH:
          sprite(spr).locH = getAt(Ldata, j)
        #locV:
          sprite(spr).locV = getAt(Ldata, j)
        #locZ:
          sprite(spr).locZ = getAt(Ldata, j)
        #beh:
          lScrs = getAt(Ldata, j)
          if sprite(spr).scriptInstanceList <> [] then
            repeat with scr in sprite(spr).scriptInstanceList
              scr = 0
            end repeat
          end if
          sprite(spr).scriptInstanceList = lScrs
        #newBeh:
          lScrs = getAt(Ldata, j)
          if listp(lScrs) then
            repeat with scr in lScrs
              add(sprite(spr).scriptInstanceList, scr)
            end repeat
          end if
        #cursor:
          sprite(spr).cursor = getAt(Ldata, j)
        #visible:
          sprite(spr).visible = getAt(Ldata, j)
        #memberNum, #mbr:
          sprite(spr).member = getAt(Ldata, j)
      end case
    end repeat
    case sprite(spr).member.type of
      #digitalVideo, #quickTimeMedia:
        repeat with j = 1 to numData
          case getPropAt(Ldata, j) of
            #startTime:
              sprite(spr).startTime = getAt(Ldata, j)
            #stopTime:
              sprite(spr).stopTime = getAt(Ldata, j)
            #movieRate:
              sprite(spr).movieRate = getAt(Ldata, j)
            #movieTime:
              sprite(spr).movieTime = getAt(Ldata, j)
            #volume:
              sprite(spr).voume = getAt(Ldata, j)
          end case
        end repeat
      #flash, #vectorShape:
        repeat with j = 1 to numData
          case getPropAt(Ldata, j) of
            #scale:
              sprite(spr).scale = getAt(Ldata, j)
          end case
        end repeat
    end case
  end repeat
  if updateFlag then
    updateStage()
  end if
end

on clearSprProps LsprNums
  setSprProps(LsprNums, [#mbr: 0, #visible: 0, #ink: #copy, #flipH: 0, #flipV: 0, #rotation: 0, #forecolor: 0, #backcolor: 0])
end

on coerceSprInkID id
  lSprInkIDs = [#copy: 0, #transparent: 1, #trans: 1, #reverse: 2, #ghost: 3, #notCopy: 4, #notTransparent: 5, #notTrans: 5, #notReverse: 6, #notGhost: 7, #matte: 8, #mask: 9, #blend: 32, #addPin: 33, #add: 34, #subtractPin: 35, #subtrPin: 35, #bgTransparent: 36, #bgTrans: 36, #lightest: 37, #subtract: 38, #subtr: 38, #darkest: 39, #lighten: 40, #darken: 41]
  if symbolp(id) then
    num = getaProp(lSprInkIDs, id)
  else
    if integerp(id) then
      num = id
    end if
  end if
  return num
end

on getSprProps spr
  lProps = [#backcolor: sprite(spr).backcolor, #beh: sprite(spr).scriptInstanceList, #blend: sprite(spr).blend, #bottom: sprite(spr).bottom, #constraint: sprite(spr).constraint, #cursor: sprite(spr).cursor, #editable: sprite(spr).editable, #flipH: sprite(spr).flipH, #flipV: sprite(spr).flipV, #forecolor: sprite(spr).forecolor, #height: sprite(spr).height, #ink: sprite(spr).ink, #left: sprite(spr).left, #loc: sprite(spr).loc, #locH: sprite(spr).locH, #locV: sprite(spr).locV, #locZ: sprite(spr).locZ, #memberNum: sprite(spr).member, #moveableSprite: sprite(spr).moveableSprite, #rect: sprite(spr).rect, #right: sprite(spr).right, #rotation: sprite(spr).rotation, #stretch: sprite(spr).stretch, #top: sprite(spr).top, #trails: sprite(spr).trails, #visible: sprite(spr).visible, #width: sprite(spr).width]
  return lProps
end

on shuffleList aList
  if not getOne([#list, #propList], ilk(aList)) then
    return 0
  end if
  numList = count(aList)
  case ilk(aList) of
    #list:
      repeat with i = 1 to numList
        idx = random(numList)
        val = getAt(aList, idx)
        deleteAt(aList, idx)
        addAt(aList, random(numList), val)
      end repeat
    #propList:
      repeat with i = 1 to numList
        idx = random(numList)
        val = getAt(aList, idx)
        prop = getPropAt(aList, idx)
        deleteAt(aList, idx)
        addPropAt(aList, random(numList), prop, val)
      end repeat
  end case
  return aList
end

on keyDown
  if gDebug then
    k = the key
    case gKeyPressed of
      "L":
        case k of
          "1":
            anim = #leaf1
          "2":
            anim = #leaf2
          "3":
            anim = #leaf3
          "4":
            anim = #leaf4
          "5":
            anim = #leaf5
        end case
        gKeyPressed = VOID
      "s":
        case k of
          "1":
            anim = #squirrel1
          "2":
            anim = #squirrel2
          "3":
            anim = #Squirrel3
        end case
        gKeyPressed = VOID
      otherwise:
        case k of
          "f":
            anim = #Flock
            gKeyPressed = VOID
          "w":
            anim = #worker
            gKeyPressed = VOID
          otherwise:
            gKeyPressed = k
        end case
    end case
    if symbolp(anim) then
      Change(goDiorama, [[#name: anim, #State: #on]], 1)
    end if
  end if
end
