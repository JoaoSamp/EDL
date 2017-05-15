local char = require "chars/character"
local imagemng = require "animator/imagemng"
local kcfg = require "config/keyconfig"
local Player = {}

function Player:new(world, xWorld, yWorld, cQuad)
	local player = {}
	player.char = char:new(
		world, 
		xWorld, 
		yWorld, 
		24,	--widht
		32,	--height
		10,	--mass
		5,	--life
		9,	--speed
		2,	--attack
		"dynamic"	--type
	)
	player.cape = char:new(
		world, 
		xWorld+40, 
		yWorld, 
		20,	--widht
		24,	--height
		10,	--mass
		5,	--life
		10,	--speed
		2,	--attack
		"dynamic"	--type
	)
	player.arrow = 5
	player.gold = 0
	player.level = 0
	player.exp = 0
	player.cQuad = cQuad
	player.sprites = imagemng:new("sprites/player.png", 4, 32)
	player.hud = imagemng:new("sprites/heart.png", 2, 16)
	player.foward = true

	function player:move()
		local pVelX, pVelY
	    if love.keyboard.isDown(kcfg.kLeft)  then
	        pVelX = -1
	    elseif love.keyboard.isDown(kcfg.kRight)  then
	        pVelX = 1
	    else
	        pVelX = 0
	    end

	    if love.keyboard.isDown(kcfg.kUp)  then
	        pVelY = -1
	    elseif love.keyboard.isDown(kcfg.kDown)  then
	        pVelY = 1
	    else 
	        pVelY = 0
	    end


		local vectorX = player.char.body:getX() - player.cape.body:getX()
		local vectorY = player.char.body:getY() - player.cape.body:getY()
		local mod = math.sqrt((vectorX*vectorX) + (vectorY*vectorY))
		if mod > 60 then
			player.cape.speed = 200
			player.foward = true
		elseif mod > 45 then
			player.cape.speed = 40
			player.foward = true
		elseif mod < 35 then		
			player.cape.speed = 40
			player.foward = false
		end


		local angle = math.atan2(vectorY, vectorX)
		local xVelocity = player.cape.speed * math.cos(angle)
		local yVelocity = player.cape.speed * math.sin(angle)
		if player.foward then
			player.cape.body:setLinearVelocity(xVelocity, yVelocity)
		else
			player.cape.body:setLinearVelocity(-xVelocity, -yVelocity)
		end

		player.char.body:setLinearVelocity( player.char.speed * pVelX, player.char.speed * pVelY)
	end

	function player:getHit(damage)
		player.char.life = player.char.life-damage
		if player.char.life == 0 then
			player:die()
		end
	end

	function player:die()
		--player=nil
	end

	function player:draw()	
		love.graphics.draw(player.sprites.image, player1.sprites.quads[player.cQuad], player1.char.body:getX()-32, player1.char.body:getY()-32, 0, 2, 2)
		love.graphics.draw(player.sprites.image, player1.sprites.quads[4], player1.cape.body:getX()-32, player1.cape.body:getY()-32, 0, 2, 2)		
	end

	function player:drawHUD()
		for i = 1, player.char.lifeTotal ,1 do
			if i <= player.char.life then
				love.graphics.draw(player.hud.image, player.hud.quads[0], (18*i), 10, 0 , 2 ,2)
			else
				love.graphics.draw(player.hud.image, player.hud.quads[1], (18*i), 10, 0 , 2 ,2)
			end	
		end
	end

	return player
end

return Player