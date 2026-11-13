global gMUIObj, gProxyStr, gPortStr, gProxyMode

on runProxyDialog
  if objectp(gMUIObj) then
    gMUIObj = 0
  end if
  gMUIObj = new(xtra("Mui"))
  if not objectp(gMUIObj) then
    exit
  end if
  proxyDlogDef = getProxyDlogDef()
  Initialize(gMUIObj, proxyDlogDef)
  gProxyStr = EMPTY
  gPortStr = "80"
  Run(gMUIObj)
end

on muiCallback event, eventData, itemPropList
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
        #defaultPushButton:
          stop(gMUIObj, 1)
          gMUIObj = 0
          gProxyMode = #proxy
        #cancelPushButton:
          stop(gMUIObj, 1)
          gMUIObj = 0
          gProxyMode = #noProxy
      end case
    #itemChanged:
      case itemType of
        #editText:
          title = getaProp(itemPropList, #title)
          case title of
            "editProxy":
              str = getaProp(itemPropList, #value)
              gProxyStr = getaProp(itemPropList, #value)
            "editPort":
              str = getaProp(itemPropList, #value)
              if str = EMPTY then
                gPortStr = EMPTY
                exit
              end if
              val = value(str)
              if not integerp(val) then
                beep()
                setaProp(itemPropList, #value, gPortStr)
                ItemUpdate(gMUIObj, 6, itemPropList)
                exit
              else
                if val < 1 then
                  beep()
                  setaProp(itemPropList, #value, gPortStr)
                  ItemUpdate(gMUIObj, 6, itemPropList)
                  exit
                end if
              end if
              gPortStr = getaProp(itemPropList, #value)
          end case
      end case
  end case
end

on setProxyInfo
  if not stringp(gProxyStr) then
    exit
  end if
  if gProxyStr = EMPTY then
    exit
  end if
  if not stringp(gPortStr) then
    exit
  end if
  if gPortStr = EMPTY then
    exit
  end if
  portNum = value(gPortStr)
  if not integerp(portNum) then
    exit
  end if
  if portNum < 1 then
    exit
  end if
  proxyServer(#http, gProxyStr, portNum)
end

on getProxyDlogDef
  return [#windowPropList: [#type: #normal, #name: "Proxy Server Settings", #callback: "muiCallback", #mode: #pixel, #xPosition: -1, #yPosition: -1, #width: 380, #height: 100, #modal: 1, #toolTips: 0, #closeBox: 1, #canZoom: 0], #windowItemList: [[#value: 0, #type: #WindowBegin, #Attributes: [], #title: "title", #tip: "tip", #locH: 20, #locV: 24, #width: 200, #height: 210, #enabled: 1], [#value: 0, #type: #GroupHBegin, #Attributes: [], #title: "title", #tip: "tip", #locH: 20, #locV: 24, #width: 200, #height: 210, #enabled: 1], [#value: "Proxy:", #type: #label, #Attributes: [#textAlign: #right], #title: "title", #tip: "tip", #locH: 10, #locV: 16, #width: 40, #height: 20, #enabled: 1], [#value: EMPTY, #type: #editText, #Attributes: [], #title: "editProxy", #tip: "tip", #locH: 60, #locV: 16, #width: 200, #height: 20, #enabled: 1], [#value: "Port:", #type: #label, #Attributes: [#textAlign: #right], #title: "title", #tip: "tip", #locH: 270, #locV: 16, #width: 40, #height: 20, #enabled: 1], [#value: "80", #type: #editText, #Attributes: [], #title: "editPort", #tip: "tip", #locH: 320, #locV: 16, #width: 40, #height: 20, #enabled: 1], [#value: 0, #type: #GroupHEnd, #Attributes: [], #title: "title", #tip: "tip", #locH: 20, #locV: 24, #width: 200, #height: 210, #enabled: 1], [#value: 0, #type: #GroupHBegin, #Attributes: [], #title: "title", #tip: "tip", #locH: 20, #locV: 24, #width: 200, #height: 210, #enabled: 1], [#value: 0, #type: #cancelPushButton, #Attributes: [], #title: "Cancel", #tip: "tip", #locH: 110, #locV: 55, #width: 60, #height: 24, #enabled: 1], [#value: 0, #type: #defaultPushButton, #Attributes: [], #title: "OK", #tip: "tip", #locH: 210, #locV: 55, #width: 60, #height: 24, #enabled: 1], [#value: 0, #type: #GroupHEnd, #Attributes: [], #title: "title", #tip: "tip", #locH: 20, #locV: 24, #width: 200, #height: 210, #enabled: 1], [#value: 0, #type: #WindowEnd, #Attributes: [], #title: "title", #tip: "tip", #locH: 20, #locV: 24, #width: 200, #height: 210, #enabled: 1]]]
end

on buildProxyDlogDef
  gMUIObj = new(xtra("Mui"))
  lWinProps = GetWindowPropList(gMUIObj)
  lWinProps.name = "Proxy Server Settings"
  lWinProps.callback = "muiCallback"
  lWinProps.width = 380
  lWinProps.height = 100
  lWinProps.mode = #pixel
  lWinProps.xPosition = -1
  lWinProps.yPosition = -1
  lItemProps = []
  lTemplateItemProps = GetItemPropList(gMUIObj)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #WindowBegin)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #GroupHBegin)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #label)
  lAttribs = [#textAlign: #right]
  setaProp(lTempItemProps, #Attributes, lAttribs)
  setaProp(lTempItemProps, #value, "Proxy:")
  setaProp(lTempItemProps, #locH, 10)
  setaProp(lTempItemProps, #locV, 16)
  setaProp(lTempItemProps, #width, 40)
  setaProp(lTempItemProps, #height, 20)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #editText)
  setaProp(lTempItemProps, #title, "editProxy")
  setaProp(lTempItemProps, #locH, 60)
  setaProp(lTempItemProps, #locV, 16)
  setaProp(lTempItemProps, #width, 200)
  setaProp(lTempItemProps, #height, 20)
  setaProp(lTempItemProps, #value, EMPTY)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #label)
  lAttribs = [#textAlign: #right]
  setaProp(lTempItemProps, #Attributes, lAttribs)
  setaProp(lTempItemProps, #value, "Port:")
  setaProp(lTempItemProps, #locH, 270)
  setaProp(lTempItemProps, #locV, 16)
  setaProp(lTempItemProps, #width, 40)
  setaProp(lTempItemProps, #height, 20)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #editText)
  setaProp(lTempItemProps, #title, "editPort")
  setaProp(lTempItemProps, #value, "80")
  setaProp(lTempItemProps, #locH, 320)
  setaProp(lTempItemProps, #locV, 16)
  setaProp(lTempItemProps, #width, 40)
  setaProp(lTempItemProps, #height, 20)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #GroupHEnd)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #GroupHBegin)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #cancelPushButton)
  setaProp(lTempItemProps, #title, "Cancel")
  setaProp(lTempItemProps, #locH, 110)
  setaProp(lTempItemProps, #locV, 55)
  setaProp(lTempItemProps, #width, 60)
  setaProp(lTempItemProps, #height, 24)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #defaultPushButton)
  setaProp(lTempItemProps, #title, "OK")
  setaProp(lTempItemProps, #locH, 210)
  setaProp(lTempItemProps, #locV, 55)
  setaProp(lTempItemProps, #width, 60)
  setaProp(lTempItemProps, #height, 24)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #GroupHEnd)
  add(lItemProps, lTempItemProps)
  lTempItemProps = duplicate(lTemplateItemProps)
  setaProp(lTempItemProps, #type, #WindowEnd)
  add(lItemProps, lTempItemProps)
  gMUIObj = 0
  put [#windowPropList: lWinProps, #windowItemList: lItemProps]
end
