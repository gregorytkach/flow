require('game_flow.src.models.purchases.EPurchaseType')
require('game_flow.src.models.bonus.EBonusType')

require('sdk.models.purchases.EPurchaseTypeBase')
require('game_flow.src.models.game.GridCreator')


function getManagerLevels()
    local result = {}
    
    local levels = {}
    
    --table.insert(levels, getLevelEditorData(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(true))
    table.insert(levels, getLevel0Data(false))
    table.insert(levels, getLevel0Data(false))
    table.insert(levels, getLevel0Data(false))
    table.insert(levels, getLevel0Data(false))
    
    result.levels = levels
    
    return result
end

function getManagerPlayers()
    local result = {}
    
    local playerData =
    {
        currency_soft                   = 100,
        energy                          = 3,
        
        free_purchase_count_add_time    = 10,
        free_purchase_count_resolve     = 3,
        free_purchase_count_show_turn   = 0
        
    }
    
    result.player_current = playerData
    
    return result
end

function getManagerBonus()
    local result = {}
    
    local bonuses = 
    {
        {   type            = EBonusType.EBT_CURRENCY,              content_count   = 20  },
        {   type            = EBonusType.EBT_PURCHASE_RESOLVE,      content_count   = 1   },
        {   type            = EBonusType.EBT_CURRENCY,              content_count   = 10  },
        {   type            = EBonusType.EBT_CURRENCY,              content_count   = 30  },
        {   type            = EBonusType.EBT_ENERGY,                content_count   = 2   },
        {   type            = EBonusType.EBT_ENERGY,                content_count   = 1   },
        {   type            = EBonusType.EBT_CURRENCY,              content_count   = 50  },
        {   type            = EBonusType.EBT_PURCHASE_SHOW_TURN,    content_count   = 1   },
        {   type            = EBonusType.EBT_CURRENCY,              content_count   = 40  },
        {   type            = EBonusType.EBT_CURRENCY,              content_count   = 20  },
        {   type            = EBonusType.EBT_ENERGY,                content_count   = 3   },
        {   type            = EBonusType.EBT_CURRENCY,              content_count   = 40  },
        {   type            = EBonusType.EBT_CURRENCY,              content_count   = 20  },
        {   type            = EBonusType.EBT_PURCHASE_ADD_TIME,     content_count   = 1   },
        {   type            = EBonusType.EBT_CURRENCY,              content_count   = 50  },
        {   type            = EBonusType.EBT_CURRENCY,              content_count   = 10  },
    }
    
    result.bonuses      = bonuses  
    result.time_period  = 1
    result.time_left    = 1
    
    result.energy       = 
    {
        time_period = 15 * 60,
        time_left   = 5,
        bonus       =
        {
            type            = EBonusType.EBT_ENERGY,
            content_count   = 1
        }
    }
    
    return result
end

function getManagerPurchasesData()
    local result = {}
    
    local purchaseDataCurrency = 
    {
        content_count   = 1,
        price_hard      = 10,
        price_soft      = 0,
        name            = "currency_10",
        type            = EPurchaseTypeBase.EPT_CURRENCY_SOFT
    }
    
    table.insert(result, purchaseDataCurrency)
    result[1].price_hard     = 0.99
    result[1].content_count  = 1
    
    table.insert(result, purchaseDataCurrency)
    result[2].price_hard     = 9.99
    result[2].content_count  = 10
    
    table.insert(result, purchaseDataCurrency)
    result[3].price_hard     = 99.99
    result[3].content_count  = 100
    
    
    
    local purchaseDataEnergy =
    {
        content_count   = 1,
        price_hard      = 10,
        price_soft      = 0,
        name            = "energy_10",
        type            = EPurchaseTypeBase.EPT_ENERGY
    }
    
    table.insert(result, purchaseDataEnergy)
    table.insert(result, purchaseDataEnergy)
    table.insert(result, purchaseDataEnergy)
    table.insert(result, purchaseDataEnergy)
    
    local purchaseDataAddTime =
    {
        content_count   = 1,
        price_hard      = 0,
        price_soft      = 10,
        name            = "add_time",
        type            = EPurchaseType.EPT_ADD_TIME
    }
    
    table.insert(result, purchaseDataAddTime)
    
    
    
    local purchaseResolve =
    {
        content_count   = 1,
        price_hard      = 0,
        price_soft      = 10,
        name            = "add_time",
        type            = EPurchaseType.EPT_RESOLVE
    }
    
    table.insert(result, purchaseResolve)
    
    local purchaseShowTurn =
    {
        content_count   = 1,
        price_hard      = 0,
        price_soft      = 10,
        name            = "add_time",
        type            = EPurchaseType.EPT_SHOW_TURN
    }
    
    table.insert(result, purchaseShowTurn)
    
    return result
end

function getLevelEditorData(isComplete)
    
    local paramsCreator =
    {
        rows    = 5,
        columns = 5,
        bridgesCount = 4,
        barriersCount = 6

    }
        
    local gridCreator = GridCreator:new(paramsCreator)

    gridCreator:shuffles(1)

    local gridData = gridCreator:gridData()
    local result =
    {
        grid_data        = gridData,
        time_left        = 60,
        
        reward_scores    = 5,
        is_complete      = isComplete,
        progress =
        {
            is_complete      = isComplete,
            stars_count      = 3,
        }
    }
    
    return result
    
end


function getLevel0Data(isComplete)
    local gridData = {}
    
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
            elseif(rowIndex == 3 and columnIndex == 3)then
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
        
        table.insert(gridData, row)
    end
    
    local result =
    {
        grid_data        = gridData,
        time_left        = 60,
        
        reward_scores    = 5,
        is_complete      = isComplete,
        progress =
        {
            is_complete      = isComplete,
            stars_count      = 3,
        }
    }
    
    return result
end

