local normal = {}
d = 2 -- dot
p = 3 -- pellet

normal.world = {
	changed = false,
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
		},
		bounds = {}
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
	items = { },
	itemlocation = {x = 13, y = 9},
	lives = 3,
	points = {
		dot = {10, 20, 30, 40, 50},
		pellet = 50,
		ghost = {400, 800, 1200, 1600, 2000, 2400, 2800, 3200}
	},
	spawn = {x = 17, y = 14},
	tilesize = 16,
	time = 300,
}

normal.entities = {
	camera = nil,
	pacman = nil,
	ghosts = {
		nil,
		nil,
		nil,
		nil
	}
}
		
normal.systems = {
	initializeBounds = function(layout, position)
		local tilesize = normal.world.tilesize
		local bounds = {}
		for rowAt, row in pairs(layout) do
			for colAt, col in pairs(row) do
				if (col == 1) then
					table.insert(bounds, geometry.rect.new((colAt + position.x) * tilesize, (rowAt - 2+ position.y) * tilesize, tilesize, tilesize))
					table.insert(bounds, geometry.rect.new(((#row - colAt) + #row) * tilesize, (rowAt - 2 + position.y) * tilesize, tilesize, tilesize))
				end
			end
		end
		return bounds
	end,
	drawBounds = function(bounds)
		local tilesize = normal.world.tilesize
		__.each(bounds, graphics.fillRect)
	end
}

normal.start = function()
	--playdate.display.setOffset(normal.world.spawn.x * normal.world.tilesize, 0)
	normal.world.base.bounds = normal.systems.initializeBounds(normal.world.base.layout, {x = 0, y = 0})
end

normal.draw = function()
	normal.systems.drawBounds(normal.world.base.bounds)
end

normal.update = function()
end


return normal