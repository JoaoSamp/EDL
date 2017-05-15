local char = require "chars/character"
local imagemng = require "animator/imagemng"
local Bull = {}
Bull.stopTime = 2
function Bull:new(world, xWorld, yWorld, cQuad)
	local bull = {}
	bull.char = char:new(
		world, 
		xWorld, 
		yWorld, 
		36,	--widht
		44,	--height
		100,	--mass
		4,	--life
		9,	--speed
		2,	--attack
		"static"	--type
	)
	bull.cQuad = cQuad
	bull.idleTime = Bull.stopTime
	bull.force = 400
	bull.sprites = imagemng:new("sprites/bull.png", 2, 32)

	function bull:move(dt, destX, destY)
		bull.idleTime = bull.idleTime - dt
		if bull.idleTime <= 0 then
			local xVelocity, yVelocity = bull.char.body:getLinearVelocity()
			
			if (xVelocity == 0 and yVelocity == 0) then				
				bull.char.body:setType("dynamic")
				local startX = bull.char.body:getX()			
				local startY = bull.char.body:getY()
				local angle = math.atan2((destY - startY), (destX - startX))
				xVelocity = bull.force * math.cos(angle)
				yVelocity = bull.force * math.sin(angle)
				bull.char.body:setLinearVelocity(xVelocity, yVelocity)

			elseif (bull.idleTime > -2) and (bull.idleTime < -1) then

				xVelocity = (xVelocity/2)
				yVelocity = (yVelocity/2)				
				bull.char.body:setLinearVelocity(xVelocity, yVelocity)

			elseif (bull.idleTime < -2) then				
				bull.char.body:setType("static")
				bull.idleTime = Bull.stopTime
				xVelocity = 0
				yVelocity = 0
				bull.char.body:setLinearVelocity(xVelocity, yVelocity)
			end
		end

	end	

	function bull:draw()	
		love.graphics.draw(bull.sprites.image, bull.sprites.quads[bull.cQuad], bull.char.body:getX()-32, bull.char.body:getY()-32, 0, 2, 2)
	end

	return bull
end


return Bull