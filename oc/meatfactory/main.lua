local component = require("component")
local term = require("term")
local event = require("event")
local sides = require("sides")

local REDSTONE_ADDRESS_1 = ""
local REDSTONE_ADDRESS_2 = ""

-- set up environment
local gpu = term.gpu()
local fg = gpu.getForeground()
local bg = gpu.getBackground()
local resW, resH = gpu.getResolution()
gpu.setResolution(66, 33)
local screen = component.proxy(gpu.getScreen())
local scrMode = screen.isTouchModeInverted()
screen.setTouchModeInverted(true)

-- https://github.com/IgorTimofeev/GUI
local GUI = require("GUI")

-- TODO: interesting would be, to add a button to change the type of food used in the breeding machine.
-- This would use OpenComputers' inventory controller upgrade. (https://ocdoc.cil.li/component:inventory_controller)

-- initialize window container
local window = GUI.fullScreenContainer()
-- set the background color
window:addChild(GUI.panel(1, 1, window.width, window.height, 0x0))

function exit()
  window:stopEventHandling()
  -- revert environment changes
  gpu.setForeground(fg)
  gpu.setBackground(bg)
  gpu.setResolution(resW, resH)
  screen.setTouchModeInverted(scrMode)
  term.clear()
end

-- add interrupt handler
event.listen("interrupted", exit)

-- add layout with two columns and six rows
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 2, 6))
-- setup grid sizing
--layout:setColumnWidth(1, GUI.SIZE_POLICY_RELATIVE, 0.46)
--layout:setColumnWidth(2, GUI.SIZE_POLICY_RELATIVE, 0.08)
layout:setRowHeight(1, GUI.SIZE_POLICY_RELATIVE, 0.1)
--layout.showGrid = true

sekret = {{}, {}}

function fillColumn(c, column, rs)
  local label = GUI.label(1, 1, 26, 3, 0xFFFFFF, column.title)
  label:setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_CENTER)
  layout:setFitting(c, 1, true, true)
  layout:setPosition(c, 1, layout:addChild(label))
  
  for i, data in ipairs(column) do
    r = i + 1
    -- initialize default values
    local fg = data.fg or 0x000000
    local bg = data.bg or 0xAAAAAA
    local fgA = data.fgA or 0x000000
    local bgA = data.bgA or 0xEEEEEE
    local txt = data.text or "--MISSING--"
    
    local btn = GUI.button(1, 1, 26, 3, bg, fg, bgA, fgA, txt)
    
    -- wrap function if it is set
    if data.fn ~= nil then
      btn.onTouch = function(mainContainer, button, ...)
        local eventData = {...}
        data.fn(btn, data, rs)
      end
    end
    
    btn.switchMode = true
    btn.animationDuration = 0.08
    
    layout:setFitting(c, r, true, true, 4, 1)
    layout:setAlignment(c, r, GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_TOP)
    layout:setPosition(c, r, layout:addChild(btn))
    
    -- facilitate ugly hack for exclusive toggle buttons
    sekret[c][r] = btn
  end
end

function toggleBtn(btn, data, rs)
  -- initialize default values
  local txt = data.text or "--MISSING--"
  local txtA = data.textA or "--missing--"
  
  if btn.pressed then
    btn.text = txtA
    rs.setOutput(data.side, 15)
  else
    btn.text = txt
    rs.setOutput(data.side, 0)
  end
end

buttons = {
  {
    text = "breed animals",
    textA = "stop breeding animals", bgA = 0x228800,
    fn = toggleBtn, side = sides.up,
  },
  {
    text = "move babies",
    textA = "stop moving babies", bgA = 0xFF88FF,
    fn = toggleBtn, side = sides.north,
  },
  {
    text = "butcher animals",
    textA = "stop butchering animals", fgA = 0xFFFFFF, bgA = 0xBB0000,
    fn = function(btn, data, rs)
      local off = sekret[btn.layoutColumn][btn.layoutRow + 1]
      if btn.pressed and off.pressed then
        off.press(off, window)
      end
      toggleBtn(btn, data, rs)
    end, side = sides.south,
  },
  {
    text = "liquify animals",
    textA = "stop liquifying animals", fgA = 0xFFFFFF, bgA = 0x662200,
    fn = function(btn, data, rs)
      local off = sekret[btn.layoutColumn][btn.layoutRow - 1]
      if btn.pressed and off.pressed then
        off.press(off, window)
      end
      toggleBtn(btn, data, rs)
    end, side = sides.west,
  },
  {
    text = "feed babies",
    textA = "stop feeding babies", bgA = 0xFFAA00,
    fn = toggleBtn, side = sides.east,
  },
}

-- create proxies to redstone output blocks
local rs1 = component.proxy(component.get(REDSTONE_ADDRESS_1, "redstone"))
local rs2 = component.proxy(component.get(REDSTONE_ADDRESS_2, "redstone"))

for s = 0, 5 do
  rs1.setOutput(s, 0)
  rs2.setOutput(s, 0)
end

buttons.title = "left animal pen"
fillColumn(1, buttons, rs1)

buttons.title = "right animal pen"
fillColumn(2, buttons, rs2)

-- draw layout
window:drawOnScreen(true)
window:startEventHandling()
