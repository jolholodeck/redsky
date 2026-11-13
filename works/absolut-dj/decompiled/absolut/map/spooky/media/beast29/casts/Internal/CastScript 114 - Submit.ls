on mouseUp
  set strTo to the text of member "to"
  set strFrom to the text of member "from"
  set strSubject to the text of member "subject"
  set strBody to the text of member "body"
  set strCGI to "http://209.1.156.49/absolut/playback.asp"
  set strState to "1234567812345678123456781234567812345678123456781234567812345678"
  set strLink to strCGI & "?seq=" & strState
  getNetText("http://209.1.156.49/absolut/email2.asp?to=" & strTo & "&from=" & strFrom & "&subject=" & strSubject & "&body=" & strBody & "&link=" & strLink)
  set the text of member "Status" to "Sending..."
  go(2)
end
