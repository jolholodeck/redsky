global gotoolbox

on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "click project: calls gotoolbox"
end

on mouseDown
  clickproject(gotoolbox)
end
