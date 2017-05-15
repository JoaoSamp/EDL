local player = require "chars/player"
local bull = require "chars/bull"
local mode = require "modes/mode"
local kcfg = require "config/keyconfig"
local deltatime

function love.load()
	mode1 = mode:new()
	bull1 = bull:new(mode1.world, 200, 200, math.random(2)-1)
	player1 = player:new(mode1.world, 300, 300 , math.random(4)-1)
end

function love.update(dt)
	--mode1:checkColission(player1, bull1, dt)
	player1:move()
    bull1:move(dt, player1.char.body:getX(), player1.char.body:getY())
    if mode1.lastCollision > 0 then
    	mode1.lastCollision = mode1.lastCollision - dt
    else 
    	mode1.lastCollision = 0
    end
	mode1.world:update(dt)
end

function beginContact(a, b, coll)
	local bVelX, bVelY = bull1.char.body:getLinearVelocity()
	if (mode1.lastCollision <= 0) and (bVelX ~= 0 or bVelY ~= 0) and ((a == player1.char.fixture and b == bull1.char.fixture) or (a == bull1.char.fixture and b == player1.char.fixture)) then
		mode1.lastCollision = mode.collisionTime
		player1:getHit(bull1.char.attack)
	end
end

function endContact(a, b, coll)
end

function love.draw()
	player1:draw()
	player1:drawHUD()
	bull1:draw()
		local vectorX = player1.char.body:getX() - player1.cape.body:getX()
		local vectorY = player1.char.body:getY() - player1.cape.body:getY()
		local mod = math.sqrt((vectorX*vectorX) + (vectorY*vectorY))
		love.graphics.print(mod,10, 400)

end
