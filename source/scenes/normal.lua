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
	layout = {
		boundaries = {
			matrix = {
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
			position = {x = 0, y = 0}
		
		},
		current = {
			matrix = {
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
				{1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0}
			},
			position = {x = 0, y = 0}
		},
		left = {matrix = {}, position = {x = 2, y = 2}},
		right = {matrix = {}, position = {x = 20, y = 2}},
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
	bounds = {
		base = {},
		left = {},
		right = {}
	},
	pacman = {
		circle = {},
		cell = {},
		position = {x = 0, y = 0},
		futurepositions = {},
		lastposition = {x = 0, y = 0},
		size = 1,
		direction = {x = -1, y = 0},
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
	mirrorMatrix = function(matrix)
		local mirror = {}

		for i = 1, #matrix do
			mirror[i] = {}
			for r = #matrix[i], 1, -1 do
				table.insert(mirror[i], matrix[i][r])
			end
		end
		for _, row in pairs(matrix) do
			local text = ""
			for ___, entry in pairs(row) do
				text = text .. entry .. " "
			end
		end
		for _, row in pairs(mirror) do
			local text = ""
			for ___, entry in pairs(row) do
				text = text .. entry .. " "
			end
		end
		return mirror
	end,
	mirrorPosition = function(position, world)
		local mirror = {x = 0, y =0} and {x = 0, y = 0} or {x = ((#world.data.boundaries.matrix[1] * 2) - 1) - 1, y = 0}
		return mirror
	end,
	mirrorLayout = function(layout, world)
		local mirrormtx = world.systems.mirrorMatrix(layout.matrix)
		local mirrorpos = world.systems.mirrorPosition(layout.position, world)
		return {matrix = mirrormtx, position = mirrorpos}
	end,
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
	movePacMan = function(pacman, world)
		world.systems.moveEntity(pacman, world)
		for i=0, pacman.turnwindow do
			pacman.futurepositions[i] = { 
				x = pacman.position.x + tilesize / 2 + (i * pacman.speed * pacman.direction.x), 
				y = pacman.position.y + tilesize / 2 + (i * pacman.speed * pacman.direction.y)
			}
		end
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

		for _, position in pairs(pacman.futurepositions) do
			if position.x % tilesize == 0 and position.y % tilesize == 0 
			and (input.x ~= 0 or input.y ~= 0) then
				turnposition = position
				nudge.x = pacman.direction.x * _ * math.abs(input.y)
				nudge.y = pacman.direction.y * _ * math.abs(input.x)
				break
			end
		end

		if turnposition then
			pacman.position.x += nudge.x
			pacman.position.y += nudge.y
			pacman.direction = {x = pacman.input.x, y = pacman.input.y}
		end
	end,
	initializeBoundaries = function(layout, world)
		world.boundaries = {
			{x = 0, y = 0},
			{x = ((#layout.matrix[1] * 2) - 1) * tilesize, 
			y = #layout.matrix * tilesize}
		}
		world.systems.initializeLayout(layout, world)
		world.systems.initializeLayout(world.systems.mirrorLayout(layout, world), world)
	end,
	addLayouts = function(l1, l2)
		print(l1.position.x, l1.position.y)
		print(l2.position.x, l2.position.y)
		local m3 = { layout = {}, position = 
			{x = math.min(l1.position.x, l2.position.y), 
			y = math.min(l1.position.y, l2.position.y)}}

		local rows = math.max(#l1.matrix, #l2.matrix)
		local cols = math.max(#l1.matrix[1], #l2.matrix[1])
	end,
	initializeLayout = function(layout, world)
		local bounds = {}
		local rows = #layout.matrix
		local cols = layout.matrix[1] ~= nil and #layout.matrix[1] or 0
		local pos = layout.position
		for rowAt, row in pairs(layout) do
			for colAt, col in pairs(row) do
				if (col == 1) then
					table.insert(bounds, geometry.rect.new((colAt + data.position.x) * tilesize, (rowAt - 2 + data.position.y) * tilesize, tilesize, tilesize))
				end
			end
		end
		for _, entity in pairs(bounds) do
			table.insert(world.entities.bounds, entity)
		end
		world.data.layout.current = world.systems.addLayouts(world.data.layout.current, layout)
	end,
	drawBounds = function(bounds)
		graphics.setColor(world.data.colors.sprite)
		__.each(bounds, graphics.fillRect)
		world.cameramoved = false
	end,
	drawPacMan = function(pacman, world)
		local position = pacman.position
		local lastposition = pacman.lastposition
		graphics.setColor(world.data.colors.sprite)
		graphics.fillCircleAtPoint(position.x, position.y, tilesize / 2)
	end
}

normal.start = function()
	graphics.setBackgroundColor(graphics.kColorBlack)
	normal.systems.initializeBoundaries(normal.data.layout.boundaries, normal)
	normal.systems.initializeLayout(normal.data.layout.current.layout, normal)
	normal.systems.initializeLayout(normal.systems.mirrorMatrix(normal.data.layout.current.layout), normal)
	normal.entities.pacman.position = {x = tilesize * normal.data.spawn.x + (tilesize / 2), y = tilesize * normal.data.spawn.y - (tilesize / 2)}
	normal.systems.centerCameraOnPacman(normal.entities.pacman)
end

normal.update = function()
	normal.systems.controlPacMan(normal.entities.pacman, normal)
	normal.systems.movePacMan(normal.entities.pacman, normal)
	normal.systems.wrapEntity(normal.entities.pacman, normal)
	normal.systems.centerCameraOnPacman(normal.entities.pacman)
end

normal.draw = function()
	normal.systems.drawBounds(normal.entities.bounds)
	normal.systems.drawPacMan(normal.entities.pacman)
end

return normal