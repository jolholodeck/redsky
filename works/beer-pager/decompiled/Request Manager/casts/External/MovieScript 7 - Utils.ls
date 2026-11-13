global oRequestMgr, oConnectoScope, oSong, oSoundMgr, kMyId

on help
  put "REQUEST MANAGER DEBUGGER COMMANDS:"
  put EMPTY
  put "[h]ello             -- get simple response from server"
  put "[t]imesync          -- get server offsets for getdate and gettime"
  put "[r]egisteruser      -- create new user on server database."
  put "[c]onnect           -- logon with screen name and password"
  put "[f]induser          -- returns user's screen name and id if user exists"
  put "[p]ostmeeting       -- uh, post a meeting"
  put "[g]etmeeting        -- get meeting from server"
  put "[l]istmeetings      -- list all meetings for current user"
  put "[i]nfectUser        -- send mail to a friend"
  put "cancelmeeting       -- cancel"
  put "acceptmeeting       -- accept"
  put "declinemeeting      -- decline"
  put "forgotpassword      -- sends an e-mail containing the password to the user"
  put "putprefs            -- saves prefs to server"
  put "getprefs            -- get prefs from server"
  put EMPTY
  put "playsound           -- use beatnik to play a sound"
  put "checkconnection*    -- get most recent verdict from connectoscope."
  put "gettime             -- get local time plus server offset"
  put "getdate             -- get server adjusted date"
  put "readme              -- this is the request manager readme"
  put "selftest            -- run all commands"
  put EMPTY
  put "* Coming soon."
end

on selfTest
  hello()
  registerUser()
  connect()
  FindUser()
  postMeeting()
  getmeeting()
  listMeetings()
  CancelMeeting()
  AcceptMeeting()
  DeclineMeeting()
  ForgotPassword()
  saveprefs()
  playSound()
  playSound()
end

on hello
  nothing()
  oRequestMgr.mHello()
end

on h
  hello()
end

on readme
  put member("Read Me", "Request Manager").text
end

on timeSync
  if not voidp(kMyId) then
    oRequestMgr.mTimeSync(kMyId)
  end if
end

on t
  timeSync()
end

on getTime
  put oRequestMgr.mGetTime()
end

on getDate
  put oRequestMgr.mGetDate()
end

on registerUser
  Args = [#sFirstName: "Adam", #sLastName: "Kane", #sDOB: "4/1/69", #sZipCode: "94703", #sEmail: "adam@redsky.com", #sScreenName: "pk" & random(1), #sPassword: "fish", #sOptIn: "huh?", #sConnectSpeed: "28.8", #sGender: "Unknown"]
  oRequestMgr.mRegisterUser(Args, 0, 0)
end

on r
  registerUser()
end

on connect screenName, Password
  if voidp(screenName) then
    screenName = "pk1"
    Password = "fish"
  end if
  oRequestMgr.mConnect(screenName, Password)
end

on c screenName, Password
  connect(screenName, Password)
end

on FindUser Args
  if voidp(Args) then
    sEmail = "adam@redsky.com"
  else
    sEmail = Args
  end if
  oRequestMgr.mFindUser(sEmail, 0, 0)
end

on f Args
  FindUser()
end

on infectUser sFriendEmail
  if voidp(sFriendEmail) then
    sFriendEmail = "adam@redsky.com"
  end if
  idUser = 36
  oRequestMgr.mInfectUser(sFriendEmail, idUser)
end

on i Args
  infectUser(Args)
end

on postMeeting
  mtg = [#idMeeting: "1903", #dWhenDate: "12/15/1998", #dWhenTime: "12:30:00", #sWhereName: "Grumps", #sWhereAddress: "1220 Primrose Lane", #yWhy: #goTeam, #sMessage: EMPTY, #lWho: [[#idUser: 34, #sUserName: "Jimmy", #yAttendStatus: #yes, #sMessage: EMPTY, #yCreator: 1], [#idUser: 35, #sUserName: "Cha0s", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: 0], [#idUser: 36, #sUserName: "SunBunny", #yAttendStatus: #unknown, #sMessage: EMPTY, #yCreator: 0]]]
  oRequestMgr.mPostMeeting(mtg, 0, 0)
end

on p
  postMeeting()
end

on getmeeting id
  if voidp(id) then
    id = 1
  end if
  oRequestMgr.mGetMeeting(id, 0, 0)
end

on g id
  getmeeting(id)
end

on listMeetings idUser
  if voidp(idUser) then
    idUser = 36
  end if
  oRequestMgr.mListMeetings(idUser, 0, 0)
end

on l idUser
  listMeetings(idUser)
end

on CancelMeeting
  idMeeting = 1
  idUser = 1
  sMessage = "I am not coming to your birthday party"
  oRequestMgr.mCancelMeeting(idMeeting, idUser, sMessage, 0, 0)
end

on cm
  CancelMeeting()
end

on AcceptMeeting
  idMeeting = "1"
  idUser = "3"
  sMessage = "See you there"
  oRequestMgr.mAcceptMeeting(idMeeting, idUser, sMessage, 0, 0)
end

on am
  AcceptMeeting()
end

on DeclineMeeting Args
  idMeeting = "1"
  idUser = "3"
  sMessage = "no thanks"
  oRequestMgr.mDeclineMeeting(idMeeting, idUser, sMessage, 0, 0)
end

on dm
  DeclineMeeting()
end

on ForgotPassword
  sEmail = "adam@redsky.com"
  oRequestMgr.mForgotPassword(sEmail, 0, 0)
end

on fp
  ForgotPassword()
end

on sp
  saveprefs()
end

on getprefs
  idUser = 17606
  oRequestMgr.mGetPrefs(idUser, 0, 0)
end

on gp
  getprefs()
end

on startWidget
  module = "1.1.1"
  widget = 1
  lSprs = [2, 2]
  oWidget = script("Generic Widget Class").new(module, widget, lSprs)
  oWidget.mStartup()
  oWidget.mTrigger()
  put "Comming soon."
end

on checkConnection
  return oConnectoScope.mConnected()
end
