on mouseDown
  global gSpriteCell1
  set myNumber to the currentSpriteNum - 5
  set myleft to the left of sprite the currentSpriteNum
  set mouseLoc to the mouseH
  set myDistance to abs(mouseLoc - myleft) - 8
  set myCell to (myDistance + 8) / 44
  clickCell(((myNumber - 1) * 8) + myCell + gSpriteCell1)
end
