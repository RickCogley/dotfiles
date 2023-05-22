--------------------------------------------------------------------------------
-- rickcogley - https://github.com/rickcogley
-- See: http://www.hammerspoon.org
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- CONSTANTS
--------------------------------------------------------------------------------
local ctrl_shift_opt_cmd = {"ctrl", "shift", "alt", "cmd"}
local ctrl_opt_cmd = {"ctrl", "alt", "cmd"}
local ctrl_shift = {"ctrl", "shift"}
local opt_cmd = {"alt", "cmd"}
local first_monitor = hs.screen.allScreens()[1]:name()
local second_monitor = hs.screen.allScreens()[2]:name()

--------------------------------------------------------------------------------
-- CONFIGURATIONS
--------------------------------------------------------------------------------
hs.window.animationDuration = 0

--------------------------------------------------------------------------------
 -- FUNCTIONS
--------------------------------------------------------------------------------

-- auto reloader spoon
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- miro windows manager spoon
hs.loadSpoon("MiroWindowsManager")

-- calendar in desktop spoon
hs.loadSpoon("HCalendar")

-- clock spoon
-- hs.loadSpoon("AClock")
-- AClock:toggleShow()

-- testing

hs.hotkey.bind(ctrl_opt_cmd, "W", function()
   hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
   hs.alert.show(first_monitor)
   hs.alert.show(second_monitor)
end)

-- use miro spoon

spoon.MiroWindowsManager:bindHotkeys({
  up = {ctrl_opt_cmd, "up"},
  right = {ctrl_opt_cmd, "right"},
  down = {ctrl_opt_cmd, "down"},
  left = {ctrl_opt_cmd, "left"},
  fullscreen = {ctrl_opt_cmd, "f"}
})

-- use miro various
-- center focused x and y
hs.hotkey.bind(ctrl_opt_cmd, 'c', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.x = ((max.w - f.w) / 2) + max.x
	x.y = ((max.h - f.h) / 2) + max.y
	win:setFrame(x)
end)

-- center focused y
hs.hotkey.bind(ctrl_opt_cmd, 'x', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.y = ((max.h - f.h) / 2) + max.y
	win:setFrame(x)
end)

-- center focused x
hs.hotkey.bind(ctrl_opt_cmd, 'v', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.x = ((max.w - f.w) / 2) + max.x
	win:setFrame(x)
end)

-- maximize vertically
hs.hotkey.bind(ctrl_opt_cmd, '[', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.y = max.y
	x.h = max.h
	win:setFrame(x)
end)

-- maximize horizontally
hs.hotkey.bind(ctrl_opt_cmd, ']', function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local max = win:screen():frame()

	local x = f

	x.x = max.x
	x.w = max.w
	win:setFrame(x)
end)

-- move focused window to other screen
hs.hotkey.bind(ctrl_shift_opt_cmd, 'right', function() hs.window.focusedWindow():moveOneScreenEast(true, true) end)
hs.hotkey.bind(ctrl_shift_opt_cmd, 'left', function() hs.window.focusedWindow():moveOneScreenWest(true, true) end)

-- nudging

hs.hotkey.bind(ctrl_opt_cmd, "Y", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind(ctrl_opt_cmd, "K", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind(ctrl_opt_cmd, "U", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind(ctrl_opt_cmd, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  win:setFrame(f)
end)

hs.hotkey.bind(ctrl_opt_cmd, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  win:setFrame(f)
end)

hs.hotkey.bind(ctrl_opt_cmd, "B", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind(ctrl_opt_cmd, "J", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind(ctrl_opt_cmd, "N", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y + 10
  win:setFrame(f)
end)



-- -- See https://github.com/Hammerspoon/hammerspoon/issues/595
windowFilter = hs.window.filter.new():setCurrentSpace(true)

--------------------------------------------------------------------------------
-- WINDOW NAVIGATION
--------------------------------------------------------------------------------
hs.hotkey.bind(ctrl_shift_opt_cmd, "up", function()
    windowFilter:focusWindowNorth(nil, true)
    hs.mouse.setAbsolutePosition(hs.window.focusedWindow():frame().center)
end)

hs.hotkey.bind(ctrl_shift_opt_cmd, "down", function()
    windowFilter:focusWindowSouth(nil, true)
    hs.mouse.setAbsolutePosition(hs.window.focusedWindow():frame().center)
end)

hs.hotkey.bind(ctrl_shift_opt_cmd, "left", function()
    windowFilter:focusWindowWest()
    hs.mouse.setAbsolutePosition(hs.window.focusedWindow():frame().center)
end)

hs.hotkey.bind(ctrl_shift_opt_cmd, "right", function()
    windowFilter:focusWindowEast(nil, true)
    hs.mouse.setAbsolutePosition(hs.window.focusedWindow():frame().center)
end)

hs.hotkey.bind(ctrl_shift_opt_cmd, "`", function()
    nextScreen = hs.window.focusedWindow():screen():next()

    wf = hs.window.filter.new()
    wf:setOverrideFilter({ allowScreens = nextScreen:id() })
    wf:setSortOrder(hs.window.filter.sortByFocusedLast)

    window = wf:getWindows()[1]
    window:focus()
    hs.mouse.setAbsolutePosition(window:frame().center)
end)

windowHistory = hs.window.focusedWindow()

--------------------------------------------------------------------------------
-- FOCUS ON APP WINDOWS
--------------------------------------------------------------------------------
windowHistory = hs.window.focusedWindow()
function toggleWindowFocus(windowName)
    return function()
        windows =hs.window.filter.new(windowName):getWindows()

        num = #windows
        window = windows[1]
        print(window)

        if hs.window.focusedWindow() == window then
            -- window = windows[ 2 % num + 1]
              window = windowHistory
        end

        windowHistory = hs.window.focusedWindow()
        hs.mouse.setAbsolutePosition(window:frame().center)
        window:focus()
    end
end

hs.hotkey.bind(ctrl_opt_cmd, "q", toggleWindowFocus("iTerm2"))
hs.hotkey.bind(ctrl_opt_cmd, "w", toggleWindowFocus("Code"))
hs.hotkey.bind(ctrl_opt_cmd, "e", toggleWindowFocus("Firefox"))
-- hs.hotkey.bind(ctrl_opt_cmd, "r", toggleWindowFocus("Safari"))
hs.hotkey.bind(ctrl_opt_cmd, "a", toggleWindowFocus("Keybase"))

--[[
This is my attempt to implement a jumpcut replacement in Lua/Hammerspoon.
It monitors the clipboard/pasteboard for changes, and stores the strings you copy to the transfer area.
You can access this history on the menu (Unicode scissors icon).
Clicking on any item will add it to your transfer area.
If you open the menu while pressing option/alt, you will enter the Direct Paste Mode. This means that the selected item will be
"typed" instead of copied to the active clipboard.
The clipboard persists across launches.
-> Ng irc suggestion: hs.settings.set("jumpCutReplacementHistory", clipboard_history)
]]--

-- Feel free to change those settings
local frequency = 0.8 -- Speed in seconds to check for clipboard changes. If you check too frequently, you will loose performance, if you check sparsely you will loose copies
local hist_size = 20 -- How many items to keep on history
local label_length = 40 -- How wide (in characters) the dropdown menu should be. Copies larger than this will have their label truncated and end with "…" (unicode for elipsis ...)
local honor_clearcontent = false --asmagill request. If any application clears the pasteboard, we also remove it from the history https://groups.google.com/d/msg/hammerspoon/skEeypZHOmM/Tg8QnEj_N68J
local pasteOnSelect = false -- Auto-type on click

-- Don't change anything bellow this line
local jumpcut = hs.menubar.new()
jumpcut:setTooltip("Jumpcut replacement")
local pasteboard = require("hs.pasteboard") -- http://www.hammerspoon.org/docs/hs.pasteboard.html
local settings = require("hs.settings") -- http://www.hammerspoon.org/docs/hs.settings.html
local last_change = pasteboard.changeCount() -- displays how many times the pasteboard owner has changed // Indicates a new copy has been made

--Array to store the clipboard history
local clipboard_history = settings.get("so.victor.hs.jumpcut") or {} --If no history is saved on the system, create an empty history

-- Append a history counter to the menu
function setTitle()
  if (#clipboard_history == 0) then
    jumpcut:setTitle("✂") -- Unicode magic
    else
      jumpcut:setTitle("✂ ("..#clipboard_history..")") -- updates the menu counter
  end
end

function putOnPaste(string,key)
  if (pasteOnSelect) then
    hs.eventtap.keyStrokes(string)
    pasteboard.setContents(string)
    last_change = pasteboard.changeCount()
  else
    if (key.alt == true) then -- If the option/alt key is active when clicking on the menu, perform a "direct paste", without changing the clipboard
      hs.eventtap.keyStrokes(string) -- Defeating paste blocking http://www.hammerspoon.org/go/#pasteblock
    else
      pasteboard.setContents(string)
      last_change = pasteboard.changeCount() -- Updates last_change to prevent item duplication when putting on paste
    end
  end
end

-- Clears the clipboard and history
function clearAll()
  pasteboard.clearContents()
  clipboard_history = {}
  settings.set("so.victor.hs.jumpcut",clipboard_history)
  now = pasteboard.changeCount()
  setTitle()
end

-- Clears the last added to the history
function clearLastItem()
  table.remove(clipboard_history,#clipboard_history)
  settings.set("so.victor.hs.jumpcut",clipboard_history)
  now = pasteboard.changeCount()
  setTitle()
end

function pasteboardToClipboard(item)
  -- Loop to enforce limit on qty of elements in history. Removes the oldest items
  while (#clipboard_history >= hist_size) do
    table.remove(clipboard_history,1)
  end
  table.insert(clipboard_history, item)
  settings.set("so.victor.hs.jumpcut",clipboard_history) -- updates the saved history
  setTitle() -- updates the menu counter
end

-- Dynamic menu by cmsj https://github.com/Hammerspoon/hammerspoon/issues/61#issuecomment-64826257
populateMenu = function(key)
  setTitle() -- Update the counter every time the menu is refreshed
  menuData = {}
  if (#clipboard_history == 0) then
    table.insert(menuData, {title="None", disabled = true}) -- If the history is empty, display "None"
  else
    for k,v in pairs(clipboard_history) do
      if (string.len(v) > label_length) then
        table.insert(menuData,1, {title=string.sub(v,0,label_length).."…", fn = function() putOnPaste(v,key) end }) -- Truncate long strings
      else
        table.insert(menuData,1, {title=v, fn = function() putOnPaste(v,key) end })
      end -- end if else
    end-- end for
  end-- end if else
  -- footer
  table.insert(menuData, {title="-"})
  table.insert(menuData, {title="Clear All", fn = function() clearAll() end })
  if (key.alt == true or pasteOnSelect) then
    table.insert(menuData, {title="Direct Paste Mode ✍", disabled=true})
  end
  return menuData
end

-- If the pasteboard owner has changed, we add the current item to our history and update the counter.
function storeCopy()
  now = pasteboard.changeCount()
  if (now > last_change) then
    current_clipboard = pasteboard.getContents()
    -- asmagill requested this feature. It prevents the history from keeping items removed by password managers
    if (current_clipboard == nil and honor_clearcontent) then
      clearLastItem()
    else
      pasteboardToClipboard(current_clipboard)
    end
    last_change = now
  end
end

--Checks for changes on the pasteboard. Is it possible to replace with eventtap?
timer = hs.timer.new(frequency, storeCopy)
timer:start()

setTitle() --Avoid wrong title if the user already has something on his saved history
jumpcut:setMenu(populateMenu)

--if Finder, bring all to front
function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
      if (appName == "Finder") then
          -- Bring all Finder windows forward when one gets activated
          appObject:selectMenuItem({"Window", "Bring All to Front"})
      end
  end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

--if at home wifi, set vol to 1, if away, set to 0
wifiWatcher = nil
homeSSID = "Maru-Haus"
lastSSID = hs.wifi.currentNetwork()
function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()
    if string.match(newSSID, homeSSID) and not string.match(lastSSID, homeSSID) then
    -- if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(1)
    elseif not string.match(newSSID, homeSSID) and string.match(lastSSID, homeSSID) then
    -- elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        -- We just departed our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(0)
    end
    lastSSID = newSSID
end
wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()
