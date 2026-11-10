on startMovie
  global g.obj.SystemManager
  initText(153, 222)
  set the keyDownScript to "checkForExitKey()"
end

on initText firstField, lastField
  if the machineType = 256 then
    repeat with i = firstField to lastField
      if the type of member i = #field then
        if the textSize of field i = 12 then
          set the textHeight of member i to 12
        end if
      end if
    end repeat
  end if
end
