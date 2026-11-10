on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "Deselect Component on click background"
end

on mouseDown
  global goshowmgr
  deselect(goshowmgr, #update)
end
