
local function getDataGrid_1393510123()
    local result = {}
    
    for rowIndex = 1, 5, 1 do
        
        local row = {}
        
        for columnIndex = 1, 5, 1 do
            
            local cellData
            
            if(rowIndex == 1 and columnIndex == 1)then
                cellData = 
                {
                    type = ECellType.ECT_FLOW_POINT,
                    flow_type = EFlowType.EFT_0,
                    is_start = false
                }
            elseif(rowIndex == 1 and columnIndex == 2)then
                cellData = 
                {
                    type = ECellType.ECT_FLOW_POINT,
                    flow_type = EFlowType.EFT_1,
                    is_start = false
                }
            elseif(rowIndex == 1 and columnIndex == 3)then
                cellData = 
                {
                    type = ECellType.ECT_FLOW_POINT,
                    flow_type = EFlowType.EFT_2,
                    is_start = false
                }
            elseif(rowIndex == 1 and columnIndex == 4)then
                cellData = 
                {
                    type = ECellType.ECT_FLOW_POINT,
                    flow_type = EFlowType.EFT_3,
                    is_start = false
                }
            elseif(rowIndex == 1 and columnIndex == 5)then
                cellData = 
                {
                    type = ECellType.ECT_FLOW_POINT,
                    flow_type = EFlowType.EFT_3,
                    is_start = false
                }
            elseif(rowIndex == 5 and columnIndex == 1)then
                cellData = 
                {
                    type = ECellType.ECT_FLOW_POINT,
                    flow_type = EFlowType.EFT_0,
                    is_start = false
                }
            elseif(rowIndex == 5 and columnIndex == 2)then
                cellData = 
                {
                    type = ECellType.ECT_FLOW_POINT,
                    flow_type = EFlowType.EFT_1,
                    is_start = false
                }
            elseif(rowIndex == 5 and columnIndex == 3)then
                cellData = 
                {
                    type = ECellType.ECT_FLOW_POINT,
                    flow_type = EFlowType.EFT_2,
                    is_start = false
                }
            else
                cellData = 
                {
                    type = ECellType.ECT_FLOW_EMPTY,
                    flow_type = EFlowType.EFT_NONE,
                }
            end
            
            cellData.x = columnIndex
            cellData.y = rowIndex
            
            table.insert(row, cellData)
        end
        
        table.insert(result, row)
    end
    
    return result
    
end	



local function getDataLevel0_0()
    
    local result =
    {
        data_grid                   = getDataGrid_1393510123(),
        data_lines                  = 
        {
            [EFlowType.EFT_0]       = 
            {
                {
                    x = 1,
                    y = 1,
                },
                {
                    x = 5,
                    y = 1
                }
            }
        },                
        time_left               = 600,
        
        reward_currency_soft    = 50,
        reward_scores           = 5,
        progress                =
        {
            is_complete         = false,
        }
    }
    
    return result
end


return getDataLevel0_0()
