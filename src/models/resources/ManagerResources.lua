require('game_flow.src.models.resources.EResourceType')

ManagerResources = classWithSuper(ManagerResourcesBase, 'ManagerResources') 

--
--Methods
--

function ManagerResources.init(self)
    ManagerResourcesBase.init(self)
    
    --common
    self._resources[EResourceType.ERT_POPUP_BUTTON_BLUE0]           = '%scommon/button_blue_0/%s%s.png'
    self._resources[EResourceType.ERT_POPUP_BUTTON_BLUE1]           = '%scommon/button_blue_1/%s%s.png'
    self._resources[EResourceType.ERT_POPUP_BUTTON_GREEN]           = '%scommon/button_green/%s%s.png'
    
    self._resources[EResourceType.ERT_BUTTON_SHOP]                  = '%scommon/button_shop/%s%s.png'
    self._resources[EResourceType.ERT_BUTTON_HELP]                  = '%scommon/button_help/%s%s.png'
    
    self._resources[EResourceType.ERT_ICON_ENERGY]                  = '%scommon/icon_energy/icon_energy%s.png'
    self._resources[EResourceType.ERT_ICON_CURRENCY]                = '%scommon/icon_currency/icon_currency%s.png'
    
    self._resources[EResourceType.ERT_VIEW_CURRENCY]                = '%scommon/view_currency_soft/view_currency_soft%s.png'
    
    --popup bonus
    self._resources[EResourceType.ERT_POPUP_BONUS_VIEW_TIME]        = '%spopup_bonus/view_time/view_time%s.png'
    self._resources[EResourceType.ERT_POPUP_BONUS_VIEW_REWARD]      = '%spopup_bonus/view_reward/view_reward%s.png'
    self._resources[EResourceType.ERT_POPUP_BONUS_ARROW]            = '%spopup_bonus/arrow/arrow%s.png'
    self._resources[EResourceType.ERT_POPUP_BONUS_DRUM]             = '%spopup_bonus/drum/drum%s.png'
    self._resources[EResourceType.ERT_POPUP_BONUS_VIEW_DRUM]        = '%spopup_bonus/view_drum/view_drum%s.png'
    
    
    --popup game over
    self._resources[EResourceType.ERT_POPUP_GAME_OVER_VIEW_PENALTY] = '%spopup_game_over/view_penalty/view_penalty%s.png'
    self._resources[EResourceType.ERT_POPUP_GAME_OVER_VIEW_TEXT]    = '%spopup_game_over/view_text/view_text%s.png'
    
    
    --popup no resource
    self._resources[EResourceType.ERT_POPUP_NO_RESOURCE_VIEW_TEXT]    = '%spopup_no_resource/view_text/view_text%s.png'
    
    --popup win
    self._resources[EResourceType.ERT_POPUP_WIN_VIEW_TEXT]          = '%spopup_win/view_text/view_text%s.png'
    self._resources[EResourceType.ERT_POPUP_WIN_VIEW_REWARD]        = '%spopup_win/view_reward/view_reward%s.png'
    
    --popup shop
    self._resources[EResourceType.ERT_POPUP_SHOP_VIEW_ITEM]         = '%spopup_shop/view_item/view_item%s.png'
    
    --state game
    self._resources[EResourceType.ERT_STATE_GAME_BUTTON_HOME]       = '%sstate_game/ui/button_home/%s%s.png'
    
    self._resources[EResourceType.ERT_STATE_GAME_VIEW_TIME]         = '%sstate_game/ui/view_time/view_time%s.png'
    
    self._resources[EResourceType.ERT_STATE_GAME_BUTTON_RESOLVE]    = '%sstate_game/ui/view_purchases/button_resolve/%s%s.png'
    self._resources[EResourceType.ERT_STATE_GAME_BUTTON_SHOW_TURN]  = '%sstate_game/ui/view_purchases/button_show_turn/%s%s.png'
    self._resources[EResourceType.ERT_STATE_GAME_BUTTON_ADD_TIME]   = '%sstate_game/ui/view_purchases/button_add_time/%s%s.png'
    
    --cells
    self._resources[EResourceType.ERT_STATE_GAME_CELL_START]        = '%sstate_game/dogs/%s/cell_start/cell_start%s.png'
    self._resources[EResourceType.ERT_STATE_GAME_CELL_END]          = '%sstate_game/dogs/%s/cell_end/cell_end%s.png'
    self._resources[EResourceType.ERT_STATE_GAME_CELL_PATH]         = '%sstate_game/dogs/%s/cell_path/cell_path%s.png'
   
    self._resources[EResourceType.ERT_STATE_GAME_CELL_DEFAULT]      = '%sstate_game/cells/default/%s/cell_default%s.png'
    self._resources[EResourceType.ERT_STATE_GAME_CELL_BARRIER]      = '%sstate_game/cells/barrier/cell_barrier%s.png'
    self._resources[EResourceType.ERT_STATE_GAME_CELL_BRIDGE]       = '%sstate_game/cells/bridge/cell_bridge%s.png'
    
    --state map
    self._resources[EResourceType.ERT_STATE_MAP_VIEW_TIME_BONUS]    = '%sstate_map/ui/view_time_bonus/view_time_bonus%s.png'
    self._resources[EResourceType.ERT_STATE_MAP_VIEW_TIME_ENERGY]   = '%sstate_map/ui/view_time_energy/view_time_energy%s.png'
    
    self._resources[EResourceType.ERT_STATE_MAP_VIEW_ENERGY]        = '%sstate_map/ui/view_energy/view_energy%s.png'
    
    self._resources[EResourceType.ERT_STATE_MAP_BUTTON_SOUND]           = '%sstate_map/ui/button_sound/%s%s.png'
    self._resources[EResourceType.ERT_STATE_MAP_BUTTON_SOUND_DISABLED]  = '%sstate_map/ui/button_sound_disabled/%s%s.png'
    
    self._resources[EResourceType.ERT_STATE_MAP_BUTTON_FREE_CURRENCY]   = '%sstate_map/ui/button_free_currency/%s%s.png'
    self._resources[EResourceType.ERT_STATE_MAP_BUTTON_BONUS]       = '%sstate_map/ui/button_bonus/%s%s.png'
    
    self._resources[EResourceType.ERT_STATE_MAP_MAP_PART]           = '%sstate_map/map/map_%s%s.jpg'
    self._resources[EResourceType.ERT_STATE_MAP_VIEW_GRASS]         = '%sstate_map/ui/view_grass/view_grass%s.png'
    
    self._resources[EResourceType.ERT_STATE_MAP_ITEM_COMPLETE]      = '%sstate_map/button_level/complete/%s%s.png'
    self._resources[EResourceType.ERT_STATE_MAP_ITEM_COMPLETE_ICON] = '%sstate_map/button_level/complete/icon/icon%s.png'
    
    self._resources[EResourceType.ERT_STATE_MAP_ITEM_CURRENT]       = '%sstate_map/button_level/current/%s%s.png'
    
    self._resources[EResourceType.ERT_STATE_MAP_ITEM_CLOSE]         = '%sstate_map/button_level/close/level_close%s.png'
    
    
end

function ManagerResources.initAnimations(self)
    ManagerResourcesBase.initAnimations(self)
    
    local popupWinAnimationDog = 
    {
        {
            name    = "default",
            start   = 1,
            count   = 10,
            time  = application.animation_duration * 4
        }
    }
    self._resources[EResourceType.ERT_POPUP_WIN_ANIMATION_DOG]  = '%spopup_win/animations/dog/spritesheet%s.png'
    self._animations[EResourceType.ERT_POPUP_WIN_ANIMATION_DOG] = popupWinAnimationDog
    
    
    local popupWinAnimationBalloon = 
    {
        {
            name    = "default",
            start   = 1,
            count   = 10,
            time  = application.animation_duration * 2
        }
    }
    self._resources[EResourceType.ERT_POPUP_WIN_ANIMATION_BALLOONS]  = '%spopup_win/animations/balloon/spritesheet%s.png'
    self._animations[EResourceType.ERT_POPUP_WIN_ANIMATION_BALLOONS] = popupWinAnimationBalloon
    
    
    local popupGameOverAnimationDog = 
    {
        {
            name    = "default",
            start   = 1,
            count   = 12,
            time  = application.animation_duration * 2
        }
    }
    
    self._resources[EResourceType.ERT_POPUP_GAME_OVER_VIEW_ANIMATION_DOG]  = '%spopup_game_over/animations/dog/spritesheet%s.png'
    self._animations[EResourceType.ERT_POPUP_GAME_OVER_VIEW_ANIMATION_DOG] = popupGameOverAnimationDog
    
    local stateMapItemCurrentAnimation = 
    {
        {
            name    = "default",
            start   = 1,
            count   = 15,
            time  = application.animation_duration * 4
        }
    }
    
    self._resources[EResourceType.ERT_STATE_MAP_ITEM_CURRENT_ANIMATION]    = '%sstate_map/button_level/current/animation/spritesheet%s.png'
    self._animations[EResourceType.ERT_POPUP_GAME_OVER_VIEW_ANIMATION_DOG] = stateMapItemCurrentAnimation
    
    local gameAnimationDogDown = 
    {
        {
            name    = "default",
            start   = 1,
            count   = 14,
            time  = application.animation_duration * 4
        }
    }
    self._resources[EResourceType.ERT_STATE_GAME_ANIMATION_DOG_DOWN]    = '%sstate_game/dogs/%s/animation/down/spritesheet%s.png'
    self._animations[EResourceType.ERT_STATE_GAME_ANIMATION_DOG_DOWN] = gameAnimationDogDown
    
    local gameAnimationDogIdle = 
    {
        {
            name    = "default",
            start   = 1,
            count   = 9,
            time  = application.animation_duration * 4
        }
    }
    self._resources[EResourceType.ERT_STATE_GAME_ANIMATION_DOG_IDLE]  = '%sstate_game/dogs/%s/animation/idle/spritesheet%s.png'
    self._animations[EResourceType.ERT_STATE_GAME_ANIMATION_DOG_IDLE] = gameAnimationDogIdle
    
    local gameAnimationDogUp = 
    {
        {
            name    = "default",
            start   = 1,
            count   = 19,
            time  = application.animation_duration * 4
        }
    }
    self._resources[EResourceType.ERT_STATE_GAME_ANIMATION_DOG_UP]  = '%sstate_game/dogs/%s/animation/up/spritesheet%s.png'
    self._animations[EResourceType.ERT_STATE_GAME_ANIMATION_DOG_UP] = gameAnimationDogUp
    
    
    
end

function ManagerResources.setDogAnimationResource(self, flowType)
    
    assert(flowType ~= nil)
    self._resources[EResourceType.ERT_STATE_GAME_ANIMATION_DOG_DOWN] = '%sstate_game/dogs/'..flowType..'/animation/down/spritesheet%s.png'
    self._resources[EResourceType.ERT_STATE_GAME_ANIMATION_DOG_IDLE] = '%sstate_game/dogs/'..flowType..'/animation/idle/spritesheet%s.png'
    self._resources[EResourceType.ERT_STATE_GAME_ANIMATION_DOG_UP] = '%sstate_game/dogs/'..flowType..'/animation/up/spritesheet%s.png'
    
    
end

function ManagerResources.getStateBackground(self, value)
    local result = ''
    
    if (value == EStateType.EST_GAME) then
        result = '%sstate_game/background/background%s.jpg'
    elseif(value == EStateType.EST_MAP)then
        result = '%sstate_map/map/map_1%s.jpg'
    elseif (value == EStateType.EST_EDITOR) then
        result = '%sstate_game/background/background%s.jpg'
    else
        assert(false)
    end
    
    result = string.format(result, application.assets_dir, application.scaleSuffix)
    
    return result
end



--
-- Popups
--
function ManagerResources.getPopupBackground(self, type)
    
    local result = ''
    
    if (type == EPopupType.EPT_SHOP) then
        result = '%spopup_shop/background/background%s.png'
    elseif (type == EPopupType.EPT_WIN) then
        result = '%spopup_win/background/background%s.png'
    elseif (type == EPopupType.EPT_GAME_OVER) then
        result = '%spopup_game_over/background/background%s.png'
    elseif (type == EPopupType.EPT_BONUS) then
        result = '%spopup_bonus/background/background%s.png'
    elseif(type == EPopupType.EPT_NO_CURRENCY)then
        result = '%spopup_no_resource/background/background%s.png'
    elseif(type == EPopupType.EPT_NO_ENERGY)then
        result = '%spopup_no_resource/background/background%s.png'
    else
        assert(false)
    end
    
    result = string.format(result, application.assets_dir, application.scaleSuffix)
    
    return result
    
end

--
--Game
--

--
--Cells
--