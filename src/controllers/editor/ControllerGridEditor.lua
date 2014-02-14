
require('game_flow.src.controllers.game.ControllerGrid')

ControllerGridEditor = classWithSuper(ControllerGrid, 'ControllerGrid')

--
--Methods
--

function ControllerGridEditor.init(self)
    ControllerGrid.init(self)
    
end

function ControllerGridEditor.update(self, type)
    
    if(type == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        
        for indexRow, row in ipairs(self._cells)do
            for indexColumn, cell in ipairs(row)do
                cell:update(type)
                cell:view():establishBounds()
                cell:update(EControllerUpdate.ECUT_INCLUSION_IN_LINE)
            end
        end
        
    else
        assert(false)
    end
    
end

function ControllerGridEditor.cleanup(self)
    
    ControllerGrid.cleanup(self)
    
end


