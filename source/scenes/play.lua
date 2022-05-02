local gfx <const> = playdate.graphics
local play = {}

play.world = {
	size = 1,
	grav = -9.8,
	ground = 220,
}

play.entities = {
	player = {
		grounded = false,
		pos = { x = 200, y = 120 },
		size = 16,
		speed = 5,
		state = "",
		states = {
			
		},
		vel = { x = 0, y = 0, a = 0 }
	}
}
		
play.systems = {
	playerMove = function(e, w)
		if e.grounded then
			if playdate.buttonIsPressed(playdate.kButtonUp) then
			end
			if playdate.buttonIsPressed(playdate.kButtonLeft) then
				e.vel.x -= e.speed
			end
			if playdate.buttonIsPressed(playdate.kButtonRight) then
				e.vel.x += e.speed
			end
		else
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
	playerDraw = function(e)
		gfx.fillCircleAtPoint(e.pos.x, e.pos.y, e.size / 2)
	end,
	groundDraw = function(w)
		gfx.drawLine(0, w.ground, 400, w.ground)
	end,
	setGrounded = function(e, w)
		if e.pos.y < (w.ground - (e.size / 2)) then
			e.grounded = false
		else 
			e.grounded = true 
		end
	end
}
	
play.update = function ()
	play.systems.groundDraw(play.world)
	play.systems.setGrounded(play.entities.player, play.world)
	play.systems.gravityUpdate(play.entities.player, play.world)
	play.systems.playerMove(play.entities.player)
	play.systems.velocityUpdate(play.entities.player, play.world)
	play.systems.playerDraw(play.entities.player)
end

return play