global state_pnumber

on enterFrame
  preloadMember("project" & string(state_pnumber))
  superidleload()
  puppetSound("project" & string(state_pnumber))
  pass()
end
