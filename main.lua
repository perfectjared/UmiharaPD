local gfx = playdate.graphics

import "libraries/fsm"
local gameState = M:create({
	initial = "title",
	events = {
		{name = "start", from = "title", to = "game"}
	},
	callbacks = {
	on_game = function(self) print("test") end,
	}
})

function playdate.update()
	playdate.drawFPS(0,0)
end