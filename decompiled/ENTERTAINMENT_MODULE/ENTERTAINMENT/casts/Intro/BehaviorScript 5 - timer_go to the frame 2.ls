on exitFrame
  if timer_gettime(#waitframe) > 360 then
    go(the frame + 1)
  else
    go(the frame)
  end if
  pass()
end

on keyDown
  if the key = SPACE then
    puppetSound("title3")
    flicker_splicecut(1, the frame + 1)
  end if
  pass()
end
