global gAlerts, gBlnWritePrefs

on alertHook me, err, Msg
  case gAlerts of
    #default:
      return 0
    #suppress:
      alert(GetErrorMsg(15))
      gBlnWritePrefs = 0
      quit()
      abort()
      return -1
  end case
end
