global gmouse_queue, gmouse_queuelength

on mouse_init queuelength
  set gmouse_queuelength to queuelength
  set gmouse_queue to []
  repeat with i = 1 to queuelength
    add(gmouse_queue, [#ticks: -1, #loc: point(0, 0)])
  end repeat
end

on mouse_mousedown
  addAt(gmouse_queue, 1, [#ticks: the ticks, #loc: point(the mouseH, the mouseV)])
  deleteAt(gmouse_queue, gmouse_queuelength + 1)
end

on mouse_getqueue
  return gmouse_queue
end

on mouse_addevent event
  addAt(gmouse_queue, 1, event)
  deleteAt(gmouse_queue, gmouse_queuelength + 1)
end
