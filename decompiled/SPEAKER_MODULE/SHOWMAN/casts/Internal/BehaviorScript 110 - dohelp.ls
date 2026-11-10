global gomessagemgr

on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "does help on message 1"
end

on mouseDown
  closemessage(gomessagemgr)
  domessage(gomessagemgr, 2)
end
