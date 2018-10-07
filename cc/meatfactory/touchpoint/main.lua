--# load touchpoint api
os.loadAPI("touchpoint")

--# location of the 3 x 2 monitor
monitor = "monitor_0"

--# wrap monitor peripheral
m = peripheral.wrap(monitor)

--# shrink text size
m.setTextScale(0.5)

--# initialise to left screen
t = touchpoint.new(monitor)

btnLtEnable = {
  "               ",
  "               ",
  "    enable     ",
  "   breeding    ",
  "  of animals   ",
  "  in left pod  ",
  "               ",
  "               ",
  "               ",
  label = "btnLEnable",
  line_n = 3,
  line_a = "    enable     ", --# shown when redstone is off
  line_b = "    disable    ", --# shown when redstone is on
  side = "front"
}

btnLtToggle = {
  "               ",
  "               ",
  "               ",
  " slaughtering  ",
  "  animals in   ",
  "   left pod    ",
  "               ",
  "               ",
  "               ",
  label = "btnLToggle",
  line_n = 4,
  line_a = " slaughtering  ", --# shown when redstone is off
  line_b = "   blending    ", --# shown when redstone is on
  side = "back"
}

btnRtEnable = {
  "               ",
  "               ",
  "    enable     ",
  "   breeding    ",
  "  of animals   ",
  " in right pod  ",
  "               ",
  "               ",
  "               ",
  label = "btnREnable",
  line_n = 3,
  line_a = "    enable     ", --# shown when redstone is off
  line_b = "    disable    ", --# shown when redstone is on
  side = "left"
}

btnRtToggle = {
  "               ",
  "               ",
  "               ",
  " slaughtering  ",
  "  animals in   ",
  "  right pod    ",
  "               ",
  "               ",
  "               ",
  label = "btnRToggle",
  line_n = 4,
  line_a = " slaughtering  ", --# shown when redstone is off
  line_b = "   blending    ", --# shown when redstone is on
  side = "right"
}

btnFeed = {
  "               ",
  "               ",
  "               ",
  "     don't     ",
  "   feed the    ",
  "   children    ",
  "    in both    ",
  "  growing pods ",
  "               ",
  "               ",
  "               ",
  "               ",
  label = "btnFeed",
  line_n = 4,
  line_a = "     don't     ", --# shown when redstone is off
  line_b = "               ", --# shown when redstone is on
  side = "top"
}

--# generic function modifying the button label and setting redstone signals
function buttonToggle(btnData)
  t:toggleButton(btnData.label)
  if btnData[btnData.line_n] == btnData.line_a then
    btnData[btnData.line_n] = btnData.line_b
    redstone.setOutput(btnData.side, true)
    print("set "..btnData.side.." signal")
  else
    btnData[btnData.line_n] = btnData.line_a
    redstone.setOutput(btnData.side, false)
    print("reset "..btnData.side.." signal")
  end
  t:rename(btnData.label, btnData)
end

--# register buttons
t:add(btnLtEnable, function() buttonToggle(btnLtEnable) end, 40,  3, 54, 11, colours.red, colours.lime)
t:add(btnLtToggle, function() buttonToggle(btnLtToggle) end, 40, 14, 54, 22, colours.pink, colours.brown)

t:add(btnRtEnable, function() buttonToggle(btnRtEnable) end,  4,  3, 18, 11, colours.red, colours.lime)
t:add(btnRtToggle, function() buttonToggle(btnRtToggle) end,  4, 14, 18, 22, colours.pink, colours.brown)

t:add(btnFeed, function() buttonToggle(btnFeed) end, 22, 7, 35, 18, colours.grey, colours.orange)

--# draw buttons
t:draw()

--# handle touch events
t:run()