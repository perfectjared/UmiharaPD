local gfx <const> = playdate.graphics
local play = {}

play.world = {
	size = 1,
	grav = -1.5,
	ground = 220,
}

play.entities = {
	player = {
		grounded = false,
		jump = 15,
		maxSpeed = 10,
		pos = { x = 200, y = 120 },
		rotator = {
			angle = 0,
			radius = 8,
		},
		size = 8,
		speed = 3,
		vel = { x = 0, y = 0, a = 0 }
	},
	rope = {
		segments = 5,
		
	},
	tiles = {
		{ pos = {x = 400 / 5 * 1, y = 240 / 2},
		size = 32},
		{ pos = {x = 400 / 5 * 4, y = 240 / 2},
		size = 32}
	}
}
		
play.systems = {
	playerControl = function(e, w)
		if e.grounded then
			if playdate.buttonIsPressed(playdate.kButtonUp) then 
				e.vel.y += e.jump
			end
			if playdate.buttonIsPressed(playdate.kButtonLeft) then 
				e.vel.x = math.max(e.vel.x - e.speed, -e.maxSpeed)			
			end
			if playdate.buttonIsPressed(playdate.kButtonRight) then 
				e.vel.x = math.min(e.vel.x + e.speed, e.maxSpeed)
			end
		end
		if not playdate.isCrankDocked() then
			e.rotator.angle = playdate.getCrankPosition()
		end
	end,
	playerMovement = function(e, w)
		if e.grounded 
		and not playdate.buttonIsPressed(playdate.kButtonLeft) 
		and not playdate.buttonIsPressed(playdate.kButtonRight) then
			if math.abs(e.vel.x) > 0.1 then e.vel.x /= 1.5 else e.vel.x = 0 end
		end
	end,
	gravityUpdate = function(e, w)
		if not e.grounded  then 
			e.vel.y += w.grav
		end
	end,
	velocityUpdate = function(e, w)
		e.pos.x += e.vel.x
		e.pos.y = math.min(e.pos.y - e.vel.y, w.ground - (e.size / 2))
	end,
	worldWrap = function(e)
		local halfSize = e.size / 2
		if e.pos.x > 400 + halfSize then e.pos.x = 0 - halfSize end
		if e.pos.x < 0 - halfSize then e.pos.x = 400 + halfSize end
	end,
	playerDraw = function(e)
		gfx.fillCircleAtPoint(e.pos.x, e.pos.y, e.size / 2)
	end,
	rotatorDraw = function(e)
		gfx.drawCircleAtPoint(e.pos.x, e.pos.y, e.rotator.radius)
		if not playdate.isCrankDocked() then
			gfx.fillCircleAtPoint((e.pos.x + (e.rotator.radius * math.sin(math.rad(e.rotator.angle)))),(e.pos.y - (e.rotator.radius * math.cos(math.rad(e.rotator.angle)))), 2)
		end
	end,
	tileDraw = function(e)
		gfx.fillCircleAtPoint(e.pos.x, e.pos.y, e.size / 2)
	end,
	groundDraw = function(w)
		gfx.drawLine(0, w.ground, 400, w.ground)
	end,
	setGrounded = function(e, w)
		if e.pos.y >= (w.ground - (e.size / 2)) then
			e.grounded = true
			e.vel.y = 0
		else 
			e.grounded = false
		end
	end
}
	
play.update = function()
	play.systems.setGrounded(play.entities.player, play.world)
	play.systems.playerControl(play.entities.player)
	play.systems.playerMovement(play.entities.player)
	play.systems.gravityUpdate(play.entities.player, play.world)
	play.systems.velocityUpdate(play.entities.player, play.world)
	play.systems.worldWrap(play.entities.player)
	
	play.draw()
end

play.draw = function()
	play.systems.groundDraw(play.world)
	play.systems.playerDraw(play.entities.player)
	play.systems.rotatorDraw(play.entities.player)
	
	__.each(play.entities.tiles, play.systems.tileDraw)
end

return play