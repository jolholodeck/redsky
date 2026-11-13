on exitFrame
  preloadMember(member "Shoespin Movie")
  preloadMember(member "swoosh Movie")
  set cnum to the number of member "Nike cursor"
  set mnum to the number of member "Nike cursor mask"
  set the cursor of sprite 10 to [cnum, mnum]
  set the cursor of sprite 19 to [cnum, mnum]
  set the cursor of sprite 37 to [cnum, mnum]
  set the cursor of sprite 40 to [cnum, mnum]
end
