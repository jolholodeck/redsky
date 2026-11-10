on recipeHelp
  ding()
  set s1 to the text of cast "statusBox1"
  set s2 to the text of cast "statusBox2"
  status(0, " ")
  status(1, "Click a Primary" & RETURN & "Ingredient ....")
  holdIt(1)
  set the castNum of sprite 24 to the number of member "pi-1b"
  updateStage()
  holdIt(1)
  set the castNum of sprite 23 to the number of member "pi-2b"
  updateStage()
  holdIt(1)
  set the castNum of sprite 22 to the number of member "pi-3b"
  updateStage()
  holdIt(1)
  set the castNum of sprite 21 to the number of member "pi-4b"
  updateStage()
  holdIt(1)
  set the castNum of sprite 20 to the number of member "pi-5b"
  updateStage()
  holdIt(1)
  set the castNum of sprite 19 to the number of member "pi-6b"
  updateStage()
  holdIt(1)
  set the castNum of sprite 18 to the number of member "pi-7b"
  updateStage()
  holdIt(5)
  if _piArg <> 7 then
    set the castNum of sprite 18 to the number of member "pi-7a"
    updateStage()
  end if
  holdIt(1)
  if _piArg <> 6 then
    set the castNum of sprite 19 to the number of member "pi-6a"
    updateStage()
  end if
  holdIt(1)
  if _piArg <> 5 then
    set the castNum of sprite 20 to the number of member "pi-5a"
    updateStage()
  end if
  holdIt(1)
  if _piArg <> 4 then
    set the castNum of sprite 21 to the number of member "pi-4a"
    updateStage()
  end if
  holdIt(1)
  if _piArg <> 3 then
    set the castNum of sprite 22 to the number of member "pi-3a"
    updateStage()
  end if
  holdIt(1)
  if _piArg <> 2 then
    set the castNum of sprite 23 to the number of member "pi-2a"
    updateStage()
  end if
  holdIt(1)
  if _piArg <> 1 then
    set the castNum of sprite 24 to the number of member "pi-1a"
    updateStage()
  end if
  holdIt(1)
  ding()
  status(2, " ... or a Recipe Type.")
  holdIt(1)
  set the castNum of sprite 32 to the number of member "check"
  updateStage()
  holdIt(1)
  set the castNum of sprite 33 to the number of member "check"
  updateStage()
  holdIt(1)
  set the castNum of sprite 34 to the number of member "check"
  updateStage()
  holdIt(1)
  set the castNum of sprite 35 to the number of member "check"
  updateStage()
  holdIt(1)
  set the castNum of sprite 36 to the number of member "check"
  updateStage()
  holdIt(5)
  if _typeArg <> 1 then
    set the castNum of sprite 32 to the number of member "_null"
    updateStage()
  end if
  holdIt(1)
  if _typeArg <> 2 then
    set the castNum of sprite 33 to the number of member "_null"
    updateStage()
  end if
  holdIt(1)
  if _typeArg <> 3 then
    set the castNum of sprite 34 to the number of member "_null"
    updateStage()
  end if
  holdIt(1)
  if _typeArg <> 4 then
    set the castNum of sprite 35 to the number of member "_null"
    updateStage()
  end if
  holdIt(1)
  if _typeArg <> 5 then
    set the castNum of sprite 36 to the number of member "_null"
    updateStage()
  end if
  holdIt(1)
  status(1, s1)
  status(2, s2)
end

on recipeSprites state
  set the text of cast "piRolloverText" to " "
  repeat with n = 17 to 24
    set the puppet of sprite n to state
  end repeat
  repeat with n = 32 to 36
    set the puppet of sprite n to state
  end repeat
  repeat with n = 42 to 44
    set the puppet of sprite n to state
  end repeat
end

on getPotatoFact
  set the text of cast "pFact" to getAt(_factList, random(24))
end

on clickAddButton
  click()
  if _piArg = 0 then
    ding()
    repeat with n = 1 to 3
      status(1, "Click a Primary Ingredient" & RETURN & "above.")
      status(1, " ")
    end repeat
    status(1, "Click a Primary Ingredient" & RETURN & "above.")
    status(2, " ")
  else
    if _typeArg = 0 then
      ding()
      repeat with n = 1 to 3
        status(1, "Click a Recipe Type" & RETURN & "at left.")
        status(1, " ")
      end repeat
      status(1, "Click a Recipe Type" & RETURN & "at left.")
      status(2, " ")
    else
      addARecord()
    end if
  end if
end

on loadPotatoFacts
  set _factList to ["One medium potato has 110 calories."]
  append(_factList, "The potato is the second most consumed food in the U.S. - trailing only behind milk products.")
  append(_factList, "In 1992 the per capita consumption of potatoes was 133.4 pounds.")
  append(_factList, "Potatoes are grown in every state of the United States.")
  append(_factList, "Always store potatoes in a cool, dark place that is well ventilated.")
  append(_factList, "The ideal storage temperature for potatoes is 45-50 degrees Fahrenheit.")
  append(_factList, "Potatoes should never be refrigerated.")
  append(_factList, "When buying potatoes, select ones that are firm and smooth and fairly clean.")
  append(_factList, "There is no need to peel potatoes.  You'll save time and keep all the fiber.")
  append(_factList, "The four main varieties of potatoes are: Russets, Long Whites, Round Whites, and Round Reds.")
  append(_factList, "Potatoes are America's Favorite Vegetable.")
  append(_factList, "February is " & QUOTE & "National Potato Lover's Month." & QUOTE)
  append(_factList, "The Inca Indians of Peru were the first to cultivate potatoes in 200 B.C.")
  append(_factList, "In 1719, the Irish brought potatoes to the United States.")
  append(_factList, "During the Alaskan Klondike gold rush, potatoes were so valued for their vitamin C content that the miners traded gold for potatoes.")
  append(_factList, "Potatoes and corn account for 28 to 37 percent of the food supply in developing nations.")
  append(_factList, "Potatoes produce more calories and protein per acre than any other crop.")
  append(_factList, "The potato is both a starch and a fresh vegetable.")
  append(_factList, "One medium potato supplies 610 mg of potassium while a medium banana contains 450 mg.")
  append(_factList, "The tomato is a relative of the potato.")
  append(_factList, "Buttermilk and potatoes were the only foods readily available to the Irish during the early 19th century.")
  append(_factList, "Potatoes became fashionable in America when Thomas Jefferson served them at the White House.")
  append(_factList, "Luther Burbank is the father of the Russet potato.")
  append(_factList, "Potatoes were the first item in the produce section to display a nutrition label.")
end
