global goshowmgr, gomessagemgr

on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "open without saving"
end

on mouseDown
  setneedtosave(goshowmgr, 0)
  closemessage(gomessagemgr)
  doopenwarned(gotoolbox)
end
