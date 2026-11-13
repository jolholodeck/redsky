property ancestor

on new me
  ancestor = new(script("Root"))
  return me
end

on mChangeProp me, whichProp, whatData
  case whichProp of
  end case
end

on mErrorAlert me, errorType
  case errorType of
    #errorType:
      alert("ERROR MESSAGE")
  end case
end
