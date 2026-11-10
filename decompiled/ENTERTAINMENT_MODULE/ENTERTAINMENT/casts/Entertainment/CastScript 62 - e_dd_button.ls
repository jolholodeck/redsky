global state_ddorpig, sprite_dirtydan, script_ddenter

on mouseDown
  puppetSound(3, "e_ricochet" & string(random(3)))
  animation_setframe(#changebutton, 1)
  animation_forceupdate(#changebutton)
  set state_ddorpig to #dirtydan
  animation_kill(#pig)
  animation_add(#dirtydan, sprite_dirtydan, 1, 10, 1, script_ddenter, EMPTY, 0)
  animation_setframe(#dirtydan, animation_getframe(#cowboy))
  animation_forceupdate(#dirtydan)
  animation_setstate(#dirtydan, #playing)
  pass()
end
