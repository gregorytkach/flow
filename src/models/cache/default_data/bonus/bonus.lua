local function getDataBonus()
    
    local result = 
    {
        time_period  = 12 * 60 * 60,
        time_left    = 0
    }
    
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
    
    return result
end

return getDataBonus()

