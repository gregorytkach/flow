EFlowType =
{
    ["EFT_NONE"]  = "NONE";
    ["EFT_0"]     = 0;
    ["EFT_1"]     = 1;
    ["EFT_2"]     = 2;
    ["EFT_3"]     = 3;
    
    
    ["EFT_COUNT"] = 4;
}


function EFlowType.getColor(type)
    local result = {}
    
    if(type == EFlowType.EFT_0)then
        
        result[0] = 1
        result[1] = 0
        result[2] = 0
        
    elseif(type == EFlowType.EFT_1)then
        
        result[0] = 0
        result[1] = 1
        result[2] = 0
        
    else
        assert(false)
    end
    
    return result
end
