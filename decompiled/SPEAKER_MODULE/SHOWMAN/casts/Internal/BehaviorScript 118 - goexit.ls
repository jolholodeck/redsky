global gonavigator

on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "Go to Exit"
end

on mouseDown
  goouttomodule(gonavigator, #exit)
end
