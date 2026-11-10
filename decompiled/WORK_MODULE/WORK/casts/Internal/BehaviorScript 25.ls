on mouseDown
  global goWorkMgr
  if the lastClick > 15 then
    exit
  end if
  mShowPopup(goWorkMgr, 3)
end
