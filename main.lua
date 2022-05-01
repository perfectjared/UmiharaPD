import 'CoreLibs/graphics'
local gfx <const> = playdate.graphics

__ =
import 'libraries/underscore'

local play = import('source/scenes/play')

function playdate.update()
	playdate.drawFPS(0,0)
	play.update()
	gfx.clear()
end