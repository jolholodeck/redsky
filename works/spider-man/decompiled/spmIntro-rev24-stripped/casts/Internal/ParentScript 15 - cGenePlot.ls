property pMode, mParent, mX0, mY0, mWidth, mHeight, mlHist1, mlHist2, mlSeeds1, mlSeeds2, mSeedCnt, mSeedWid, mSeedWid2, mCellX, mCellY, mBandY, mCmidY, mCtigY
global glGlob, gSptMgr, gSndMgr, gFrmTm, mlYacSpts, mlBandSpts, mlCmidSpts, mlCtigSpts, mLineSpt

on new this, prnt, rct
  this.mInitMode(#init)
  mParent = prnt
  mX0 = rct[1]
  mY0 = rct[2]
  mWidth = rct[3] - rct[1]
  mHeight = rct[4] - rct[2]
  this.mInitSptBank(mlYacSpts)
  this.mInitSptBank(mlBandSpts)
  this.mInitSptBank(mlCmidSpts)
  this.mInitSptBank(mlCtigSpts)
  mLineSpt.member = glGlob.rct
  mLineSpt.loc = glGlob.hideLoc
  mLineSpt.trails = 1
  mLineSpt.ink = 0
  mLineSpt.forecolor = 0
  mLineSpt.blend = 50
  mCellX = 4
  mCellY = 6
  mBandY = mY0 + (mHeight / 3)
  mCtigY = mY0 + (mHeight / 2)
  mCmidY = mY0 + (2 * mHeight / 3)
  nBins = mWidth / mCellX
  mlHist1 = []
  mlHist2 = []
  repeat with i = 1 to nBins
    mlHist1.append(0)
    mlHist2.append(0)
  end repeat
  mSeedCnt = 8
  mSeedWid = nBins / mSeedCnt
  mSeedWid2 = mSeedWid / 2
  mlSeeds1 = []
  repeat with i = 0 to mSeedCnt - 1
    mlSeeds1.append((i * mSeedWid) + (mSeedWid2 / 2) + random(mSeedWid2 / 2))
  end repeat
  mSeedWid = mSeedWid + 10
  mSeedWid2 = mSeedWid2 + 5
  mlSeeds2 = []
  repeat with i = 1 to nBins
    if random(2) = 1 then
      mlSeeds2.append(i)
    end if
  end repeat
  return this
end

on mDestroy this
  repeat with spt in mlYacSpts
    CDH_hideSpt(spt)
  end repeat
  repeat with spt in mlBandSpts
    CDH_hideSpt(spt)
  end repeat
  repeat with spt in mlCmidSpts
    CDH_hideSpt(spt)
  end repeat
  repeat with spt in mlCtigSpts
    CDH_hideSpt(spt)
  end repeat
  CDH_hideSpt(mLineSpt.spriteNum)
  voidList(mlSeeds1)
  voidList(mlSeeds2)
  voidList(mlHist1)
  voidList(mlHist2)
  mlHist1 = VOID
  mlHist2 = VOID
  mlSeeds1 = VOID
  mlSeeds2 = VOID
  mParent = VOID
end

on mInitSptBank this, bank
  repeat with spt in bank
    sprite(spt).member = glGlob.rct
    sprite(spt).loc = glGlob.hideLoc
    sprite(spt).trails = 1
    sprite(spt).ink = 0
    sprite(spt).forecolor = 0
  end repeat
end

on mUpdate this
  case pMode of
    #Run:
      cnt = mlYacSpts.count
      repeat with i = 1 to cnt
        seed = random(mlSeeds1.count)
        bin = mlSeeds1[seed] + random(mSeedWid) - mSeedWid2
        if (bin > 0) and (bin < mlHist1.count) then
          y = mlHist1[bin]
          mlHist1[bin] = y + 1
          spt1 = sprite(mlYacSpts[i])
          spt2 = sprite(mlBandSpts[i])
          x = mX0 + (bin * mCellX)
          spt1.locH = x
          spt1.locV = mY0 + (y * mCellY)
          spt1.width = mCellX + random(3) - 2
          spt1.height = mCellY - 2
          spt1.blend = 85
          w = y / 3
          if w > mCellX then
            w = mCellX
          end if
          blnd = 5 * y
          if blnd > 85 then
            blnd = 85
          end if
          spt2.locH = x
          spt2.locV = mBandY
          spt2.width = w
          spt2.height = mCellY * 2
          spt2.blend = blnd
        end if
      end repeat
      cnt = mlCmidSpts.count
      repeat with i = 1 to cnt
        bin = mlSeeds2[random(mlSeeds2.count)]
        if (bin > 0) and (bin < mlHist2.count) then
          y = mlHist2[bin]
          if random(20) = 1 then
            y = y + 1
          end if
          mlHist2[bin] = y + 1
          spt1 = sprite(mlCmidSpts[i])
          spt2 = sprite(mlCtigSpts[i])
          x = mX0 + (bin * mCellX)
          h = (mCellY / 2) - 1
          w = (mCellX / 3) + random(2) - 1
          spt1.locH = x
          spt1.locV = mCmidY + (y * mCellY / 2)
          spt1.width = w
          spt1.height = h
          spt1.blend = 30
          y = y / 5
          spt2.locH = x
          spt2.locV = mCtigY + (y * mCellY / 2)
          spt2.width = w + random(2) - 1
          spt2.height = h
          spt1.blend = 50
        end if
      end repeat
      if random(6) = 1 then
        mLineSpt.locH = x
        mLineSpt.locV = mY0
        mLineSpt.width = 1
        mLineSpt.height = mHeight
        mLineSpt.blend = 10 + random(30)
      end if
  end case
end

on mInitMode this, m
  pMode = m
end
