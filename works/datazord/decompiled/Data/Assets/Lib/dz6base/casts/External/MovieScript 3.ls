on genZorddata
  orig = [#zordID: 1, #enabledLoop: [1789], #disabledLoop: [1775], #targetZordLoop: [1789], #enabledAnim: [1781, 1782, 1783, 1784, 1785, 1786, 1787, 1788, 1789, 1790, 1791, 1792, 1793, 1794, 1793, 1792, 1791, 1790, 1789], #disabledAnim: [1775, 1776, 1777, 1778, 1779, 1780, 1779, 1778, 1777, 1776, 1775]]
  off = 20
  repeat with X = 2 to 6
    lNew = duplicate(orig)
    put string(X) && lNew + off
    off = off + 20
  end repeat
end

on adjustMDZoffsets
  offData = member(4, 4).text
  nbLines = the number of lines in offData
  the itemDelimiter = ","
  root = "wdgData_6.1.1."
  repeat with X = 1 to nbLines
    curLine = line X of offData
    id = value(item 1 of curLine)
    off = value(item 2 of curLine)
    fName = root & string(id)
    mbrNum = member(fName, 4).memberNum
    if mbrNum <= 0 then
      put "not found: " && fName
      exit
    end if
    AdjustWdgDatMemNumRefs([mbrNum], 4, off - 101)
    put "adjusted widget " & fName & " by " & off - 101
  end repeat
end
