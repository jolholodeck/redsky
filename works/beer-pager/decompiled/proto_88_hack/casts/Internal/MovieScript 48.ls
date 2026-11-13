global oSoundMgr

on playSound bank, program, note, vel, dur
  if voidp(oSoundMgr) then
    exit
  end if
  if ilk(bank) = #symbol then
    soundType = bank
    case soundType of
      #cancel:
        playSound(2, 1, 21, 100, 5000)
      #newMessage:
        playSound(2, 12, 60, 100, 5000)
      #save:
        playSound(2, 17, 101, 100, 5000)
      #accept:
        playSound(2, 15, 110, 100, 2000)
      #decline:
        playSound(2, 15, 76, 100, 2000)
      #cantDoThat:
        playSound(2, 17, 22, 100, 5000)
      #checkBox:
        playSound(2, 1, 119, 100, 5000)
      #radio:
        playSound(2, 7, 45, 75, 1000)
      #calendar:
        playSound(2, 16, 53, 60, 500)
      #selection:
        playSound(2, 1, 16, 50, 500)
      #net1:
        playSound(2, 8, 122, 60)
      #net2:
        playSound(2, 8, 20, 60)
      #net3:
        playSound(2, 8, 81, 60)
      #net44:
        playSound(2, 8, 51, 60)
      #next:
        playSound(2, 1, 31, 50, 500)
      #previous:
        playSound(2, 1, 31, 50, 500)
      #scrollUp:
        playSound(2, 1, 67, 35, 10)
      #scrollDown:
        playSound(2, 1, 67, 35, 10)
      #clear:
        playSound(2, 1, 59, 100, 1000)
      #all:
        playSound(2, 1, 65, 100, 1000)
      #invitePages:
        playSound(2, 1, 16, 75, 100, 1000)
      #checkMessages:
        playSound(2, 7, 77, 77, 7777)
      #help:
        playSound(2, 1, 103, 80, 1000)
      #listView:
        playSound(2, 1, 11, 100, 1000)
      #read:
        playSound(2, 7, 50, 100, 1000)
      #showAll:
        playSound(2, 16, 119, 100, 1000)
      #Ok:
        playSound(2, 16, 54, 100, 5000)
      #topNav:
        playSound(2, 6, 59, 100, 500)
      otherwise:
        playSound(2, 1, 119, 100, 5000)
    end case
  else
    if voidp(bank) then
      bank = 2
    end if
    if voidp(program) then
      program = 1
    end if
    if voidp(note) then
      note = 1
    end if
    if voidp(vel) then
      vel = 100
    end if
    if voidp(dur) then
      dur = 5000
    end if
    oSoundMgr.mPostEvent([#action: #play, #bank: 2, #pgm: program, #note: note, #vel: vel, #dur: dur, #rnd: 0, #ctrl: 0])
  end if
end
