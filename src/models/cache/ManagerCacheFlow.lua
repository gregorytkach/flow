ManagerCacheFlow = classWithSuper(ManagerCacheBase, 'ManagerCacheFlow')

--
-- Properties
--

function ManagerCacheFlow.getDataPlayerCurrent(self)
    local result = require('game_flow.src.models.cache.default_data.players.player_current')
    
    return result
end

function ManagerCacheFlow.getDataLevelContainers(self)
    local result = 
    {
        require('game_flow.src.models.cache.default_data.levels.level_container0')
    }
    
    return result
end

function ManagerCacheFlow.getDataPurchases(self)
    local result = require('game_flow.src.models.cache.default_data.purchases.purchases')
    return result
end

function ManagerCacheFlow.getDataBonus(self)
    local result = require('game_flow.src.models.cache.default_data.bonus.bonus')
    return result
end

function ManagerCacheFlow.getDataBonusEnergy(self)
    local result = require('game_flow.src.models.cache.default_data.bonus.bonus_energy')
    return result
end


--
-- Methods
--

function ManagerCacheFlow.init(self)
    ManagerCacheBase.init(self)
end


function ManagerCacheFlow.cleanup(self)
    ManagerCacheBase.cleanup(self)
end

