ManagerEditor = classWithSuper(ManagerGame, 'ManagerEditor')

function ManagerEditor.init(self, params)
    ManagerGame.init(self, params)
end

function ManagerEditor.registerCurrentState(self, currentState)
    ManagerGame.registerCurrentState(self, currentState)
    
    self:timerStop()
end



