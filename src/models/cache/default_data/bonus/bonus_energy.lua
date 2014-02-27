local function getDataBonusEnergy()
    local result = 
    {
        limit       = 5,
        time_period = 15 * 60,
        time_left   = 1
    }
    
    result.bonuses       = 
    {
        { type            = EBonusType.EBT_ENERGY,  content_count   = 1 }
    }
    
    return result
end

return getDataBonusEnergy()

