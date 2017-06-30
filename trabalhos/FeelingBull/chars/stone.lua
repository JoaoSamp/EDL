local char = require "chars/character"
local imagemng = require "animator/imagemng"
local kcfg = require "config/keyconfig"
local chartype = require "config/chartype"
local gamestatus = require "config/gamestatus"
local Stone = {}

-- Player Status --
width = 12
height = 10
mass = 10
life = 5
speed = 10
attack = 1
ptype = "static"
collisionTime = 2

function Stone:new(world, xWorld, yWorld, pQuad, modifier, position)
	local stone = {}
	stone.char = char:new(
		world, 
		xWorld,
		yWorld, 
		width,
		height,
		mass,
		life,
		speed,
		attack,
		ptype,
		modifier)
	stone.modifier = modifier
	stone.quad = pQuad
	stone.sprites = imagemng:new("sprites/stone.png", 1, 16, 16)
	stone.char.fixture:setUserData({stone, chartype.stoneChar})
	stone.position = position

	function stone:draw()
		local posX = stone.char.body:getX()-((stone.sprites.width/2)* modifier)
		local posY = stone.char.body:getY()-((stone.sprites.height/2)* modifier)
		local quady = stone.sprites.quads[stone.quad]
		love.graphics.draw(stone.sprites.image, quady, posX, posY, 0, stone.modifier, stone.modifier)
	end

	function stone:destroy(stones)
		if stone.position > 0 then
			for i, s in ipairs(stones) do
				if s.position > stone.position then
					s.position = s.position - 1
				end
			end
			stone.char.fixture:destroy()
			table.remove(stones, stone.position)
			stone.position = 0
		end
	end

	return stone
end

return Stone
