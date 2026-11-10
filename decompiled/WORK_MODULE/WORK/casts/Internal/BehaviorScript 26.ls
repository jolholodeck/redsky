on mouseDown
  global goWorkMgr
  if the lastClick > 15 then
    exit
  end if
  mSelectItemFromPopup(goWorkMgr)
end
