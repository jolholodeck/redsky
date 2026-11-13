global gxFPSframecount, gxFPStimerstart, gxStartUpMem, gxLastMem

on cg
  clearGlobals()
end

on mxy
  put "mouse xy: ", the mouseH, the mouseV
end

on checkBitDepth
  set n1bit to 0
  set n2bit to 0
  set n4bit to 0
  set n8bit to 0
  set n16bit to 0
  set n32bit to 0
  set totCasts to 0
  set totBitmaps to 0
  repeat with clib = 1 to the number of castLibs
    repeat with mnum = 1 to the number of castMembers of castLib clib
      set totCasts to totCasts + 1
      if the type of member mnum of castLib clib = #bitmap then
        set totBitmaps to totBitmaps + 1
        case the depth of member mnum of castLib clib of
          1:
            set n1bit to n1bit + 1
          2:
            set n2bit to n2bit + 1
          4:
            set n4bit to n4bit + 1
          8:
            set n8bit to n8bit + 1
          16:
            set n16bit to n16bit + 1
          32:
            set n32bit to n32bit + 1
          otherwise:
            put "ERR: unknown bitdepth!  member: ", the name of member mnum of castLib clib, " depth: ", the depth of member mnum of castLib clib
        end case
      end if
    end repeat
  end repeat
  put 
  put " total cast members: ", totCasts
  put "  number of bitmaps: ", totBitmaps
  put "  1 bit:   ", n1bit
  put "  2 bit:   ", n2bit
  put "  4 bit:   ", n4bit
  put "  8 bit:   ", n8bit
  put "  16 bit:  ", n16bit
  put "  32 bit:  ", n32bit
end

on initFreeMemCheck
  set gxStartUpMem to the freeBytes
  set gxLastMem to the freeBytes
  put "FreeMem on startup:  " & gxStartUpMem / 1024 & "K"
end

on updateFreeMemCheck
  put 
  put "MemCheck:   free: " & the freeBytes / 1024 & "K, " & "used: " & (gxStartUpMem - the freeBytes) / 1024 & "K, " & "change: " & (gxLastMem - the freeBytes) / 1024 & "K"
  put "Largest Free Block:  " & the freeBlock / 1024 & "K"
  set gxLastMem to the freeBytes
end

on initFramesPerSecTimer
  set gxFPStimerstart to the timer
  set gxFPSframecount to 0
end

on updateFramesPerSecTimer
  set gxFPSframecount to gxFPSframecount + 1
  if (the timer - gxFPStimerstart) > 999 then
    set dsec to (the timer - gxFPStimerstart) / 60
    put gxFPSframecount && "frames at" && gxFPSframecount / dsec && "fps."
    initFramesPerSecTimer()
  end if
end

on centerRegPoint castMember
  if the number of member castMember = -1 then
    put "ERR: member <" & castMember & "> doesnt exist."
    exit
  end if
  set w to the width of member castMember
  set h to the height of member castMember
  set rp to the regPoint of member castMember
  set the regPoint of member castMember to point(w / 2, h / 2)
  put "size = (" & w & "," & h & ")"
  put "old regPoint = ", rp
  put "new regPoint = ", the regPoint of member castMember
end

on spinfo x
  set c to the castNum of sprite x
  if c = 0 then
    put "sprite" && x & ": (channel empty)"
  else
    put "sprite" && x & ": " && the loc of sprite x & ", " && "castnum:" & c && "(" & the name of cast c & ")"
  end if
end

on spdump x, y
  set i to x - 1
  repeat while i < y
    set i to i + 1
    sptinfo(i)
  end repeat
end

on scinfo
  set i to 0
  set cnt to 0
  repeat while i < 48
    set i to i + 1
    set c to the castNum of sprite i
    if c > 0 then
      set cnt to cnt + 1
    end if
  end repeat
  put "frame" && the frame & ": " && cnt && "channels used, " && 48 - cnt && "free."
end

on changeNames
end

on dupMembers
end

on liftMarker mrkr, spt
  if voidp(spt) or voidp(mrkr) then
    put "Syntax:  liftMarker marker, spriteChannel"
    exit
  end if
  set thisCycle to mrkr
  set cr to numToChar(13)
  set EOL to " " & numToChar(194) & numToChar(13)
  set BOL to "   "
  set animob to cr & cr & BOL & "set " & thisCycle & " = list(" & EOL
  go(thisCycle)
  repeat while the type of sprite spt > 0
    set s1 to BOL & "list( member " & QUOTE
    set s2 to the name of the member of sprite spt
    set s3 to QUOTE & ",  " & the loc of sprite spt & " )," & EOL
    set animob to animob & s1 & s2 & s3
    go(the frame + 1)
  end repeat
  set animob to animob & BOL & "list( -99, point(0,0) ) )" & cr & cr
  put animob
end

on liftCycles spt
  if spt = 0 then
    put "Syntax:  liftCycles spriteChannel"
    exit
  end if
  set markers to the labelList
  set cr to numToChar(13)
  set EOL to " " & numToChar(194) & numToChar(13)
  set BOL to "   "
  set totMarks to the number of lines in markers - 1
  repeat with i = 1 to totMarks
    set thisCycle to line i of markers
    set animob to cr & cr & BOL & "set " & thisCycle & " = list(" & EOL
    go(thisCycle)
    repeat while (the frameLabel <> line (i + 1) of markers) and (the type of sprite spt > 0)
      set s1 to BOL & "list( member " & QUOTE
      set s2 to the name of the member of sprite spt
      set s3 to QUOTE & ",  " & the loc of sprite spt & " )," & EOL
      set animob to animob & s1 & s2 & s3
      go(the frame + 1)
    end repeat
    set animob to animob & BOL & "list( -99, point(0,0) ) )" & cr & cr
    put animob
  end repeat
end
