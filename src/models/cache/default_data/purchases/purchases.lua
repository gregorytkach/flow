
local function getDataPurchaseCurrency(content_count, price_hard)
    local result = 
    {
        content_count    = content_count,
        price_hard      = price_hard,
        price_soft      = 0,
        name            = "currency_"..content_count,
        type            = EPurchaseTypeBase.EPT_CURRENCY_SOFT
    }
    
    return result
end

local function getDataPurchaseEnergy(content_count, price_hard)
    local result =
    {
        content_count   = content_count,
        price_hard      = price_hard,
        price_soft      = 0,
        name            = "energy_"..content_count,
        type            = EPurchaseTypeBase.EPT_ENERGY
    }
    
    return result
end

local function getDataPurchases()
    local result = {}
    
    table.insert(result, getDataPurchaseCurrency(100, 0.99))
    table.insert(result, getDataPurchaseCurrency(200, 1.99))
    table.insert(result, getDataPurchaseCurrency(300, 2.99))
    
    table.insert(result, getDataPurchaseEnergy(5, 0.99))
    table.insert(result, getDataPurchaseEnergy(10, 1.99))
    table.insert(result, getDataPurchaseEnergy(15, 2.99))
    table.insert(result, getDataPurchaseEnergy(20, 3.99))
    
    --boosters
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


return getDataPurchases()
