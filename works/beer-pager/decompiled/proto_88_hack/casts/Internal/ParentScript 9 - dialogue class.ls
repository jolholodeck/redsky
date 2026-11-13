property pBgMem, pTextMem, pTextInputMem, pMisc1Mem, pMisc2Mem, pButton1Mem, pButton2Mem, pBgMemLoc, pTextMemLoc, pTextInputMemLoc, pMisc1MemLoc, pMisc2MemLoc, pButton1MemLoc, pButton2MemLoc, pButton1CallBack, pButton2CallBack, pDialogType

on new me, Params
  pBgMem = Params[1]
  pTextMem = Params[2]
  pTextInputMem = Params[3]
  pMisc1Mem = Params[4]
  pMisc2Mem = Params[5]
  pButton1Mem = Params[6]
  pButton2Mem = Params[7]
  locs = Params[10]
  pBgMemLoc = locs[1]
  pTextMemLoc = locs[2]
  pTextInputMemLoc = locs[3]
  pMisc1MemLoc = locs[4]
  pMisc2MemLoc = locs[5]
  pButton1MemLoc = locs[6]
  pButton2MemLoc = locs[7]
  pButton1CallBack = Params[8]
  pButton2CallBack = Params[9]
  pDialogType = Params[11]
  return me
end
