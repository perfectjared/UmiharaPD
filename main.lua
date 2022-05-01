local gfx <const> = playdate.graphics
import 'libraries/pdecs'

local play = import('source/scenes/play')
play.test()

function playdate.update()
	playdate.drawFPS(0,0)
end