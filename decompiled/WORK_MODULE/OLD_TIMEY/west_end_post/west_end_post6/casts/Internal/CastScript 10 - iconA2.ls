on mouseUp
  global i2
  if not i2 then
    puppetSound("drum1")
    set the visible of sprite 5 to 0
    updateStage()
    set i2 to 1
    stg1_text(2)
  end if
end
