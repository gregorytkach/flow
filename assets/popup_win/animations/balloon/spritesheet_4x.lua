--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:1c263441c52e374f90f1e101b6e45b04:1ab4700b91752deb740fdf1a62b60588:f831e6898c0fd91086524f46faeb2240$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- balloon_01_4x
            x=2,
            y=2,
            width=456,
            height=1325,

            sourceX = 30,
            sourceY = 23,
            sourceWidth = 510,
            sourceHeight = 1355
        },
        {
            -- balloon_02_4x
            x=918,
            y=2,
            width=456,
            height=1317,

            sourceX = 30,
            sourceY = 20,
            sourceWidth = 510,
            sourceHeight = 1355
        },
        {
            -- balloon_03_4x
            x=1376,
            y=1315,
            width=456,
            height=1311,

            sourceX = 30,
            sourceY = 16,
            sourceWidth = 510,
            sourceHeight = 1355
        },
        {
            -- balloon_04_4x
            x=460,
            y=2628,
            width=456,
            height=1305,

            sourceX = 30,
            sourceY = 12,
            sourceWidth = 510,
            sourceHeight = 1355
        },
        {
            -- balloon_05_4x
            x=918,
            y=1321,
            width=456,
            height=1297,

            sourceX = 30,
            sourceY = 9,
            sourceWidth = 510,
            sourceHeight = 1355
        },
        {
            -- balloon_06_4x
            x=460,
            y=1321,
            width=456,
            height=1291,

            sourceX = 30,
            sourceY = 5,
            sourceWidth = 510,
            sourceHeight = 1355
        },
        {
            -- balloon_07_4x
            x=2,
            y=1329,
            width=456,
            height=1297,

            sourceX = 30,
            sourceY = 9,
            sourceWidth = 510,
            sourceHeight = 1355
        },
        {
            -- balloon_08_4x
            x=2,
            y=2628,
            width=456,
            height=1305,

            sourceX = 30,
            sourceY = 12,
            sourceWidth = 510,
            sourceHeight = 1355
        },
        {
            -- balloon_09_4x
            x=1376,
            y=2,
            width=456,
            height=1311,

            sourceX = 30,
            sourceY = 16,
            sourceWidth = 510,
            sourceHeight = 1355
        },
        {
            -- balloon_10_4x
            x=460,
            y=2,
            width=456,
            height=1317,

            sourceX = 30,
            sourceY = 20,
            sourceWidth = 510,
            sourceHeight = 1355
        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 4096
}

SheetInfo.frameIndex =
{

    ["balloon_01_4x"] = 1,
    ["balloon_02_4x"] = 2,
    ["balloon_03_4x"] = 3,
    ["balloon_04_4x"] = 4,
    ["balloon_05_4x"] = 5,
    ["balloon_06_4x"] = 6,
    ["balloon_07_4x"] = 7,
    ["balloon_08_4x"] = 8,
    ["balloon_09_4x"] = 9,
    ["balloon_10_4x"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
