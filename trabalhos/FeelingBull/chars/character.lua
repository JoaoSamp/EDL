local Char = {}

function Char:new(world, xWorld, yWorld, width, height, mass, lifeTotal, speed, attack, type, modifier)
	local char = {}
	char.width = width * modifier
	char.height = height * modifier
	char.body = love.physics.newBody(world, xWorld * modifier, yWorld * modifier, type)
	char.body:setMass(mass * modifier)
	char.shape = love.physics.newRectangleShape(char.width, char.height)
	char.fixture = love.physics.newFixture(char.body, char.shape, mass)
	char.lifeTotal = lifeTotal
	char.life = lifeTotal
	char.speed = speed*10
	char.attack = attack	
	char.alive = true

	return char
end

return Char
