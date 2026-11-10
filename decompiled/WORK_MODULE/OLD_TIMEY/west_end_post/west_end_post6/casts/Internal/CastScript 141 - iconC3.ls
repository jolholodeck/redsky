on mouseUp
  global i3
  if not i3 then
    puppetSound("drum1")
    set the visible of sprite 6 to 0
    set i3 to 1
    stg3_text(3)
    updateStage()
  end if
end
