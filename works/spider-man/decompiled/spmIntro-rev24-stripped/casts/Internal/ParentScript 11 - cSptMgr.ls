property mNextSpt, mlFreeSpts, kHideLoc
global glGlob

on new this
  mNextSpt = 1
  mlFreeSpts = []
  kHideLoc = point(-10000, 0)
  return this
end

on mDestroy
  voidList(mlFreeSpts)
  mlFreeSpts = VOID
end

on mGetLocZ this, typ
  case typ of
    #load:
      return 1000
    #web:
      return 10000
    #curs:
      return 20000
    #spdr:
      return 30000
    #dna:
      return 40000
    #outro:
      return 50000
    #fade:
      return 99999
    otherwise:
      return 1
  end case
end

on mGetSpt this, typ
  spt = 0
  if mlFreeSpts.count > 0 then
    spt = mlFreeSpts[1]
    mlFreeSpts.deleteAt(1)
  else
    if mNextSpt <= the lastChannel then
      spt = mNextSpt
      mNextSpt = spt + 1
      puppetSprite(spt, 1)
    end if
  end if
  if spt > 0 then
    sprite(spt).ink = 0
    sprite(spt).loc = kHideLoc
    sprite(spt).member = glGlob.dotC
    sprite(spt).locZ = this.mGetLocZ(typ)
  end if
  return spt
end

on mGetSptBank this, typ, num
  bank = []
  locZ = this.mGetLocZ(typ)
  repeat with i = 1 to num
    bank.append(this.mGetSpt(typ))
  end repeat
  repeat with spt in bank
    locZ = locZ + 1
    sprite(spt).locZ = locZ
  end repeat
  return bank
end

on mRlsSpt this, spt
  if spt > 0 then
    mlFreeSpts.append(spt)
    CDH_hideSpt(spt)
  end if
end

on mRlsBank this, bank
  if listp(bank) then
    repeat with spt in bank
      this.mRlsSpt(spt)
    end repeat
  end if
end
