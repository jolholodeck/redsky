property psscriptname, plmessagebtns, plmessageboxloc, plmessagebtn1loc, plmessagebtn2loc, plmessagebtn3loc, plmessagetextloc, pibtn1sprite, pibtn2sprite, pibtn3sprite, piboxsprite, pitextsprite, ploffstageloc, plscriptlist, plattachedbehaviors
global glmembers

on new me
  set psscriptname to "messagemgr"
  return me
end

on init me
  set plattachedbehaviors to [:]
  set plmessagebtns to [1: ["continuebtn", "quitbtn", "helpbtn"], 2: ["continuebtn", "quitbtn"], 3: ["quitbtn"], 4: ["okbtn"], 5: ["okbtn"], 6: ["okbtn"], 7: ["okbtn"], 8: ["okbtn"], 9: ["okbtn", "quitbtn"], 10: ["okbtn"], 11: ["okbtn"], 12: ["okbtn"], 13: ["openbtn", "savebtn"], 14: ["newbtn", "savebtn"], 15: ["okbtn"], 16: ["quitbtn"], 17: ["workbtn", "savebtn"], 18: ["entbtn", "savebtn"], 19: ["exitbtn", "savebtn"]]
  set plscriptlist to ["okbtn": "closemessage", "continuebtn": "gomakemode", "quitbtn": "fastquit", "helpbtn": "dohelp", "savebtn": "savewarned", "openbtn": "openwarned", "newbtn": "newwarned", "workbtn": "goworkwarned", "entbtn": "goentwarned", "exitbtn": "goexitwarned"]
  set plmessageboxloc to point(150, 115)
  set plmessagebtn1loc to point(465, 325)
  set plmessagebtn2loc to point(220, 325)
  set plmessagebtn3loc to point(340, 325)
  set plmessagetextloc to point(175, 135)
  set piboxsprite to 104
  set pitextsprite to 105
  set pibtn1sprite to 106
  set pibtn2sprite to 107
  set pibtn3sprite to 108
  set ploffstageloc to point(-1000, -1000)
end

on domessage me, aimessagenumber
  set pimessagenumber to aimessagenumber
  case aimessagenumber of
    1:
      set tsmessage to "Your presentation file is not available." & RETURN & RETURN & "Please press CONTINUE to make a new presentation or QUIT and place a presentation file in the CURRENT subfolder of the RSI_DEMO_SUPPORT directory on your boot drive."
    2:
      set tsmessage to "In order to play a presentation, drag one of the shows from the SHOWS folder to the CURRENT subfolder in RSI_DEMO_SUPPORT.  (This folder was automatically created on your hard drive when you started the demo.)  Rename your presentation 'current'. " & RETURN & RETURN & "When you return to the Speaker Support Module, your presentation will play automatically."
    3:
      set tsmessage to "In order to use the Speaker Support Module you need to QUIT and copy the Red Sky Interactive Demo to the hard drive."
    4:
      set tsmessage to "You have created the maximum number of components for one page and cannot add more to this page."
    5:
      set tsmessage to "You have used the maximum available text fields (500) and cannot add more to this show."
    6:
      set tsmessage to "Please enter only alphanumeric characters (letters and numbers)."
    7:
      set tsmessage to "Please SAVE your file before exiting." & RETURN & RETURN & "Click OK to save your file, or QUIT to exit without saving."
    8:
      set tsmessage to "--To make a new component click and drag a new component from the T for text, the B for a bullet, or the P for a project" & RETURN & "--To choose a new background,click on one of the  CHOOSE BACKGROUND arrows." & RETURN & "--To select a component click on it. " & RETURN & "--To deselect all components click on the background. " & RETURN & "--To move a component press SHIFT and click on the component and drag it." & RETURN & "--To delete a component press SHIFT and BACKSPACE after selecting it." & RETURN & "-- For a new page click the page forward arrow." & RETURN & "-- To insert a page, click the INSERT button." & RETURN & "--To insert a copy of the current page, press SHIFT then click the INSERT button." & RETURN & "-- To minimize/maximize the toolbox, click on TOOLBOX."
    9:
      set tsmessage to "There are no available projects.  To add projects to your presentation you will need QUIT and place director files in the DEMOS folder."
    10:
      set tsmessage to "Autosaving your file."
    11:
      set tsmessage to "You cannot delete the only page in the presentation."
    12:
      set tsmessage to "The file you selected is not a show file."
    13:
      set tsmessage to "You have not yet saved changes to your file." & RETURN & RETURN & "Click SAVE to save changes before continuing or OPEN to continue without saving."
    14:
      set tsmessage to "You have not yet saved changes to your file." & RETURN & RETURN & "Click SAVE to save changes before continuing or NEW to continue without saving."
    15:
      set tsmessage to "There are no show files available."
    16:
      set tmessage to "Unable to create the needed Red SkyInteractive Demo folders on the boot drive. " & RETURN & "These folders are where the presentation files you create would be saved."
    17:
      set tsmessage to "Please SAVE your file before exiting to the Work Module." & RETURN & RETURN & "To save your file, click OK. To go directly to the Work Module without saving, click GO WORK."
    18:
      set tsmessage to "Please SAVE your file before exiting to the Entertainment Module." & RETURN & RETURN & "To save your file, click OK.  To go directly to the Entertainment Module without saving, click GO ENTERTAINMENT."
    19:
      set tsmessage to "Please SAVE your file before exiting." & RETURN & RETURN & "Click OK to save your file or click EXIT exit without saving."
  end case
  set the text of member getOne(glmembers, "messagetext") to tsmessage
  displaymessage(me, aimessagenumber)
end

on displaymessage me, aimessagenumber
  closemessage(me)
  set tlbuttons to getProp(plmessagebtns, aimessagenumber)
  set ticount to count(tlbuttons)
  if ticount > 1 then
    repeat with n = 1 to ticount
      case n of
        1:
          set the member of sprite pibtn1sprite to getOne(glmembers, getAt(tlbuttons, n))
          set the loc of sprite pibtn1sprite to plmessagebtn1loc
          addscript(me, getAt(tlbuttons, n), pibtn1sprite)
        2:
          set the member of sprite pibtn2sprite to getOne(glmembers, getAt(tlbuttons, n))
          set the loc of sprite pibtn2sprite to plmessagebtn2loc
          addscript(me, getAt(tlbuttons, n), pibtn2sprite)
        3:
          set the member of sprite pibtn3sprite to getOne(glmembers, getAt(tlbuttons, n))
          set the loc of sprite pibtn3sprite to plmessagebtn3loc
          addscript(me, getAt(tlbuttons, n), pibtn3sprite)
      end case
    end repeat
  else
    if ticount = 1 then
      set the member of sprite pibtn3sprite to getOne(glmembers, getAt(tlbuttons, 1))
      set the loc of sprite pibtn3sprite to plmessagebtn3loc
      addscript(me, getAt(tlbuttons, 1), pibtn3sprite)
    end if
  end if
  set the loc of sprite piboxsprite to plmessageboxloc
  set the loc of sprite pitextsprite to plmessagetextloc
  updateStage()
end

on closemessage me
  set the loc of sprite piboxsprite to ploffstageloc
  set the loc of sprite pitextsprite to ploffstageloc
  removescripts(me)
  updateStage()
end

on removescripts me
  set ticount to count(plattachedbehaviors)
  repeat with n = 1 to ticount
    set tisprite to getPropAt(plattachedbehaviors, n)
    set the loc of sprite tisprite to ploffstageloc
    deleteOne(the scriptInstanceList of sprite tisprite, getAt(plattachedbehaviors, n))
  end repeat
  set plattachedbehaviors to [:]
end

on addscript me, asbtnnamem, aispritenum
  set tsscriptname to getProp(plscriptlist, asbtnnamem)
  set toscript to new(script tsscriptname)
  addProp(plattachedbehaviors, aispritenum, toscript)
  add(the scriptInstanceList of sprite aispritenum, toscript)
end

on cleanup me
end
