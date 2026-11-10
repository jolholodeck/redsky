global gotoolbox

on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "Make Frame loop"
end

on exitFrame
  rollovertoolbox(gotoolbox)
  go(the frame)
end
