on exitFrame
  if timer_gettime(#waitframe) > 210 then
    go(the frame + 1)
  else
    go(the frame)
  end if
  pass()
end

on keyDown
  if the key = SPACE then
    puppetSound("title2")
    flicker_splicecut(1, the frame + 1)
  end if
  pass()
end
