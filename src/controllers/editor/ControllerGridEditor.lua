
require('game_flow.src.controllers.game.ControllerGrid')

ControllerGridEditor = classWithSuper(ControllerGrid, 'ControllerGrid')

function ControllerGridEditor.onViewClicked(self, target, event)
    
    if (self._buttonShuffle == target) then
                    
        self._managerGame:shuffle(500)
        
    else
        assert(false)
    end
    
    
end

--
--Methods
--

function ControllerGridEditor.init(self)
    ControllerGrid.init(self)
    
     
    
end

function ControllerGridEditor.update(self, type)
    
    if(type == EControllerUpdate.ECUT_EDIT)then
        
        for _, row in ipairs(self._cells)do
            for _, cell in ipairs(row)do
                cell:view():establishBounds()
                cell:update(EControllerUpdate.ECUT_INCLUSION_IN_LINE)
            end
        end
        self._buttonShuffle = self._view:createButton(GameInfo:instance():managerResources():getAsButton(EResourceType.ERT_STATE_EDITOR_BUTTON_SHUFFLE))
        
        local sourceShuffle = self._buttonShuffle:sourceView() 

        sourceShuffle.x = 0
        sourceShuffle.y = self._view:realHeight() / 2 + self._buttonShuffle:realHeight() / 2
        
    elseif(type == EControllerUpdate.ECUT_EDIT)then
       
        
    else
        assert(false)
    end
    
end

function ControllerGridEditor.cleanup(self)
    
    ControllerGrid.cleanup(self)
    
    self._buttonShuffle:cleanup()
    self._buttonShuffle = nil
    
end


