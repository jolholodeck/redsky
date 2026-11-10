global script_x, script_exit, state_cowboy

on mouseEnter
  animation_setscript(#exit, script_exit)
end

on mouseLeave
  animation_setscript(#exit, script_x)
end

on mouseDown
  puppetSound(3, "e_ricochet" & string(random(3)))
  clickModule(#exit)
end
