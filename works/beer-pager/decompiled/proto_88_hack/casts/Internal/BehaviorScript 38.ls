global oCurMeeting

on keyUp
  oCurMeeting.mUpdateMeetingData(#iMessage, member("in_I_notes").text)
end
