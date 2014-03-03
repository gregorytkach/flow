local function getDataLines_1393603712()
	local result =
	{
		[EFlowType.EFT_0] =
		{
			{
				x = 4,
				y = 1,
			},
			{
				x = 4,
				y = 4,
			},
			{
				x = 5,
				y = 4,
			}
		},
		[EFlowType.EFT_1] =
		{
			{
				x = 5,
				y = 5,
			},
			{
				x = 1,
				y = 5,
			},
			{
				x = 1,
				y = 4,
			}
		},
		[EFlowType.EFT_2] =
		{
			{
				x = 1,
				y = 1,
			},
			{
				x = 1,
				y = 3,
			},
			{
				x = 2,
				y = 3,
			},
			{
				x = 2,
				y = 2,
			}
		},
		[EFlowType.EFT_3] =
		{
			{
				x = 2,
				y = 4,
			},
			{
				x = 3,
				y = 4,
			},
			{
				x = 3,
				y = 3,
			},
			{
				x = 5,
				y = 3,
			},
			{
				x = 5,
				y = 2,
			},
			{
				x = 3,
				y = 2,
			}
		}
	}
return result
end	
local function getDataGrid_1393603712()
	local result = {}

	for rowIndex = 1, 5, 1 do

		local row = {}

		for columnIndex = 1, 5, 1 do

			local cellData

			if(rowIndex == 1 and columnIndex == 1)then
				cellData = 
				{
					type = ECellType.ECT_FLOW_POINT,
					is_start = true,
					flow_type = EFlowType.EFT_2,
				}
			elseif(rowIndex == 1 and columnIndex == 2)then
				cellData = 
				{
					type = ECellType.ECT_BARRIER,
					flow_type = EFlowType.EFT_NONE,
				}
			elseif(rowIndex == 1 and columnIndex == 3)then
				cellData = 
				{
					type = ECellType.ECT_BARRIER,
					flow_type = EFlowType.EFT_NONE,
				}
			elseif(rowIndex == 1 and columnIndex == 4)then
				cellData = 
				{
					type = ECellType.ECT_FLOW_POINT,
					is_start = true,
					flow_type = EFlowType.EFT_0,
				}
			elseif(rowIndex == 1 and columnIndex == 5)then
				cellData = 
				{
					type = ECellType.ECT_BARRIER,
					flow_type = EFlowType.EFT_NONE,
				}
			elseif(rowIndex == 2 and columnIndex == 2)then
				cellData = 
				{
					type = ECellType.ECT_FLOW_POINT,
					is_start = false,
					flow_type = EFlowType.EFT_2,
				}
			elseif(rowIndex == 2 and columnIndex == 3)then
				cellData = 
				{
					type = ECellType.ECT_FLOW_POINT,
					is_start = true,
					flow_type = EFlowType.EFT_3,
				}
			elseif(rowIndex == 2 and columnIndex == 4)then
				cellData = 
				{
					type = ECellType.ECT_BRIDGE,
					flow_type = EFlowType.EFT_NONE,
				}
			elseif(rowIndex == 3 and columnIndex == 4)then
				cellData = 
				{
					type = ECellType.ECT_BRIDGE,
					flow_type = EFlowType.EFT_NONE,
				}
			elseif(rowIndex == 4 and columnIndex == 1)then
				cellData = 
				{
					type = ECellType.ECT_FLOW_POINT,
					is_start = true,
					flow_type = EFlowType.EFT_1,
				}
			elseif(rowIndex == 4 and columnIndex == 2)then
				cellData = 
				{
					type = ECellType.ECT_FLOW_POINT,
					is_start = false,
					flow_type = EFlowType.EFT_3,
				}
			elseif(rowIndex == 4 and columnIndex == 5)then
				cellData = 
				{
					type = ECellType.ECT_FLOW_POINT,
					is_start = false,
					flow_type = EFlowType.EFT_0,
				}
			elseif(rowIndex == 5 and columnIndex == 5)then
				cellData = 
				{
					type = ECellType.ECT_FLOW_POINT,
					is_start = false,
					flow_type = EFlowType.EFT_1,
				}
			else
				cellData = 
				{
					type = ECellType.ECT_EMPTY,
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

local function getDataLevel0_2()
    
    local result =
    {
        data_grid                   = getDataGrid_1393603712(),
        data_lines                  = getDataLines_1393603712(),
        
        time_left               = 30,
        
        reward_currency_soft    = 50,
        reward_scores           = 5,
        progress                =
        {
            is_complete         = false,
        }
    }
    
    return result
end


return getDataLevel0_2()


