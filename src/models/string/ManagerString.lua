require('game_flow.src.models.string.EStringType')

ManagerString = classWithSuper(ManagerStringBase, 'ManagerString')


function ManagerString.init(self)
    ManagerStringBase.init(self)
    
    self:initLanguageEnglish()
    self:initLanguageRussian()
    
end

function ManagerString.initLanguageEnglish(self)
    ManagerStringBase.initLanguageEnglish(self)
    
    local language = self._languages[ELanguageType.ELT_ENGLISH]
    
    language[EStringType.EST_GAME_SCORES] = 'Scores:'
    
    --game
    language[EStringType.EST_GAME_PURCHASE_FREE]            = 'FREE: %s'
    
    --map
    language[EStringType.EST_STATE_MAP_FREE_CURRENCY]       = 'FREE CURRENCY'
    
    --bonus
    language[EStringType.EST_POPUP_BONUS_TITLE]             = 'DAILY BONUS'
    language[EStringType.EST_POPUP_BONUS_TIME]              = '%i:%i'
    language[EStringType.EST_POPUP_BONUS_BUTTON_CLOSE]      = 'CLOSE'
    language[EStringType.EST_POPUP_BONUS_REWARD]            = 'REWARD:'
    language[EStringType.EST_POPUP_BONUS_BUTTON_SPIN]       = 'SPIN'
    
    --no currency
    language[EStringType.EST_POPUP_NO_CURRENCY_TITLE]       = 'OOPS'
    language[EStringType.EST_POPUP_NO_CURRENCY_TEXT]        = 'NO CURRENCY'
    
    --no energy
    language[EStringType.EST_POPUP_NO_ENERGY_TITLE]         = 'OOPS'
    language[EStringType.EST_POPUP_NO_ENERGY_TEXT]          = 'NO ENERGY'
    
    --no resource
    language[EStringType.EST_POPUP_NO_RESOURCE_BUTTON_BUY]    = 'BUY'
    language[EStringType.EST_POPUP_NO_RESOURCE_BUTTON_CLOSE]  = 'CLOSE'
    
    --game over
    language[EStringType.EST_POPUP_GAME_OVER_BUTTON_CLOSE]  = 'OK'
    language[EStringType.EST_POPUP_GAME_OVER_TEXT]          = 'YOU LOSE'
    language[EStringType.EST_POPUP_GAME_OVER_TITLE]         = 'GAME OVER'
    
    
    --win
    language[EStringType.EST_POPUP_WIN_TITLE]               = 'CONGRATULATIONS!'
    language[EStringType.EST_POPUP_WIN_BUTTON_CLOSE]        = 'OK'
    language[EStringType.EST_POPUP_WIN_TEXT]                = 'YOU ARE %i LEVELS!'
    language[EStringType.EST_POPUP_WIN_REWARD]              = 'REWARD:'
    
    
    --shop
    language[EStringType.EST_POPUP_SHOP_TITLE]              = 'SHOP'
    language[EStringType.EST_POPUP_SHOP_BUTTON_CURRENCY]    = 'BONES'
    language[EStringType.EST_POPUP_SHOP_BUTTON_ENERGY]      = 'LIFES'
    language[EStringType.EST_POPUP_SHOP_BUTTON_CLOSE]       = 'CLOSE'
    language[EStringType.EST_POPUP_SHOP_BUTTON_BUY]         = 'BUY'
    
end

function ManagerString.initLanguageRussian(self)
    ManagerStringBase.initLanguageRussian(self)
    
end


