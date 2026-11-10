global gomessagemgr

on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "On OK button in all messages.  calls gomessagemgr"
end

on mouseDown
  closemessage(gomessagemgr)
end
