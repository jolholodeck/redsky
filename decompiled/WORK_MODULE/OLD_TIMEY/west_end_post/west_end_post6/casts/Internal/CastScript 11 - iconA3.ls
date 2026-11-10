on mouseUp
  global i3
  if not i3 then
    puppetSound("drum1")
    set the visible of sprite 6 to 0
    updateStage()
    set i3 to 1
    stg1_text(3)
  end if
end
