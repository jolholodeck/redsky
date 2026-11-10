on mouseUp
  global i4
  if not i4 then
    puppetSound("drum1")
    set the visible of sprite 7 to 0
    set i4 to 1
    stg3_text(4)
    updateStage()
  end if
end
