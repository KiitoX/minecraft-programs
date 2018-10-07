local monitor = "monitor_0"
local m = peripheral.wrap(monitor)
 
local W, H = m.getSize() --# 57, 24
 
--# init application
local app = Application():set({
  width = W,
  height = H,
  terminatable = true
})
 
--# load layout
app:importFromTML("src/layout.tml")
 
pages = app:query("PageContainer").result[1]
pages:selectPage("main")
 
--# load theme
local theme = Theme.fromFile("theme", "src/main.theme")
app:addTheme(theme)
 
--# register button handlers
 
--# for navigation
app:query("#left_return"):on("trigger",
  function() pages:selectPage("main") end)
app:query("#right_return"):on("trigger",
  function() pages:selectPage("main") end)
app:query("#go_left"):on("trigger",
  function() pages:selectPage("left") end)
app:query("#go_right"):on("trigger",
  function() pages:selectPage("right") end)
 
--# for functionality
function toggleButton(btnData)
  if btnData.text == btnData.texta then
    btnData.backgroundColour = colours[btnData.colourb]
    btnData.text = btnData.textb
    redstone.setOutput(btnData.side, true)
  else
    btnData.backgroundColour = colours[btnData.coloura]
    btnData.text = btnData.texta
    redstone.setOutput(btnData.side, false)
  end
end
 
local btnLEnable = app:query("#left_enable").result[1]
local btnLToggle = app:query("#left_toggle").result[1]
local btnREnable = app:query("#right_enable").result[1]
local btnRToggle = app:query("#right_toggle").result[1]
local btnFeed = app:query("Button#main_feed").result[1]
 
btnLEnable:on("trigger", toggleButton)
btnLToggle:on("trigger", toggleButton)
btnREnable:on("trigger", toggleButton)
btnRToggle:on("trigger", toggleButton)
btnFeed:on("trigger", toggleButton)
 
--# set initial colour
btnLEnable.backgroundColour = colours[btnLEnable.coloura]
btnLToggle.backgroundColour = colours[btnLToggle.coloura]
btnREnable.backgroundColour = colours[btnREnable.coloura]
btnRToggle.backgroundColour = colours[btnRToggle.coloura]
btnFeed.backgroundColour = colours[btnFeed.coloura]
 
--# create projector
app:addProjector(
  --# projectorName, projectorMode, targets
  Projector("main", "monitor", monitor):set({
    textScale = 0.9
  }))
 
--# start application
app:start()