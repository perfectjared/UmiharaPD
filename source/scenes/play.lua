local play = {}

play.world = {
	size = 1,
	grav = -0.8,
	ground = 220,
}

play.entities = {
	player = {
		grounded = false,
		jump = 10,
		maxSpeed = 5,
		pos = { x = 200, y = 0 },
		rotator = {
			angle = 0,
			radius = 12,
			size = 2,
			vec = { x = 0, y = 0 }
		},
		size = 16,
		speed = 2,
		vel = { x = 0, y = 0, a = 0 }
	},
	rope = {
		segments = 5,
	},
	pins = {
		{ pos = { x = 400 / 5 * 1, y = 240 / 2 },
		size = 8 },
		{ pos = { x = 400 / 5 * 2.5, y = 240 / 2 },
		size = 8 },
		{ pos = { x = 400 / 5 * 4, y = 240 / 2 },
		size = 8 }
	}
}
		
play.systems = {
	playerControl = function(e, w)
		local x, y = 0
		if not playdate.isCrankDocked() then
			e.rotator.angle = playdate.getCrankPosition()
			e.rotator.vec.x = math.sin(math.rad(e.rotator.angle))
			e.rotator.vec.y = math.cos(math.rad(e.rotator.angle))
		end
		if playdate.buttonIsPressed(playdate.kButtonUp) then 
			e.vel.x = ( e.vel.x / 2 ) + e.jump * e.rotator.vec.x
			e.vel.y = ( e.vel.y / 2 ) + e.jump * e.rotator.vec.y
		end
		if playdate.buttonIsPressed(playdate.kButtonLeft) then 
			e.vel.x = math.max(e.vel.x - e.speed, -e.maxSpeed)			
		end
		if playdate.buttonIsPressed(playdate.kButtonRight) then 
			e.vel.x = math.min(e.vel.x + e.speed, e.maxSpeed)
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
		gfx.drawCircleAtPoint(e.pos.x, e.pos.y, e.size / 2)
	end,
	
	rotatorDraw = function(e)
		--gfx.drawCircleAtPoint(e.pos.x, e.pos.y, e.rotator.radius)
		if not playdate.isCrankDocked() then
			local x = e.pos.x + (e.rotator.radius * math.sin(math.rad(e.rotator.angle)))
			local y = e.pos.y - (e.rotator.radius * math.cos(math.rad(e.rotator.angle)))
			gfx.fillCircleAtPoint(x, y, e.rotator.size)
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
	
	__.each(play.entities.pins, play.systems.tileDraw)
end

return play