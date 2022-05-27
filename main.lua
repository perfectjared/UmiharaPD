--by perfect_jared

--libs & globals
import 'CoreLibs/graphics'
graphics = playdate.graphics

import 'Corelibs/sprites'
geometry = playdate.geometry

import 'CoreLibs/timer'
timer = playdate.timer

__ =
import 'libraries/underscore'

ECS = 
import 'libraries/ECS'

Component, System, Query = ECS.Component, ECS.System, ECS.Query

Components =
import 'source/components'

Systems =
import 'source/systems'

--scenes
local menu = nil
local attract = nil
local normal = import('source/scenes/normal')
local extra = nil
local options = nil
local results = nil

--setup
playdate.display.setRefreshRate(50)
local lastScene = nil
local currentScene = nil
local nextScene = normal

local changeScene = function()
	lastScene = currentScene
	currentScene = nextScene
	nextScene = nil
	currentScene.start()
end

changeScene()

function playdate.update()
	--gfx.clear()
	playdate.drawFPS(0,0)
	currentScene.update()
	currentScene.draw()
	if nextScene then
		changeScene()
	end
end