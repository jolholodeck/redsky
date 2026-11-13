on exitFrame
  go(2)
  if netDone() = 1 then
    set the text of member "status" to "True"
  else
    set the text of member "status" to "False"
  end if
end
