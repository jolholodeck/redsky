property mySprite, myMember
global gDebug, goK

on beginSprite me
  mySprite = sprite(me.spriteNum)
  myMember = mySprite.member
end

on mouseDown me
  if gDebug and the controlDown then
    str = "MoodMaker:" && member("version", "Internal").text & RETURN
    str = str & "Diorama:" && member("version", goK.iLibNumCollDio).text & RETURN
    str = str & "SndScape:" && member("version", goK.iLibNumSndScape).text & RETURN
    alert(str)
  end if
end
