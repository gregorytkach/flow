require('game_flow.src.views.game.ViewStubs')

ViewStateGame = classWithSuper(ViewStateBase, 'ViewStateGame')


--
--Properties
--

function ViewStateGame.getType(self)
    return EStateType.EST_GAME 
end

--
--Methods
--



function ViewStateGame.init(self, params)
    ViewStateBase.init(self, params)
    
    
    --todo:implement
    -- self._viewStubs = ViewStubs:new(params)
    -- self._sourceView:insert(self._viewStubs:sourceView())
    
end

function ViewStateGame.placeViews(self)
    ViewStateBase.placeViews(self)
    
    --todo:implement
    -- self._viewStubs:sourceView().x = application.margin_right +  self._viewStubs:realWidth() / 2
    -- self._viewStubs:sourceView().y = application.margin_right +  self._viewStubs:realHeight() / 2
    
end

function ViewStateGame.cleanup(self)
    
    --todo:implement
    -- self._viewStubs:cleanup()
    -- self._viewStubs = nil
    
    ViewStateBase.cleanup(self)
end