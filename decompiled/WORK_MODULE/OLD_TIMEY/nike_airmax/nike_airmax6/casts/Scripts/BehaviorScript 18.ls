on exitFrame
  global gRoleCallCount, gRoleCallDelay
  set gRoleCallCount to gRoleCallDelay - 20
  puppetSound("stamp.aiff")
  go("Uptempo Shoe")
end
