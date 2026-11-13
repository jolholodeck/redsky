on mouseDown me
  sprite(me.spriteNum).member = 101
end

on mouseUp me
  sprite(me.spriteNum).member = 102
end

on mouseUpOutSide me
  sprite(me.spriteNum).member = 102
end
