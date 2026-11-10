global goshowmgr

on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "stretch fielld: calls goshowmgr.  on text select rect."
end

on mouseDown
  if not (the shiftDown) then
    stretchfield(goshowmgr)
  end if
end
