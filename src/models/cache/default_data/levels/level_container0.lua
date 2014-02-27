local function getDataLevelContainer0()
    local result = 
    {
        id              = 'some_id',
        number          = 1,
        name            = 'container_1',
        requirements    = {}
    }
    
    local levels = 
    {
        require('game_flow.src.models.cache.default_data.levels.level_container0.level0')
    }
    
    result.levels = levels
    
    return result
end

return getDataLevelContainer0()
