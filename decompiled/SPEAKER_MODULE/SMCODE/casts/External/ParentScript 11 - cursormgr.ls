property psscriptname, pipointfingermem, pipointfingermask, piclosehandmem, piclosehandmask, piopenhandmem, piopenhandmask, pibulletmem, pibulletmask, plcursors

on new me
  set psscriptname to "cursormgr"
  return me
end

on init me
  set pipointfingermem to getOne(glmembers, "pointfingermem")
  set pipointfingermask to getOne(glmembers, "pointfingermask")
  set piclosehandmem to getOne(glmembers, "closehandmem")
  set piclosehandmask to getOne(glmembers, "closehandmask")
  set piopenhandmem to getOne(glmembers, "openhandmem")
  set piopenhandmask to getOne(glmembers, "openhandmask")
  set pibulletmem to getOne(glmembers, "Bulletcursor")
  set pibulletmask to getOne(glmembers, "BulletMask")
  set plcursors to [#none: 0, #ARROW: -1, #IBEAM: 1, #CROSSHAIR: 2, #CROSSBAR: 3, #WATCH: 4, #BLANK: 200]
end

on cursorpoint me
  cursor([pipointfingermem, pipointfingermask])
end

on cursorgrab me
  cursor([piclosehandmem, piclosehandmask])
end

on cursorhand me
  cursor([piopenhandmem, piopenhandmask])
end

on cursorbullet me
  cursor([pibulletmem, pibulletmask])
end

on cursornumber me, anum
  cursor(getProp(plcursors, anum))
end

on cleanup me
end
