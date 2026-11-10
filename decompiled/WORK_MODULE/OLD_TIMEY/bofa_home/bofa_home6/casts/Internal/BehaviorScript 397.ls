on enterFrame
  global squigglyChannel
  turnoffPuppets()
  puppetSprite(squigglyChannel, 0)
end

on exitFrame
  turnoffPuppets()
end
