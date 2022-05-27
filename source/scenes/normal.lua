local normal = {}
tilesize = 16
d = 2 -- dot
p = 3 -- pellet

normal = {
	changed = false,
	speed = 1,
	points = 0,
	lives = 3,
	time = 300
}

normal.data = {
	base = {		
		layout = {
			{0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0},
			{0,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0},
			{0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0},
			{0,1,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1},
			{0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0},
			{0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0},
			{0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
			{1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
			{0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1},
			{0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0},
			{0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0},
			{0,1,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1},
			{0,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0},
			{0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0},
		}
	},
	initial = {
		layout = {
			{1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0},
			{1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0},
			{1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0},
			{1, 1, 1, 1, 0, 1, 1, 1, 0, 1, d},
			{1, 1, 1, 1, 0, 0, 0, 0, 0, 1, d},
			{1, 1, 1, 1, 0, 1, 0, 1, 1, 1, d},
			{0, 0, 0, 0, 0, 1, 0, 1, d, p, 0},
			{1, 1, 1, 1, 0, 1, 0, 1, d, 1, d},
			{1, 1, 1, 1, 0, 0, 0, 0, d, 1, d},
			{1, 1, 1, 1, 0, 1, 1, 1, d, 1, d},
			{1, 1, 1, 1, 0, 0, 0, 1, d, d, d},
			{1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0},
			{1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0},
		}
	},
	itemlocation = {x = 13, y = 9},
	points = {
		dot = {10, 20, 30, 40, 50},
		pellet = 50,
		ghost = {400, 800, 1200, 1600, 2000, 2400, 2800, 3200}
	},
	spawn = {x = 17, y = 13},
}

normal.entities = {
	bounds = {},
	pacman = {
		circle = {},
		position = {x = 0, y = 0},
		lastposition = {x = 0, y = 0},
		size = 1,
		direction = {x = 1, y = 0},
		lives = 3,
		speed = 1
	},
	ghosts = {
		{}, {}, {}, {}
	},
	dots = {},
	pellets = {},
	items = {}
}
		
normal.systems = {
	moveEntity = function(entity, world)
		local pos = entity.position
		local dir = entity.direction
		local spd = entity.speed * normal.speed
		entity.position = {x = pos.x + dir.x * spd, y = pos.y + dir.y * spd}
		entity.lastposition = pos
	end,
	wrapEntity = function(entity, world)
		local pos = entity.position

	end,
	centerCamera = function()
		local pacman = normal.entities.pacman
		if pacman.lastposition.x == pacman.position.x then return end
		local target = normal.entities.pacman.position.x
		local translate = playdate.display.getOffset() - target + 200
		graphics.setDrawOffset(translate, 0)
	end,
	initializeBounds = function(layout, position)
		local bounds = {}
		for rowAt, row in pairs(layout) do
			for colAt, col in pairs(row) do
				if (col == 1) then
					table.insert(bounds, geometry.rect.new((colAt + position.x) * tilesize, (rowAt - 2 + position.y) * tilesize, tilesize, tilesize))
					table.insert(bounds, geometry.rect.new(((#row - colAt) + #row) * tilesize, (rowAt - 2 + position.y) * tilesize, tilesize, tilesize))
				end
			end
		end
		normal.entities.bounds = bounds
	end,
	drawBounds = function(bounds)
		__.each(bounds, graphics.drawRect)
	end,
	drawPacMan = function()
		local position = normal.entities.pacman.position
		graphics.fillCircleAtPoint(position.x, position.y, tilesize / 2)
	end
}

normal.start = function()
	normal.systems.initializeBounds(normal.data.base.layout, {x = 0, y = 0})
	normal.entities.pacman.position = {x = tilesize * normal.data.spawn.x + (tilesize / 2), y = tilesize * normal.data.spawn.y - (tilesize / 2)}
	normal.systems.centerCamera()
end

normal.draw = function()
	normal.systems.drawBounds(normal.entities.bounds)
	normal.systems.drawPacMan()
end

normal.update = function()
	--__.each(normal.entities, normal.systems.moveEntity)
	normal.systems.moveEntity(normal.entities.pacman, normal)
end


return normal