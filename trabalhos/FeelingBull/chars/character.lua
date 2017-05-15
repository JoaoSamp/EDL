local Char = {}

function Char:new(world, xWorld, yWorld, width, height, mass, lifeTotal, speed, attack, type)
	local char = {}
	char.width = width
	char.height = height
	char.body = love.physics.newBody(world, xWorld, yWorld, type)
	char.body:setMass(mass)
	char.shape = love.physics.newRectangleShape(char.width, char.height)
	char.fixture = love.physics.newFixture(char.body, char.shape, mass)
	char.lifeTotal = lifeTotal
	char.life = lifeTotal
	char.speed = speed*10
	char.attack = attack
	return char
end

return Char
