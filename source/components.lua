local Components = {}

local body = Component({
	acceleration = {
		x = 0, y = 0
	},
	fixed = false,
	velocity = {
		x = 0, y = 0
	},
})

local circle = Component({
	radius = 0
})

local player = Component({
	
})

local position = Component({
	x = 0, y = 0, z = 0
})

return Components