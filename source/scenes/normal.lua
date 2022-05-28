local normal = {}
tilesize = 16
d = 2 -- dot
p = 3 -- pellet

normal = {
	cameramoved = false,
	speed = 1,
	points = 0,
	lives = 3,
	time = 300,
	boundaries = {}
}

normal.data = {
	colors = {
		background = graphics.kColorBlack,
		sprite = graphics.kColorWhite,
		clear = graphics.kColorClear
	},
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
	pattern = {
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
		cell = {},
		position = {x = 0, y = 0},
		lastposition = {x = 0, y = 0},
		size = 1,
		direction = {x = 1, y = 0},
		input = {x = 0, y = 0},
		lives = 3,
		speed = 1,
		turnwindow = 3
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
		local spd = entity.speed * world.speed
		entity.position = {
			x = pos.x + dir.x * spd, 
			y = pos.y + dir.y * spd
		}
		entity.lastposition = pos
	end,
	wrapEntity = function(entity, world)
		local pos = entity.position
		local boundaries = world.boundaries
		if pos.x < boundaries[1].x then
			entity.position.x = boundaries[2].x
		elseif pos.x > boundaries[2].x then
			entity.position.x = boundaries[1].x
		elseif pos.y < boundaries[1].y then
			entity.position.y = boundaries[2].y
		elseif pos.y > boundaries[2].y then
			entity.position.y = boundaries[1].y
		end
	end,
	initializePacMan = function(pacman)

	end,
	centerCameraOnPacman = function(pacman)
		if pacman.lastposition.x == pacman.position.x then 
			return 
		end
		local target = pacman.position.x
		local translate = playdate.display.getOffset() - target + 200
		normal.cameramoved = true
		graphics.setDrawOffset(translate, 0)
	end,
	controlPacMan = function (pacman, world)
		local control = { 
			up = playdate.buttonIsPressed(playdate.kButtonUp),
			down = playdate.buttonIsPressed(playdate.kButtonDown),
			left = playdate.buttonIsPressed(playdate.kButtonLeft),
			right = playdate.buttonIsPressed(playdate.kButtonRight)
		}

		local input = pacman.input
		local direction = pacman.direction
		local turnposition = nil
		local nudge = {x = 0, y = 0}
		local position = pacman.position

		if control.up or control.down then
			input.x = 0
			if control.up then input.y = -1 elseif control.down then input.y = 1 end
			if direction.y == 1 or direction.y == -1 then direction.y = input.y end
		else
			input.y = 0
		end

		if control.left or control.right then
			input.y = 0
			if control.left then input.x = -1 elseif control.right then input.x = 1 end
			if direction.x == 1 or direction.x == -1 then direction.x = input.x end
		else
			input.x = 0
		end

		local futurepositions = {}
		for i=0, pacman.turnwindow do
			futurepositions[i] = { 
				x = position.x + tilesize / 2 + (i * pacman.speed * direction.x), 
				y = position.y + tilesize / 2 + (i * pacman.speed * direction.y)
			}

			if futurepositions[i].x % tilesize == 0 and futurepositions[i].y % tilesize == 0 
			and (input.x ~= 0 or input.y ~= 0) then
				turnposition = futurepositions[i]
				nudge.x = pacman.direction.x * i * math.abs(input.y)
				nudge.y = pacman.direction.y * i * math.abs(input.x)
				break
			end
		end

		if turnposition then
			local canturn = true
			local nexttile = { x = turnposition.x + (tilesize * input.x), y = turnposition.y + (tilesize * input.y) }
			for _, bound in pairs(world.entities.bounds) do
				local intersect = geometry.rect.fast_intersection(bound.x, bound.y, 1, 1, nexttile.x, nexttile.y, 1, 1)
				if intersect ~= 0 then
					canturn = false
					break
				end
			end
			if canturn == true then
				print("(" .. input.x .. ", " .. input.y .. ") : (" ..turnposition.x / tilesize .. ", " .. turnposition.y / tilesize .. ") -> (" .. nexttile.x / tilesize .. ", " .. nexttile.y / tilesize .. ")")
				pacman.position.x += nudge.x
				pacman.position.y += nudge.y
				pacman.direction = {x = pacman.input.x, y = pacman.input.y}
			end
		end

	end,
	initializeBounds = function(layout, world)
		world.systems.initializeMaze(layout, {x = 0, y = 0}, world)
		world.boundaries = {
			{x = 0, y = 0},
			{x = ((#layout[1] * 2) - 1) * tilesize, 
			y = #layout * tilesize}
		}
	end,
	initializeMaze = function(layout, position, world)
		local bounds = {}
		local rows = #world.data.base.layout
		local cols = #world.data.base.layout[1]
		for rowAt, row in pairs(layout) do
			for colAt, col in pairs(row) do
				if (col == 1) then
					table.insert(bounds, geometry.rect.new((colAt + position.x) * tilesize, (rowAt - 2 + position.y) * tilesize, tilesize, tilesize))
					table.insert(bounds, geometry.rect.new(((rows - colAt - position.x) + rows) * tilesize, (rowAt - 2 + position.y) * tilesize, tilesize, tilesize))
				end
			end
		end
		for _, entity in pairs(bounds) do
			table.insert(world.entities.bounds, entity)
		end
	end,
	drawBounds = function(bounds)
		graphics.setColor(normal.data.colors.sprite)
		__.each(bounds, graphics.fillRect)
		normal.cameramoved = false
	end,
	drawPacMan = function(pacman)
		local position = pacman.position
		local lastposition = pacman.lastposition
		graphics.setColor(normal.data.colors.sprite)
		graphics.fillCircleAtPoint(position.x, position.y, tilesize / 2)
	end
}

normal.start = function()
	graphics.setBackgroundColor(graphics.kColorBlack)
	normal.systems.initializeBounds(normal.data.base.layout, normal)
	normal.systems.initializeMaze(normal.data.pattern, {x = 2, y = 2}, normal)
	normal.entities.pacman.position = {x = tilesize * normal.data.spawn.x + (tilesize / 2), y = tilesize * normal.data.spawn.y - (tilesize / 2)}
	normal.systems.centerCameraOnPacman(normal.entities.pacman)
	normal.systems.drawBounds(normal.entities.bounds)
end

normal.update = function()
	normal.systems.controlPacMan(normal.entities.pacman, normal)
	normal.systems.moveEntity(normal.entities.pacman, normal)
	normal.systems.wrapEntity(normal.entities.pacman, normal)
	normal.systems.centerCameraOnPacman(normal.entities.pacman)
end


normal.draw = function()
	normal.systems.drawBounds(normal.entities.bounds)
	normal.systems.drawPacMan(normal.entities.pacman)
end

return normal