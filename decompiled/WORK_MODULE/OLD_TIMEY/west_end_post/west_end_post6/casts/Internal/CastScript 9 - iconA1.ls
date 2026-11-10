on mouseUp
  global i1
  if not i1 then
    puppetSound("drum1")
    set the visible of sprite 4 to 0
    updateStage()
    set i1 to 1
    stg1_text(1)
  end if
end
