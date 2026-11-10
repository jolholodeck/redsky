global gomessagemgr

on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "on CONTINUE button in message 1"
end

on mouseDown
  closemessage(gomessagemgr)
  makesetup()
end
