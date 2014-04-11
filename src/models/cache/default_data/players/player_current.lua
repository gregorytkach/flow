local function getDataPlayerCurrent()
    local  result = 
    {
        uuid                            = application.device_id,
        currency_soft                   = 10000,
        energy                          = 5,
        
        free_purchase_count_add_time    = 3,
        free_purchase_count_resolve     = 3,
        free_purchase_count_show_turn   = 3,
        free_bonus_spins                = 1
    }
    
    return result
end

return getDataPlayerCurrent()

