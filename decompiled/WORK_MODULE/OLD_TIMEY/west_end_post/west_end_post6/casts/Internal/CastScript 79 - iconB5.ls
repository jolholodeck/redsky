on mouseUp
  global i5
  if not i5 then
    puppetSound("drum1")
    set the visible of sprite 8 to 0
    set i5 to 1
    stg2_text(5)
    updateStage()
  end if
end
