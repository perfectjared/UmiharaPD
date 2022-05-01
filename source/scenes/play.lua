local play = {}

play.world = {
	size = 1,
	grav = -9.8,
	ground = 10,
}

play.entities = {
	player = {
		pos = { x = 200, y = 120 },
		rad = 8,
		vel = { x = 0, y = 0, a = 0 }
	}
}
		
play.systems = {
	gravityUpdate = function(e, w)
		if 240 - e.pos.y > w.ground then 
			e.vel.y += w.grav
		end
	end,
	velocityUpdate = function(e)
		e.pos.x += e.vel.x
		e.pos.y -= e.vel.y
	end,
	playerDraw = function (e)
		gfx.fillCircleAtPoint(e.pos.x, e.pos.y, e.rad)
	end,
	}
	
play.update = function ()
	play.systems.gravityUpdate(play.entities.player, play.world)
	play.systems.velocityUpdate(play.entities.player)
	play.systems.playerDraw(play.entities.player)
end

return play