on setCursor
  if the machineType = 256 then
    cursor([the memberNum of member "pcHand", the memberNum of member "pcHand" + 1])
  else
    cursor([the memberNum of member "mHand", the memberNum of member "mHand" + 1])
  end if
end
