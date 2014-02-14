--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:51838b16056f746e6505d5aac804eaef:b319bb83b2c28055d13b19be532f41cf:f831e6898c0fd91086524f46faeb2240$
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
            -- dog_01_4x
            x=626,
            y=650,
            width=310,
            height=642,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
        {
            -- dog_02_4x
            x=624,
            y=1308,
            width=310,
            height=642,

            sourceX = 6,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
        {
            -- dog_03_4x
            x=314,
            y=1308,
            width=308,
            height=644,

            sourceX = 9,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
        {
            -- dog_04_4x
            x=624,
            y=2,
            width=310,
            height=646,

            sourceX = 9,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
        {
            -- dog_05_4x
            x=314,
            y=2,
            width=308,
            height=652,

            sourceX = 9,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
        {
            -- dog_06_4x
            x=2,
            y=672,
            width=310,
            height=660,

            sourceX = 6,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
        {
            -- dog_07_4x
            x=2,
            y=2,
            width=310,
            height=668,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
        {
            -- dog_08_4x
            x=2,
            y=1334,
            width=310,
            height=658,

            sourceX = 3,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
        {
            -- dog_09_4x
            x=314,
            y=656,
            width=310,
            height=650,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
        {
            -- dog_10_4x
            x=938,
            y=644,
            width=308,
            height=640,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
        {
            -- dog_11_4x
            x=936,
            y=1294,
            width=310,
            height=640,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
        {
            -- dog_12_4x
            x=936,
            y=2,
            width=310,
            height=640,

            sourceX = 3,
            sourceY = 0,
            sourceWidth = 320,
            sourceHeight = 670
        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 2048
}

SheetInfo.frameIndex =
{

    ["dog_01_4x"] = 1,
    ["dog_02_4x"] = 2,
    ["dog_03_4x"] = 3,
    ["dog_04_4x"] = 4,
    ["dog_05_4x"] = 5,
    ["dog_06_4x"] = 6,
    ["dog_07_4x"] = 7,
    ["dog_08_4x"] = 8,
    ["dog_09_4x"] = 9,
    ["dog_10_4x"] = 10,
    ["dog_11_4x"] = 11,
    ["dog_12_4x"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
