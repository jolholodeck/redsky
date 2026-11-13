property pMySpr, aMember

on beginSprite me
  pMySpr = me.spriteNum
  aMember = sprite(pMySpr).member
end

on displayElipse me
  aMember = member("input")
  if aMember.type <> #field then
    exit
  end if
  aString = aMember.text
  vPos = aMember.lineHeight / 2
  aLastChar1 = locToCharPos(aMember, point(190, vPos))
  aLastChar2 = locToCharPos(aMember, point(130, 0))
  if (aLastChar2 - aLastChar1) >= 3 then
    aEnd = aLastChar1
    aDisplayString = char 1 to aEnd of aString
    aDisplayString = aDisplayString & "..."
  else
    aDisplayString = aString
  end if
  aMember = member("display")
  if aMember.type <> #field then
    exit
  end if
  aMember.text = aDisplayString
end
