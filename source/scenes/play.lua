import 'CoreLibs/graphics'
local gfx <const> = playdate.graphics

local play = {}

play.entities = {
	player = {
		pos = { x = 100, y = 100 },
		rad = 8,
		vel = { x = 0, y = 0, a = 0 }
	}
	}
		
play.systems = {
	playerDraw = function (e)
		gfx.drawCircleAtPoint(e.pos.x, e.pos.y, e.rad)
	end
	}
	
play.update = function ()
	play.systems.playerDraw(play.entities.player)
end

return play