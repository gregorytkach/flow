require('game_flow.src.states.editor.StateEditor')

local state = StateEditor:new()

GameInfo:instance():managerStates():onCurrentStateCreated(state);

return state:sceneStoryboard()