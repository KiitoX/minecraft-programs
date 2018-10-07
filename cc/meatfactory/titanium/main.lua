--[[
    Built using Titanium Packager (Harry Felton - hbomb79)

    Install pakager, and other Titanium developer tools via 'pastebin run 5B9k1jZg'
]]
local args, exportDirectory = { ... }, ""
if args[ 1 ] and args[ 1 ] ~= "--" then exportDirectory = args[ 1 ] or "" end
table.remove( args, 1 )
if args[ 1 ] == "--" then table.remove( args, 1 ) end
local vfsAssets = {
  [ "src/init.lua" ] = "local monitor = \"monitor_0\"\
local m = peripheral.wrap(monitor)\
\
local W, H = m.getSize() --# 57, 24\
\
--# init application\
local app = Application():set({\
  width = W,\
  height = H,\
  terminatable = true\
})\
\
--# load layout\
app:importFromTML(\"src/layout.tml\")\
\
pages = app:query(\"PageContainer\").result[1]\
pages:selectPage(\"main\")\
\
--# load theme\
local theme = Theme.fromFile(\"theme\", \"src/main.theme\")\
app:addTheme(theme)\
\
--# register button handlers\
\
--# for navigation\
app:query(\"#left_return\"):on(\"trigger\",\
  function() pages:selectPage(\"main\") end)\
app:query(\"#right_return\"):on(\"trigger\",\
  function() pages:selectPage(\"main\") end)\
app:query(\"#go_left\"):on(\"trigger\",\
  function() pages:selectPage(\"left\") end)\
app:query(\"#go_right\"):on(\"trigger\",\
  function() pages:selectPage(\"right\") end)\
\
--# for functionality\
function toggleButton(btnData)\
  if btnData.text == btnData.texta then\
    btnData.backgroundColour = colours[btnData.colourb]\
    btnData.text = btnData.textb\
    redstone.setOutput(btnData.side, true)\
  else\
    btnData.backgroundColour = colours[btnData.coloura]\
    btnData.text = btnData.texta\
    redstone.setOutput(btnData.side, false)\
  end\
end\
\
local btnLEnable = app:query(\"#left_enable\").result[1]\
local btnLToggle = app:query(\"#left_toggle\").result[1]\
local btnREnable = app:query(\"#right_enable\").result[1]\
local btnRToggle = app:query(\"#right_toggle\").result[1]\
local btnFeed = app:query(\"Button#main_feed\").result[1]\
\
btnLEnable:on(\"trigger\", toggleButton)\
btnLToggle:on(\"trigger\", toggleButton)\
btnREnable:on(\"trigger\", toggleButton)\
btnRToggle:on(\"trigger\", toggleButton)\
btnFeed:on(\"trigger\", toggleButton)\
\
--# set initial colour\
btnLEnable.backgroundColour = colours[btnLEnable.coloura]\
btnLToggle.backgroundColour = colours[btnLToggle.coloura]\
btnREnable.backgroundColour = colours[btnREnable.coloura]\
btnRToggle.backgroundColour = colours[btnRToggle.coloura]\
btnFeed.backgroundColour = colours[btnFeed.coloura]\
\
--# create projector\
app:addProjector(\
  --# projectorName, projectorMode, targets\
  Projector(\"main\", \"monitor\", monitor):set({\
    textScale = 0.9\
  }))\
\
--# start application\
app:start()",
  [ "src/main.theme" ] = "<TextContainer class=\"title\">\
  <backgroundColour>lightBlue</backgroundColour>\
  <colour>black</colour>\
  <verticalAlign>centre</verticalAlign>\
  <horizontalAlign>centre</horizontalAlign>\
</TextContainer>\
\
<Button class=\"nav\">\
  <backgroundColour>blue</backgroundColour>\
  <activeBackgroundColour>lightBlue</activeBackgroundColour>\
</Button>\
\
<Button>\
  <backgroundColour>gray</backgroundColour>\
  <activeBackgroundColour>white</activeBackgroundColour>\
  <colour>white</colour>\
  <activeColour>black</activeColour>\
  <verticalAlign>centre</verticalAlign>\
  <horizontalAlign>centre</horizontalAlign>\
</Button>",
  [ "src/layout.tml" ] = "<PageContainer X=1 Y=1\
    width=\"$application.width\"\
    height=\"$application.height\"\
    projector=\"main\" mirrorProjector=false>\
  <Page id=\"right\" xScrollAllowed=false>\
    <TextContainer X=2 Y=1 class=\"title\"\
      width=\"$application.width - 2\" height=3\
      text=\"manage right animal pen\"/>\
    <Button X=2 Y=5 width=38 height=9 class=\"enable\"\
      id=\"right_enable\" text=\"$self.texta\"\
      texta=\"animals are not being bred\"\
      textb=\"animals are being bred\"\
      coloura=\"grey\" colourb=\"lime\" side=\"left\"/>\
    <Button X=2 Y=15 width=38 height=9 class=\"toggle\"\
      id=\"right_toggle\" text=\"$self.texta\"\
      texta=\"animals are being slaughtered\"\
      textb=\"animals are being liquified\"\
      coloura=\"red\" colourb=\"brown\" side=\"right\"/>\
    <Button X=42 Y=5 width=15 height=19 id=\"right_return\"\
      text=\"return to menu\" class=\"nav\"/>\
  </Page>\
  <Page id=\"main\" xScrollAllowed=false>\
    <TextContainer X=2 Y=1 class=\"title\"\
      width=\"$application.width - 2\" height=3\
      text=\"manage meat factory\"/>\
    <Button X=2 Y=5 width=15 height=19 id=\"go_right\"\
      text=\"manage right animal pen\" class=\"nav\"/>\
    <Button X=19 Y=5 width=21 height=19\
      id=\"main_feed\" text=\"$self.texta\"\
      texta=\"baby animals are not being fed\"\
      textb=\"baby animals are being fed\"\
      coloura=\"grey\" colourb=\"orange\" side=\"top\"/>\
    <Button X=42 Y=5 width=15 height=19 id=\"go_left\"\
      text=\"manage left animal pen\" class=\"nav\"/>\
  </Page>\
  <Page id=\"left\" xScrollAllowed=false>\
    <TextContainer X=2 Y=1 class=\"title\"\
      width=\"$application.width - 2\" height=3\
      text=\"manage left animal pen\"/>\
    <Button X=2 Y=5 width=15 height=19 id=\"left_return\"\
      text=\"return to menu\" class=\"nav\"/>\
    <Button X=19 Y=5 width=38 height=9 class=\"enable\"\
      id=\"left_enable\" text=\"$self.texta\"\
      texta=\"animals are not being bred\"\
      textb=\"animals are being bred\"\
      coloura=\"grey\" colourb=\"lime\" side=\"front\"/>\
    <Button X=19 Y=15 width=38 height=9 class=\"toggle\"\
      id=\"left_toggle\" text=\"$self.texta\"\
      texta=\"animals are being slaughtered\"\
      textb=\"animals are being liquified\"\
      coloura=\"red\" colourb=\"brown\" side=\"back\"/>\
  </Page>\
</PageContainer>",
}local env = type( getfenv ) == "function" and getfenv() or _ENV or _G
if env.TI_VFS_RAW then env = env.TI_VFS_RAW end
local fallbackFS = env.fs
local RAW = setmetatable({
    fs = setmetatable( {}, { __index = _G["fs"] }),
    os = setmetatable( {}, { __index = _G["os"] } )
}, { __index = env })

local VFS = RAW["fs"]
local VFS_ENV = setmetatable({},{__index = function( _, key )
    if key == "TI_VFS_RAW" then return RAW end
    return RAW[ key ]
end})

VFS_ENV._G = VFS_ENV
VFS_ENV._ENV = VFS_ENV

local VFS_DIRS = {
  src = true,
}
local matches = { ["^"] = "%^", ["$"] = "%$", ["("] = "%(", [")"] = "%)", ["%"] = "%%", ["*"] = "[^/]*", ["."] = "%.", ["["] = "%[", ["]"] = "%]", ["+"] = "%+", ["-"] = "%-" }


function VFS_ENV.load(src, name, mode, env)
    return load( src, name or '(load)', mode, env or VFS_ENV )
end

function VFS_ENV.loadstring(src, name)
    return VFS_ENV.load( src, name, 't', VFS_ENV )
end

function VFS_ENV.loadfile(file, env)
    local _ENV = VFS_ENV
    local h = fs.open( file, "r" )
    if h then
        local fn, e = load(h.readAll(), fs.getName(file), 't', env or VFS_ENV)
        h.close()
        return fn, e
    end

    return nil, 'File not found'
end
if type( setfenv ) == "function" then setfenv( VFS_ENV.loadfile, VFS_ENV ) end

function VFS_ENV.os.run( _tEnv, _sPath, ... )
    local _ENV = VFS_ENV
    local tArgs, tEnv = { ... }, _tEnv

    setmetatable( tEnv, { __index = VFS_ENV } )
    local fnFile, err = loadfile( _sPath, tEnv )
    if fnFile then
        local ok, err = pcall( function()
            fnFile( table.unpack( tArgs ) )
        end )
        if not ok then
            if err and err ~= "" then
                printError( err )
            end
            return false
        end
        return true
    end
    if err and err ~= "" then
        printError( err )
    end
    return false
end

local tAPIsLoading = {}
function VFS_ENV.os.loadAPI( _sPath )
    local _ENV, sName = VFS_ENV, fs.getName( _sPath )
    if tAPIsLoading[sName] == true then
        printError( "API "..sName.." is already being loaded" )
        return false
    end
    tAPIsLoading[sName] = true

    local tEnv = setmetatable( {}, { __index = VFS_ENV } )
    local fnAPI, err = loadfile( _sPath, tEnv )
    if fnAPI then
        local ok, err = pcall( fnAPI )
        if not ok then
            printError( err )
            tAPIsLoading[sName] = nil
            return false
        end
    else
        printError( err )
        tAPIsLoading[sName] = nil
        return false
    end

    local tAPI = {}
    for k,v in pairs( tEnv ) do if k ~= "_ENV" then tAPI[k] =  v end end

    VFS_ENV[sName], tAPIsLoading[sName] = tAPI, nil
    return true
end

VFS_ENV.os.loadAPI "/rom/apis/io"
function VFS_ENV.dofile(file)
    local _ENV = VFS_ENV
    local fn, e = loadfile(file, VFS_ENV)

    if fn then return fn()
    else error(e, 2) end
end
if type( setfenv ) == "function" then setfenv( VFS_ENV.dofile, VFS_ENV ) end

function VFS.open( path, mode )
    path = fs.combine( "", path )
    if vfsAssets[ path ] then
        if mode == "w" or mode == "wb" or mode == "a" or mode == "ab" then
            return error("Cannot open file in mode '"..tostring( mode ).."'. File is inside of Titanium VFS and is read only")
        end

        local content, handle = vfsAssets[ path ], {}
        if mode == "rb" then
            handle.read = function()
                if #content == 0 then return end
                local b = content:sub( 1, 1 ):byte()

                content = content:sub( 2 )
                return b
            end
        end

        handle.readLine = function()
            if #content == 0 then return end

            local line, rest = content:match "^([^\n\r]*)(.*)$"

            content = rest and rest:gsub("^[\n\r]", "") or ""
            return line or content
        end

        handle.readAll = function()
            if #content == 0 then return end

            local c = content
            content = ""

            return c
        end

        handle.close = function() content = "" end

        return handle
    else return fallbackFS.open( fs.combine( exportDirectory, path ), mode ) end
end

function VFS.isReadOnly( path )
    path = fs.combine( "", path )
    if vfsAssets[ path ] then return true end

    return fallbackFS.isReadOnly( fs.combine( exportDirectory, path ) )
end

function VFS.getSize( path )
    return vfsAssets[ path ] and #vfsAssets[ path ] or fallbackFS.getSize( path )
end

function VFS.list( target )
    target = fs.combine( "", target )
    local list = fallbackFS.isDir( target ) and fallbackFS.list( target ) or {}

    local function addResult( res )
        for i = 1, #list do if list[ i ] == res then return end end
        list[ #list + 1 ] = res
    end

    if VFS_DIRS[ target ] then
        for path in pairs( vfsAssets ) do
            if path:match( ("^%s/"):format( target ) ) then
                addResult( path:match( ("^%s/([^/]+)"):format( target ) ) )
            end
        end
    elseif target == "" then
        for path in pairs( vfsAssets ) do addResult( path:match "^([^/]+)" ) end
    end

    return list
end

function VFS.find( target )
    target = fs.combine( "", target )
    local list = fallbackFS.find( target ) or {}

    target = ("^(%s)(.*)$"):format( target:gsub( ".", matches ) )
    for path in pairs( vfsAssets ) do
        local res, tail = path:match( target )
        if res and ( tail == "" or tail:sub( 1, 1 ) == "/" ) then
            local isMatch
            for i = 1, #list do if list[ i ] == res then isMatch = true; break end end

            if not isMatch then list[ #list + 1 ] = res end
        end
    end

    return list
end

function VFS.isDir( path )
    path = fs.combine( "", path )
    return VFS_DIRS[ path ] or fallbackFS.isDir( fs.combine( exportDirectory, path ) )
end

function VFS.exists( path )
    path = fs.combine( "", path )
    if vfsAssets[ path ] or VFS_DIRS[ path ] then return true end

    return fallbackFS.exists( fs.combine( exportDirectory, path ) )
end
if not fs.exists( "/.tpm/bin/tpm" ) then
    local h = http.get "https://gitlab.com/hbomb79/Titanium-Package-Manager/raw/master/tpm"
    if not h then return error "Failed to download TPM" end

    local f = fs.open( "/.tpm/bin/tpm", "w" )
    f.write( h.readAll() )
    h.close()
    f.close()
end

local ok, err = loadfile "/.tpm/bin/tpm"
if not ok then return error("Failed to load TPM '"..tostring( err ).."'") end

ok( "--fetch", "--disposable", "--depend", shell.getRunningProgram(), "install", "Titanium:latest" )
local FAILURE = "Failed to execute Titanium package. Latest Titanium version cannot be found %s (/.tpm/cache)"
if not fs.exists("/.tpm/cache") then
    return error( FAILURE:format "because TPM cache is missing" )
end

local cacheHandle = fs.open("/.tpm/cache", "r")
local cache = textutils.unserialise( cacheHandle.readAll() )
cacheHandle.close()

if not cache then
    return error( FAILURE:format "because TPM cache is malformed" )
elseif not cache.Titanium then
    return error( FAILURE:format "because TPM cache missing Titanium version information" )
end
if not VFS_ENV.Titanium then VFS_ENV.dofile( "/.tpm/packages/Titanium/"..cache.Titanium[1] ) end
local fn, err = VFS_ENV.loadfile 'src/init.lua'if fn then fn( unpack( args ) ) else return error('Failed to run file from bundle: "'..tostring( err )..'"') end