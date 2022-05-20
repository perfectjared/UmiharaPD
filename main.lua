import 'CoreLibs/graphics'
gfx = playdate.graphics

import 'CoreLibs/timer'
timer = playdate.timer

__ =
import 'libraries/underscore'

ECS = 
import 'libraries/ECS'

Component, System, Query = ECS.Component, ECS.System, ECS.Query

C =
import 'source/components'

S =
import 'source/systems'

local play = import('source/scenes/play')

function playdate.update()
	gfx.clear()
	playdate.drawFPS(0,0)
	play.update()
end