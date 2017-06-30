local char = require "chars/character"
local imagemng = require "animator/imagemng"
local chartype = require "config/chartype"
local gamestatus = require "config/gamestatus"
local Bull = {}
Bull.stopTime = 2
Bull.collisionTime = 2


-- Bull Status --
Bull.width = 18
Bull.height = 22
Bull.mass = 100
Bull.life = 6
Bull.speed = 40
Bull.attack = 2
Bull.type = "dynamic"
Bull.collisionTime = 2

function Bull:new(world, xWorld, yWorld, quad, modifier, level)
	local bull = {}
	bull.char = char:new(
		world, 
		xWorld,
		yWorld, 
		Bull.width,
		Bull.height,
		Bull.mass,
		Bull.life,
		Bull.speed,
		Bull.attack,
		Bull.type,
		modifier)
	bull.level = level
	bull.modifier = modifier
	bull.quad = quad
	bull.idleTime = Bull.stopTime
	bull.lastCollision = Bull.collisionTime
	bull.sprites = imagemng:new("sprites/bull.png", 2, 32, 32)
	bull.hud = imagemng:new("sprites/energy.png", 3, 32, 32)
	bull.warning = imagemng:new("sprites/warning.png", 2, 32, 32)
	bull.warning.sign = 2
	bull.destX = 0
	bull.destY = 0
	bull.char.fixture:setUserData({bull, chartype.bullChar})

	function bull:move(dt, destX, destY)
		local xVelocity, yVelocity = bull.char.body:getLinearVelocity()
		if (xVelocity == 0) and (yVelocity == 0) then
			bull.char.body:setType("static")
		end
		if bull.char.alive then
			bull.idleTime = bull.idleTime - dt
			if bull.idleTime <= 0 then
				bull.destX = destX
				bull.destY = destY
				if bull.moveType < 3 then
					bull.normalAttack()
				elseif bull.moveType == 3 then
					bull.chaseAttack()
				end
			end
		else
			bull.char.body:setLinearVelocity(0,0)
		end
	end	

	function bull:draw()
		local posX = bull.char.body:getX()-((bull.sprites.width/2)* modifier)
		local posY = bull.char.body:getY()-((bull.sprites.height/2)* modifier)
		local quad = bull.sprites.quads[bull.quad]
		love.graphics.draw(bull.sprites.image, quad, posX, posY, 0, bull.modifier, bull.modifier)
		posY = posY - (16 * bull.modifier)
		--love.graphics.draw(bull.hud.image, bull.hud.quads[1], posX, 5, 0, 2, 2)
		love.graphics.draw(bull.hud.image, bull.hud.quads[1], posX, posY, 0, 2, 2)
		for i = 1, bull.char.lifeTotal - bull.char.life ,1 do
			love.graphics.draw(bull.hud.image, bull.hud.quads[2], posX- (8*(i-1)), posY, 0 , bull.modifier, bull.modifier)
		end			
		if ((bull.idleTime > 0) and (bull.warning.sign < 2)) then
			local posX = bull.char.body:getX()-((bull.sprites.width)* modifier)
			local posY = bull.char.body:getY()-((bull.sprites.height)* modifier)
			love.graphics.draw(bull.warning.image, bull.warning.quads[bull.warning.sign], posX, posY, 0, bull.modifier, bull.modifier)
		else
			bull.warning.sign = 2
		end
	end

	function bull:normalAttack()
		local xVelocity, yVelocity = bull.char.body:getLinearVelocity()
		if (xVelocity == 0 and yVelocity == 0) then				
			bull.char.body:setType("dynamic")
			local startX = bull.char.body:getX()			
			local startY = bull.char.body:getY()
			local angle = math.atan2((bull.destY - startY), (bull.destX - startX))
			xVelocity = bull.char.speed * math.cos(angle)
			yVelocity = bull.char.speed * math.sin(angle)
			bull.char.body:setLinearVelocity(xVelocity, yVelocity)

		elseif (bull.idleTime > -1.5) and (bull.idleTime < -1) then

			xVelocity = (xVelocity/2)
			yVelocity = (yVelocity/2)				
			bull.char.body:setLinearVelocity(xVelocity, yVelocity)

		elseif (bull.idleTime < -1.5) then				
			bull.char.body:setType("static")
			if bull.moveType == 1 then
				bull.idleTime = Bull.stopTime
			else
				bull.idleTime = .3
			end
			xVelocity = 0
			yVelocity = 0
			bull.char.body:setLinearVelocity(xVelocity, yVelocity)
			coroutine.resume(bull.nextMove)
		end
	end

	function bull:chaseAttack()
		local xVelocity, yVelocity = bull.char.body:getLinearVelocity()

		if (bull.idleTime > -1) then				
			bull.char.body:setType("dynamic")
			local startX = bull.char.body:getX()			
			local startY = bull.char.body:getY()
			local angle = math.atan2((bull.destY - startY), (bull.destX - startX))
			xVelocity = bull.char.speed * math.cos(angle)
			yVelocity = bull.char.speed * math.sin(angle)
			bull.char.body:setLinearVelocity(xVelocity, yVelocity)

		elseif (bull.idleTime > -1.5) and (bull.idleTime < -1) then

			xVelocity = (xVelocity/2)
			yVelocity = (yVelocity/2)				
			bull.char.body:setLinearVelocity(xVelocity, yVelocity)

		elseif (bull.idleTime < -1.5) then
			bull.char.body:setType("static")
			bull.idleTime = Bull.stopTime
			xVelocity = 0
			yVelocity = 0
			bull.char.body:setLinearVelocity(xVelocity, yVelocity)
			coroutine.resume(bull.nextMove)
		end
	end
	
	bull.nextMove = coroutine.create(function ()
		while bull.char.alive do
			if bull.level < 3 then
				for i = 0, 2, 1 do
					bull.moveType = 1
					coroutine.yield()
				end
				if bull.level >= 2 then
					bull.warning.sign = 0
					for i = 0, 1, 1 do
						bull.moveType = 2
						coroutine.yield()
					end
				end
			else
				for i = 0, 3, 1 do
					bull.moveType = i % 2
					coroutine.yield()
				end
				bull.warning.sign = 1
				bull.moveType = 3
				coroutine.yield()
			end
		end		
	end)
	coroutine.resume(bull.nextMove)

	function bull:getHit(damage)
		if bull.lastCollision <= 0 then
			bull.lastCollision = Bull.collisionTime
			if bull.char.life > 0 then
				bull.char.life = bull.char.life-damage
			end
			if bull.char.life <= 0 then
				bull.char.alive = false
			end
		end
	end
	function bull:stop()
		bull.idleTime = Bull.stopTime
		bull.char.body:setLinearVelocity(0,0)
	end

	return bull
end


return Bull