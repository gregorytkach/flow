require('game_flow.src.states.game.StateEditor')

local state = StateEditor:new()

GameInfo:instance():managerStates():onCurrentStateCreated(state);

return state:sceneStoryboard()