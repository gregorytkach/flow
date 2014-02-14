--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:725d75463213b0b2f48dc8957d11c9e3:f7f184ca1f0733d7a6dce8a7694a8c3a:f831e6898c0fd91086524f46faeb2240$
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
            x=2,
            y=2,
            width=322,
            height=346,

            sourceX = 3,
            sourceY = 7,
            sourceWidth = 330,
            sourceHeight = 370
        },
        {
            -- dog_02_4x
            x=650,
            y=2,
            width=322,
            height=344,

            sourceX = 3,
            sourceY = 9,
            sourceWidth = 330,
            sourceHeight = 370
        },
        {
            -- dog_03_4x
            x=2,
            y=350,
            width=322,
            height=342,

            sourceX = 3,
            sourceY = 11,
            sourceWidth = 330,
            sourceHeight = 370
        },
        {
            -- dog_04_4x
            x=650,
            y=690,
            width=322,
            height=340,

            sourceX = 3,
            sourceY = 13,
            sourceWidth = 330,
            sourceHeight = 370
        },
        {
            -- dog_05_4x
            x=326,
            y=1032,
            width=322,
            height=338,

            sourceX = 3,
            sourceY = 15,
            sourceWidth = 330,
            sourceHeight = 370
        },
        {
            -- dog_06_4x
            x=2,
            y=694,
            width=322,
            height=338,

            sourceX = 3,
            sourceY = 15,
            sourceWidth = 330,
            sourceHeight = 370
        },
        {
            -- dog_07_4x
            x=326,
            y=692,
            width=322,
            height=338,

            sourceX = 3,
            sourceY = 15,
            sourceWidth = 330,
            sourceHeight = 370
        },
        {
            -- dog_08_4x
            x=650,
            y=348,
            width=322,
            height=340,

            sourceX = 3,
            sourceY = 13,
            sourceWidth = 330,
            sourceHeight = 370
        },
        {
            -- dog_09_4x
            x=326,
            y=348,
            width=322,
            height=342,

            sourceX = 3,
            sourceY = 11,
            sourceWidth = 330,
            sourceHeight = 370
        },
        {
            -- dog_10_4x
            x=326,
            y=2,
            width=322,
            height=344,

            sourceX = 3,
            sourceY = 9,
            sourceWidth = 330,
            sourceHeight = 370
        },
        {
            -- dog_11_4x
            x=2,
            y=2,
            width=322,
            height=346,

            sourceX = 3,
            sourceY = 7,
            sourceWidth = 330,
            sourceHeight = 370
        },
    },
    
    sheetContentWidth = 1024,
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
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
