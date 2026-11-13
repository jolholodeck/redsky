global gDebug, gKeyPressed, goDiorama

on keyDown
  if gDebug then
    k = the key
    case gKeyPressed of
      "p":
        case k of
          "1":
            anim = #person1
          "2":
            anim = #person2rt
          "3":
            anim = #person2ctr
        end case
        gKeyPressed = VOID
      otherwise:
        case k of
          "s":
            anim = #snow
            gKeyPressed = VOID
          "h":
            anim = #shootStar
            gKeyPressed = VOID
          "r":
            anim = #rabbit
            gKeyPressed = VOID
          "c":
            anim = #candle
            gKeyPressed = VOID
          "f":
            anim = #fire
            gKeyPressed = VOID
          otherwise:
            gKeyPressed = k
        end case
    end case
    if symbolp(anim) then
      Change(goDiorama, [[#name: anim, #State: #on]], 1)
    end if
  end if
end
