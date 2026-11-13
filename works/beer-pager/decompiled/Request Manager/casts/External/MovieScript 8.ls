global xml

on lingoToXml requestType, propList
  case requestType of
    "postMeeting":
      mtg = propList.mtg
      mtgText = string(mtg)
      mtgText = SearchAndReplace(mtgText, "&", "&amp;")
      mtgText = SearchAndReplace(mtgText, "<", "&lt;")
      mtg = value(mtgText)
      xml = EMPTY
      printLn("<meeting>")
      printLn("<dWhenDate>" & mtg.dWhenDate & "</dWhenDate>")
      printLn("<dWhenTime>" & mtg.dWhenTime & "</dWhenTime>")
      printLn("<sWhereName>" & mtg.sWhereName & "</sWhereName>")
      printLn("<sWhereAddress>" & mtg.sWhereAddress & "</sWhereAddress>")
      printLn("<yWhy>" & mtg.yWhy & "</yWhy>")
      printLn("<sMessage>" & mtg.sMessage & "</sMessage>")
      printLn("<lwho>")
      repeat with i = 1 to mtg.lWho.count
        user = mtg.lWho[i]
        if ilk(user.yAttendStatus) <> #symbol then
          alert("Uh, oh.  Attend status is not a symbol.")
          nothing()
        end if
        printLn("      <invitee idUser=" & QUOTE & user.idUser & QUOTE & ">")
        printLn("            <sNameUser>" & user.sUserName & "</sNameUser>")
        printLn("            <yAttendStatus>" & user.yAttendStatus & "</yAttendStatus>")
        printLn("            <sMessage>" & user.sMessage & "</sMessage>")
        printLn("            <yCreator>" & user.yCreator & "</yCreator>")
        printLn("      </invitee>")
      end repeat
      printLn("</lwho>")
      printLn("</meeting>")
      put "Converting lingo to XML"
      put "XML=" & xml
      put EMPTY
      return xml
  end case
end

on printLn txt
  xml = xml & txt
end
