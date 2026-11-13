property mParent, mlSpts, mLoc, mScl, mlNodes, mlMap, mCnt, mDone
global glGlob, gDNAgfx, gDNAgrid, gSptMgr

on new this, prnt, loc, scale, spt1, spt2
  mParent = prnt
  mlSpts = VOID
  mlMap = VOID
  mlMap = []
  repeat with i = 1 to 10
    mlMap.append([0, 0, 0, 0, 0])
  end repeat
  mlSpts = [spt1, spt2]
  cnt = mlSpts.count
  repeat with i = 1 to cnt
    spt = mlSpts[i]
    sprite(spt).trails = 1
    sprite(spt).ink = 36
  end repeat
  return this
end

on mInit this, loc, scale
  mlNodes = []
  mScl = scale
  mCnt = 0
  mLoc = loc
  mDone = random(50) + 40
  repeat with row in mlMap
    repeat with i = 1 to row.count
      row[i] = 0
    end repeat
  end repeat
  this.mAddNode(random(5), 5, loc)
end

on mHideSpts this
  cnt = mlSpts.count
  repeat with i = 1 to cnt
    sptObj = sprite(mlSpts[i])
    sptObj.ink = 0
    sptObj.loc = glGlob.hideLoc
    sptObj.locZ = 1
    sptObj.blend = 100
    sptObj.stretch = 0
    sptObj.flipH = 0
    sptObj.trails = 0
    sptObj.forecolor = 255
    sptObj.member = glGlob.dotC
  end repeat
end

on mDestroy this
  this.mHideSpts()
  voidList(mlSpts)
  mlSpts = VOID
  voidList(mlMap)
  mlMap = VOID
  voidList(mlNodes)
  mlNodes = VOID
  mParent = VOID
end

on mSpawn this
  mParent.mCreateDNA(mLoc, 1)
  mParent.mCreateDNA(mLoc, 1)
end

on mAddNode this, x, y, loc
  if (y > 0) and (y <= mlMap.count) then
    if mlMap[y][x] = 0 then
      mlNodes.add([x, y, loc])
      mCnt = mCnt + 1
    end if
  end if
end

on mUpdate this
  repeat with spt in mlSpts
    if (mlNodes.count < 1) or (mCnt > mDone) then
      mParent.mStopDNA(this)
      exit repeat
      next repeat
    end if
    n = random(mlNodes.count)
    nd = mlNodes[n]
    mlNodes.deleteAt(n)
    x = nd[1]
    y = nd[2]
    loc = nd[3]
    cell = gDNAgrid[2 - (y mod 2)][x]
    mbr = gDNAgfx[cell.mbr]
    sptObj = sprite(spt)
    sptObj.member = mbr
    sptObj.width = mScl * mbr.width
    sptObj.height = mScl * mbr.height
    sptObj.flipH = cell.flp
    sptObj.loc = loc
    sptObj.blend = 75
    mlMap[y][x] = 1
    repeat with newNode in cell.pth
      this.mAddNode(x + newNode[1], y + newNode[2], loc + (mScl * newNode[3]))
    end repeat
  end repeat
end
