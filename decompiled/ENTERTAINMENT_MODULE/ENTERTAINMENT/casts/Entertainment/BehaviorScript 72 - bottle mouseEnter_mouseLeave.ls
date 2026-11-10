global sprite_bottlearrow, script_bottlearrow, sprite_bottle, script_bottleexplode

on mouseEnter
  if animation_exists(#bottleexplode) or animation_exists(#bottlearrow) then
    exit
  end if
  animation_add(#bottlearrow, sprite_bottlearrow, -1, 10, 0, script_bottlearrow, EMPTY, 0)
  animation_setstate(#bottlearrow, #playing)
end

on mouseLeave
  if animation_exists(#bottleexplode) then
    exit
  end if
  if animation_exists(#bottlearrow) then
    animation_kill(#bottlearrow)
  end if
end

on mouseDown
  puppetSound(3, "e_shoot_bottle" & string(random(2)))
  if animation_exists(#bottlearrow) then
    animation_kill(#bottlearrow)
  end if
  animation_add(#bottleexplode, sprite_bottlearrow, 1, 20, 0, script_bottleexplode, "clickModule(#work)", 0)
  animation_setstate(#bottleexplode, #playing)
end
