
require('game_flow.src.controllers.game.ControllerGrid')

ControllerGridEditor = classWithSuper(ControllerGrid, 'ControllerGrid')



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
                
                cell:update(EControllerUpdate.ECUT_INCLUSION_IN_LINE)
                
            end
        end
        
        
        
    else
        
        assert(false)
    end
    
end

function ControllerGridEditor.cleanup(self)
    
    ControllerGrid.cleanup(self)
    
    self._currentState = nil
    
end


