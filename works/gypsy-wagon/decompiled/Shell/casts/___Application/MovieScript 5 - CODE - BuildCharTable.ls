on dupChars
  set stchr to 33
  set enchr to 126
  repeat with i = stchr to enchr
    set typeTag to "o"
    if (i > 64) and (i < 91) then
      set typeTag to "u"
    end if
    if (i > 96) and (i < 123) then
      set typeTag to "l"
    end if
    set basenam to "abc." & typeTag & "." & numToChar(i) & "."
    set mnam to basenam & "1"
    set mnum to the number of member mnam
    if mnum = -1 then
      set mapval to 1
      next repeat
    end if
    set tmpnm to basenam & "xxx"
    set the name of member mnum to tmpnm
    duplicate(member tmpnm)
    duplicate(member tmpnm)
    repeat with j = 1 to 3
      set mnum to the number of member tmpnm
      set the name of member mnum to basenam & j
    end repeat
  end repeat
end

on antTable
  set gdmoAntPiSection to 3.14159265358000006 / 8
  set angle to 0.0
  set EOL to " " & numToChar(194) & numToChar(13)
  set BOL to "   "
  set block to numToChar(13) & numToChar(13)
  repeat with i = 1 to 16
    set dx to float(sin(angle))
    set dy to float(-cos(angle))
    set thisLine to BOL & "[" & dx & "," & dy & ", "
    repeat with k = 1 to 2
      case k of
        1:
          set basenam to "ant.head."
          set numAnims to 6
        2:
          set basenam to "ant.body."
          set numAnims to 4
      end case
      repeat with j = 1 to numAnims
        set idx to numToChar(96 + j)
        if i < 10 then
          set dir to "0000" & i
        else
          set dir to "000" & i
        end if
        set foo to basenam & idx & "." & dir
        set thisLine to thisLine & "member " & QUOTE & foo & QUOTE
        if (k = 1) or (j < numAnims) then
          set thisLine to thisLine & ", "
        end if
      end repeat
    end repeat
    set block to block & thisLine & "]," & EOL
    set angle to angle + gdmoAntPiSection
  end repeat
  put block & numToChar(13) & numToChar(13)
end

on deadAntTable
  set EOL to " " & numToChar(194) & numToChar(13)
  set BOL to "   "
  set block to numToChar(13) & numToChar(13)
  repeat with i = 1 to 16
    set thisLine to BOL & "["
    set basenam to "ant.dead."
    set numAnims to 3
    repeat with j = 1 to numAnims
      set idx to numToChar(96 + j)
      if i < 10 then
        set dir to "0000" & i
      else
        set dir to "000" & i
      end if
      set foo to basenam & idx & "." & dir
      set thisLine to thisLine & "member " & QUOTE & foo & QUOTE
      if j < numAnims then
        set thisLine to thisLine & ", "
      end if
    end repeat
    set block to block & thisLine & "]," & EOL
  end repeat
  put block & numToChar(13) & numToChar(13)
end

on buildCharTable
  global gdmoQuillCharTable, gdmoQuillAsciiMap
  clearGlobals()
  initAlphabet()
  set kernHold to []
  if listp(gdmoQuillCharTable) and listp(gdmoQuillAsciiMap) then
    put "BuildCharTable:  remembering kerning values"
    repeat with i = 1 to 256
      set cIdx to charTableGetIndex(numToChar(i))
      set chr to getAt(gdmoQuillCharTable, cIdx)
      set kernVal to getAt(chr, 2)
      append(kernHold, kernVal)
    end repeat
  else
    put "BuildCharTable:  no charTable defined.  building from scratch."
  end if
  set EOL to " " & numToChar(194) & numToChar(13)
  set BOL to "   "
  set asciiMap to numToChar(13) & numToChar(13) & "  set gdmoQuillAsciiMap  = [ "
  set charTable to numToChar(13) & numToChar(13) & "  set gdmoQuillCharTable = [ "
  set charIndex to 1
  set asciiCount to 0
  set maxCharHeight to 0
  if the number of member "abc.default" = -1 then
    put "ERROR:  missing " & QUOTE & "abc.default" & QUOTE & " cast member!"
  end if
  set widDflt to the width of member "abc.default"
  set defaultChar to "[ " & widDflt & ",  0, member " & QUOTE & "abc.default" & QUOTE & " ]"
  set charTable to charTable & EOL & BOL & defaultChar
  set charIndex to charIndex + 1
  set stchr to 30
  set enchr to 126
  set carp to 0
  set cbrp to 0
  repeat with i = stchr to enchr
    case i of
      stchr:
        set basenam to "abc.lftarw."
      (stchr + 1):
        set basenam to "abc.rgtarw."
      otherwise:
        set typeTag to "o"
        if (i > 64) and (i < 91) then
          set typeTag to "u"
        end if
        if (i > 96) and (i < 123) then
          set typeTag to "l"
        end if
        set basenam to "abc." & typeTag & "." & numToChar(i) & "."
    end case
    set mnam to basenam & "1"
    set mnum to the number of member mnam
    if mnum = -1 then
      set mapval to 1
    else
      set sptList to EMPTY
      set stroke to 1
      set clrp to 0
      set crrp to 0
      repeat while mnum <> -1
        if stroke > 1 then
          set sptList to sptList & ", "
        end if
        set sptList to sptList & "member " & QUOTE & mnam & QUOTE
        set rgp to the regPoint of member mnum
        set rx to getAt(rgp, 1)
        set ry to getAt(rgp, 2)
        set w to the width of member mnum
        set h to the height of member mnum
        if rx < 0 then
          set lrp to 0
        else
          set lrp to rx
        end if
        if rx < w then
          set rrp to w - rx
        else
          set rrp to 0
        end if
        if ry < 0 then
          set arp to 0
        else
          set arp to ry
        end if
        if ry < h then
          set brp to h - ry
        else
          set brp to 0
        end if
        if lrp > clrp then
          set clrp to lrp
        end if
        if rrp > crrp then
          set crrp to rrp
        end if
        if arp > carp then
          set carp to arp
        end if
        if brp > cbrp then
          set cbrp to brp
        end if
        set stroke to stroke + 1
        set mnam to basenam & stroke
        set mnum to the number of member mnam
      end repeat
      set cwidth to clrp + crrp
      if cwidth < 10 then
        set cWid to "  " & cwidth
      else
        set cWid to " " & cwidth
      end if
      if i > count(kernHold) then
        set ckern to 0
      else
        set ckern to getAt(kernHold, i)
      end if
      if ckern < 10 then
        set cKrn to "  " & ckern
      else
        set cKrn to " " & ckern
      end if
      set thisChar to "[" & cWid & "," & cKrn & ", " & sptList & " ]"
      set charTable to charTable & "," & EOL & BOL & thisChar
      set mapval to charIndex
      set charIndex to charIndex + 1
    end if
    if i > stchr then
      set asciiMap to asciiMap & ","
    end if
    set asciiCount to asciiCount + 1
    if (asciiCount mod 10) = 0 then
      set asciiMap to asciiMap & EOL & BOL
    end if
    set asciiMap to asciiMap & mapval
  end repeat
  set maxCharHeight to carp + cbrp
  set cr to numToChar(13)
  set charTable to charTable & " ]" & cr
  set asciiMap to asciiMap & " ]" & cr
  set maxHeight to cr & cr & "  set gdmoMaxCharHeight  = " & maxCharHeight
  set charDefs to charTable & asciiMap & maxHeight & numToChar(13) & numToChar(13)
  set tc1 to "--/---------------------------------------------------------------------"
  set tc2 to "--|  initAlphabet"
  set tc3 to "--\---------------------------------------------------------------------"
  set tc4 to "global gdmoQuillCharTable, gdmoQuillAsciiMap, gdmoMaxCharHeight"
  set tc5 to "on initAlphabet"
  set tc6 to "end"
  set tca to tc1 & cr & tc2 & cr & tc3 & cr & tc4 & cr & cr & cr & tc5
  set tcb to charTable & asciiMap & maxHeight & cr & cr & tc6 & cr
  set the scriptText of member "CODE - CharTable" to tca & tcb
  put tca & tcb
  put 
  put "*** ABOVE SCRIPT HAS BEEN INTEGRATED INTO MOVIE ***"
  put "***        (PRINTED JUST FOR REFERENCE)         ***"
end
