on getobjectinfo aobject
  set tspropertyinfo to EMPTY
  repeat with i = 1 to count(aobject)
    set tcurproperty to getPropAt(aobject, i)
    set tcurvalue to getaProp(aobject, tcurproperty)
    if tcurproperty <> #pspropertyinfo then
      set tspropertyinfo to tspropertyinfo & tcurproperty & " = " & tcurvalue & RETURN
    end if
  end repeat
  put tspropertyinfo
end

on getscoreinfo
  repeat with n = 1 to 120
    if the loc of sprite n <> point(0, 0) then
      put string(n) & ":" && the name of member the member of sprite n & RETURN
      put the loc of sprite n & RETURN
      put "----------"
    end if
  end repeat
end
