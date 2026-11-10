global gomessagemgr

on new me
  return me
end

on getPropertyDescriptionList
  set p_list to []
  return p_list
end

on getBehaviorDescription
  return "does quit"
end

on mouseDown
  fastquit()
end
