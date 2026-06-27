-- REMOD BY YOUTUBE LAOSIJI --
local Timer, EventManager = ...
local EVENT_TYPES = EventManager.FE.FIFA.EventTypes
local InstantReplay = {}
local actBack = "act_back"
local actTogglePlay = "act_toggle_play"
local actChangeCamera = "act_change_camera"
local actNextTarget = "act_next_target"
local actPreviousTarget = "act_previous_target"
local actMovePlayhead = "act_move_playhead"
local actPanCamera = "act_pan_camera"
local actZoomCamera = "act_zoom_camera"
local actSetCameraLensAngle = "act_camera_lens_angle"
local actToggleControls = "act_toggle_controls"
local bndCameraPan = "bnd_pan_camera"
local bndCameraZoom = "bnd_zoom_camera"
local bndCameraLensAngle = "bnd_camera_lens_angle"
local bndReplayControl = "bnd_replay_control"
local bndPlayheadPosition = "bnd_playhead_position"
local bndControlsVisibility = "bnd_controls_visibility"
local bndPlayInstantReplay = "bnd_play_instant_replay"
local panDistance = 200
local zoomScaleFactor = 3
function InstantReplay:new(init)
  local o = init or {}
  setmetatable(o, self)
  self.__index = self
  print("InstantReplay::new()")
  o.isReplayControlSubscribed = false
  o.areControlsVisible = true
  o.instantReplayPlayAsset = "$ReplayPlayPauseToggle"
  o.instantReplayPauseAsset = "$PauseAssetInstantReplay"
  o.services = {
    replayService = o.api("InstantReplayService"),
    EventManagerService = o.api("EventManagerService")
  }
  o.eventHandlerID = o.services.EventManagerService.RegisterHandler(function(...)
    o:_handleEvent(...)
  end
  )
  function o.replayControlListener(...)
    o:updateReplayControlListener(...)
  end
  
  o.services.replayService.RegisterListener(0, o.replayControlListener)
  o.services.replayService.RequestViewData()
  o.im.Subscribe(bndControlsVisibility, function()
    o:_publishControlsVisiblity(o.areControlsVisible)
  end
  )
  o.im.Subscribe(bndPlayInstantReplay, function()
    o:_publishPlayInstantReplayAsset(o.instantReplayPauseAsset)
  end
  )
  o.timer = Timer:new({
    reps = 1,
    interval = 2,
    onTimerComplete = function()
      o:_onTimerComplete()
    end
    
  })
  o.im.RegisterAction(actBack, function(actionName, data)
    print("InstantReplay::Back()")
    o.nav.Event(nil, "evt_back")
    o.timer:restart()
  end
  )
  o.im.RegisterAction(actTogglePlay, function(actionName, data)
    print("InstantReplay::TogglePlay()")
    o.services.replayService.TogglePlay()
    o.timer:restart()
  end
  )
  o.im.RegisterAction(actChangeCamera, function(actionName, data)
    print("InstantReplay::ChangeCamera()")
    o.services.replayService.ChangeCamera()
    o.timer:restart()
  end
  )
  o.im.RegisterAction(actNextTarget, function(actionName, data)
    print("InstantReplay::NextTarget()")
    o.services.replayService.NextTarget()
    o.timer:restart()
  end
  )
  o.im.RegisterAction(actPreviousTarget, function(actionName, data)
    print("InstantReplay::PreviousTarget()")
    o.services.replayService.PreviousTarget()
    o.timer:restart()
  end
  )
  o.im.RegisterAction(actToggleControls, function(actionName, data)
    print("InstantReplay::TOGGLE_CONTROLS()")
    o.areControlsVisible = true
    o:_publishControlsVisiblity(o.areControlsVisible)
    o.timer:restart()
  end
  )
  o.im.RegisterDataAction(bndPlayheadPosition, actMovePlayhead, function(bindingName, actionName, playheadPercent)
    print("InstantReplay::MovePlayheadToPercent()")
    o.services.replayService.MovePlayheadToPercent(playheadPercent)
    o.timer:restart()
  end
  )
  o.im.RegisterDataAction(bndCameraPan, actPanCamera, function(bindingName, actionName, panEvent)
    print("InstantReplay::OnPanEvent()")
    local cameraPan = {}
    local panX = panEvent.panX
    print("InstantReplay::OnPanEvent() panX " .. tostring(panX))
    if panX > 0 then
      cameraPan.rightHeading = panX / panDistance
      cameraPan.leftHeading = 0
    else
      cameraPan.rightHeading = 0
      cameraPan.leftHeading = -(panX / panDistance)
    end
    local panY = panEvent.panY
    print("InstantReplay::OnPanEvent() panY " .. tostring(panY))
    if panY > 0 then
      cameraPan.upHeading = 0
      cameraPan.downHeading = panY / panDistance
    else
      cameraPan.upHeading = -(panY / panDistance)
      cameraPan.downHeading = 0
    end
    o.services.replayService.SetCameraPan(cameraPan)
    o.timer:restart()
  end
  )
  o.im.RegisterDataAction(bndCameraZoom, actZoomCamera, function(bindingName, actionName, scaleRatio)
    print("InstantReplay::OnZoomEvent() " .. scaleRatio)
    o.services.replayService.SetCameraZoom(scaleRatio * zoomScaleFactor)
    o.timer:restart()
  end
  )
  o.im.RegisterDataAction(bndCameraLensAngle, actSetCameraLensAngle, function(bindingName, actionName, angle)
    print("InstantReplay::SetCameraLengsAngle() " .. angle)
    o.services.replayService.SetCameraLensAnglePercent(angle)
    o.timer:restart()
  end
  )
  o.timer:start()
  return o
end

function InstantReplay:_publishControlsVisiblity(isVisible)
  self.im.Publish(bndControlsVisibility, isVisible)
end

function InstantReplay:_publishPlayInstantReplayAsset(asset)
  self.im.Publish(bndPlayInstantReplay, asset)
end

function InstantReplay:update(elapsedTime)
  if self.timer ~= nil then
    self.timer:update(elapsedTime)
  end
end

function InstantReplay:_onTimerComplete()
  self.areControlsVisible = false
  self:_publishControlsVisiblity(false)
end

function InstantReplay:updateReplayControlListener(data)
  print("InstantReplay::updateReplayControlListener()")
  if self.isReplayControlSubscribed == false then
    self.im.Subscribe(bndReplayControl, function()
      print("InstantReplay::updateReplayControlListener() Subscribe")
      self.im.Publish(bndReplayControl, data)
    end
    )
    self.isReplayControlSubscribed = true
  else
    print("InstantReplay::updateReplayControlListener() Publish")
    self.im.Publish(bndReplayControl, data)
  end
  if data.isPlaying == true then
    self:_publishPlayInstantReplayAsset(self.instantReplayPauseAsset)
  else
    self:_publishPlayInstantReplayAsset(self.instantReplayPlayAsset)
  end
end

function InstantReplay:_handleEvent(eventType, data)
  if eventType == EVENT_TYPES.OnBackPressed then
    print("[InstantReplay]: handleEvent: OnBackPressed")
    self.nav.Event(nil, "evt_back")
    self.timer:restart()
  end
end

function InstantReplay:finalize()
  if self.timer and self.timer.isActive then
    self.timer:finalize()
    self.timer = nil
  end
  self.services.EventManagerService.UnregisterHandler(self.eventHandlerID)
  self.im.Unsubscribe(bndControlsVisibility)
  self.im.Unsubscribe(bndReplayControl)
  self.im.Unsubscribe(bndPlayInstantReplay)
  self.im.UnregisterAction(actBack)
  self.im.UnregisterAction(actTogglePlay)
  self.im.UnregisterAction(actChangeCamera)
  self.im.UnregisterAction(actNextTarget)
  self.im.UnregisterAction(actPreviousTarget)
  self.im.UnregisterAction(actToggleControls)
  self.im.UnregisterDataAction(bndPlayheadPosition, actMovePlayhead)
  self.im.UnregisterDataAction(bndCameraPan, actPanCamera)
  self.im.UnregisterDataAction(bndCameraZoom, actZoomCamera)
  self.im.UnregisterDataAction(bndCameraLensAngle, actSetCameraLensAngle)
  self.services.replayService.UnRegisterListener(0)
  self.services.replayService.UnregisterForViewData()
end

return InstantReplay
