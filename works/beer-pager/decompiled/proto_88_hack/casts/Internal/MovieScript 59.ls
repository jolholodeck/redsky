on randomNetSounds
  chance = 5
  roll = random(100)
  if chance > roll then
    snd = random(4)
    case snd of
      1:
        playSound(2, 8, 122, 60)
      2:
        playSound(2, 8, 20, 60)
      3:
        playSound(2, 8, 81, 60)
      4:
        playSound(2, 8, 51, 60)
    end case
  end if
end
