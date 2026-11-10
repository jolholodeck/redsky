on exitFrame
  global oldMouseH, oldMouseV
  if (the mouseH <> oldMouseH) or (the mouseV <> oldMouseV) then
    go("d")
  end if
  checkforIdle()
end
