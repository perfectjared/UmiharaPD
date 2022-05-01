__ =
import 'libraries/underscore'

local play = import('source/scenes/play')
play.update()

function playdate.update()
	playdate.drawFPS(0,0)
end