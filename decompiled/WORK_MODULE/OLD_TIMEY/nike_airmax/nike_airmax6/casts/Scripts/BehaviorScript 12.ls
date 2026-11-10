on enterFrame
  global maxLocX, maxLocY, gCrntMode
  set the locH of sprite 30 to 730
  puppetSprite(30, 0)
  set the castNum of sprite 9 to cast "Max squished"
  set the locH of sprite 9 to maxLocX + 15
  set the locV of sprite 9 to maxLocY
  puppetSprite(10, 1)
  set the locH of sprite 10 to maxLocX + 35
  set the locV of sprite 10 to maxLocY - 65
  updateStage()
end
