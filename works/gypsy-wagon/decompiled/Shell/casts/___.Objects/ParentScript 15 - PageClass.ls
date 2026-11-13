property itemsOnPage, numColumns, topIndex, botIndex, colIndex, heightPerEntry

on new this
  set the itemsOnPage of this to 1
  set the numColumns of this to 1
  set the topIndex of this to 1
  set the botIndex of this to 1
  set the colIndex of this to 1
  set the heightPerEntry of this to 1
  return this
end

on dump this
  put " Page Object: ", this
  put "  items on page: " & the itemsOnPage of this
  put "  num columns:   " & the numColumns of this
  put "  top index:     " & the topIndex of this
  put "  bot index:     " & the botIndex of this
  put "  col index:     " & the colIndex of this
  put "  entry height:  " & the heightPerEntry of this
end
