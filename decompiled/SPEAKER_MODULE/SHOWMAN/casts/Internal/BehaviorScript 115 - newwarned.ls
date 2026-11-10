global goshowmgr, gomessagemgr, gotoolbox

on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "new without saving"
end

on mouseDown
  setneedtosave(goshowmgr, 0)
  closemessage(gomessagemgr)
  newshow(gotoolbox)
end
