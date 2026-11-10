on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "Flicker Frame loop"
end

on exitFrame
  timer_idle()
  go(the frame)
end
