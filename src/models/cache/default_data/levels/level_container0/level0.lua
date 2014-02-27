local function getDataLevel0_0()
    local dataGrid = {}
    
    for rowIndex = 1, 5, 1 do
        local row = {}
        
        for columnIndex = 1, 5, 1 do
            
            local cellData
            
            if(rowIndex == 1 and columnIndex == 2)then
                cellData =
                {
                    type          = ECellType.ECT_FLOW_POINT,
                    flow_type     = EFlowType.EFT_0,
                    is_start      = false
                } 
            elseif(rowIndex == 3 and columnIndex == 4)then
                cellData =
                {
                    type          = ECellType.ECT_FLOW_POINT,
                    flow_type     = EFlowType.EFT_0,
                    is_start      = true
                }
            elseif(rowIndex == 2 and columnIndex == 2)then
                cellData =
                {
                    type          = ECellType.ECT_FLOW_POINT,
                    flow_type     = EFlowType.EFT_1,
                    is_start      = true
                } 
            elseif(rowIndex == 4 and columnIndex == 1)then
                cellData =
                {
                    type          = ECellType.ECT_FLOW_POINT,
                    flow_type     = EFlowType.EFT_1,
                    is_start      = false
                } 
            elseif(rowIndex == 4 and columnIndex == 3)then
                cellData =
                {
                    type          = ECellType.ECT_BRIDGE,
                    flow_type     = EFlowType.EFT_NONE,
                }
            elseif(rowIndex == 5 and columnIndex == 5)then
                cellData =
                {
                    type          = ECellType.ECT_BARRIER,
                    flow_type     = EFlowType.EFT_NONE,
                }
            else
                cellData =
                {
                    type          = ECellType.ECT_EMPTY,
                    flow_type     = EFlowType.EFT_NONE,
                } 
            end
            
            cellData.x = columnIndex
            cellData.y = rowIndex
            
            table.insert(row, cellData)
            
        end
        
        table.insert(dataGrid, row)
    end
    
    local result =
    {
        data_grid               = dataGrid,
        data_lines               = 
        {
            [EFlowType.EFT_0]     = 
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
        time_left               = 60,
        
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
