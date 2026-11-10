on mouseUp
  global i2
  if not i2 then
    puppetSound("drum1")
    set the visible of sprite 5 to 0
    set i2 to 1
    stg3_text(2)
    updateStage()
  end if
end
