global goshowmgr, gtextborderon

on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "select and move: calls goshowmgr.  on components to select and move them"
end

on mouseDown
  select(goshowmgr)
  if the shiftDown then
    move(goshowmgr)
  end if
end

on keyDown
  removeborder(goshowmgr)
  pass()
end
