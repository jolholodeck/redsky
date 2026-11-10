global state_ddorpig, sprite_pig, script_pigshoot

on mouseDown
  puppetSound(3, "e_ricochet" & string(random(3)))
  animation_setframe(#changebutton, 2)
  animation_forceupdate(#changebutton)
  set state_ddorpig to #pig
  animation_kill(#dirtydan)
  animation_add(#pig, sprite_pig, -1, 10, 1, script_pigshoot, EMPTY, 0)
  set tempframe to (animation_getframe(#cowboy) mod count(script_pigshoot)) + 1
  animation_setframe(#pig, tempframe)
  animation_forceupdate(#pig)
  animation_setstate(#pig, #playing)
  pass()
end
