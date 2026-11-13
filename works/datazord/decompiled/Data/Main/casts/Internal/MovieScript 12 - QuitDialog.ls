global gMUIObj, glCBdata

on runQuitDialog pictMbrNum, lCBdata
  if objectp(gMUIObj) then
    gMUIObj = 0
  end if
  gMUIObj = new(xtra("Mui"))
  if not objectp(gMUIObj) then
    exit
  end if
  glCBdata = lCBdata
  quitDlogDef = getQuitDlogDef(pictMbrNum)
  Initialize(gMUIObj, quitDlogDef)
  Run(gMUIObj)
end

on quitCallback event, eventData, itemPropList
  if not objectp(gMUIObj) then
    exit
  end if
  if not symbolp(event) then
    exit
  end if
  if not listp(itemPropList) then
    exit
  end if
  itemType = getaProp(itemPropList, #type)
  case event of
    #itemClicked:
      case itemType of
        #pushButton:
          stop(gMUIObj, 1)
          gMUIObj = 0
          call(glCBdata[2], glCBdata[1], glCBdata[3], #quit)
        #defaultPushButton:
          stop(gMUIObj, 1)
          gMUIObj = 0
          call(glCBdata[2], glCBdata[1], glCBdata[3], #cancel)
      end case
  end case
end

on getQuitDlogDef pictMbrNum
  obj = new(xtra("Mui"))
  pictMbr = member(pictMbrNum, 2)
  pictWidth = pictMbr.width
  pictHeight = pictMbr.height
  border = 10
  labelHeight = 20
  btnWidth = 80
  btnHeight = 24
  winWidth = pictWidth + (border * 2)
  winHeight = pictHeight + labelHeight + btnHeight + (border * 4)
  lWinProps = GetWindowPropList(obj)
  lWinProps.name = "Confirm Datazord Shutdown"
  lWinProps.callback = "quitCallback"
  lWinProps.width = winWidth
  lWinProps.height = winHeight
  lWinProps.mode = #pixel
  lWinProps.xPosition = -1
  lWinProps.yPosition = -1
  lItemProps = []
  lTemplateItemProps = GetItemPropList(obj)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #WindowBegin)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #GroupHBegin)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #bitmap)
  setaProp(lTempItemProps, #value, pictMbr)
  setaProp(lTempItemProps, #locH, border)
  setaProp(lTempItemProps, #locV, border)
  setaProp(lTempItemProps, #width, pictWidth)
  setaProp(lTempItemProps, #height, pictHeight)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #GroupHEnd)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #GroupHBegin)
  add(lItemProps, lTempItemProps)
  labelStr = "Are you sure you want to quit?"
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #label)
  lAttribs = [#textAlign: #left]
  setaProp(lTempItemProps, #attributes, lAttribs)
  setaProp(lTempItemProps, #value, labelStr)
  setaProp(lTempItemProps, #locH, border)
  setaProp(lTempItemProps, #locV, pictHeight + (border * 2))
  setaProp(lTempItemProps, #width, pictWidth)
  setaProp(lTempItemProps, #height, labelHeight)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #GroupHEnd)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #GroupHBegin)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #pushButton)
  setaProp(lTempItemProps, #title, "Quit")
  setaProp(lTempItemProps, #locH, winWidth - (btnWidth * 2) - (border * 2))
  setaProp(lTempItemProps, #locV, winHeight - border - btnHeight)
  setaProp(lTempItemProps, #width, btnWidth)
  setaProp(lTempItemProps, #height, btnHeight)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #defaultPushButton)
  setaProp(lTempItemProps, #title, "Cancel")
  setaProp(lTempItemProps, #locH, winWidth - btnWidth - border)
  setaProp(lTempItemProps, #locV, winHeight - border - btnHeight)
  setaProp(lTempItemProps, #width, btnWidth)
  setaProp(lTempItemProps, #height, btnHeight)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #GroupHEnd)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #WindowEnd)
  add(lItemProps, lTempItemProps)
  obj = 0
  return [#windowPropList: lWinProps, #windowItemList: lItemProps]
end
