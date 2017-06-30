local char = require "chars/character"
local imagemng = require "animator/imagemng"
local kcfg = require "config/keyconfig"
local chartype = require "config/chartype"
local gamestatus = require "config/gamestatus"
local Player = {}

-- Player Status --
Player.width = 12
Player.height = 16
Player.mass = 10
Player.life = 5
Player.speed = 10
Player.attack = 1
Player.type = "dynamic"
Player.collisionTime = 2

-- Cape Status --
Player.cape = {}
Player.cape.width = 10
Player.cape.height = 12
Player.cape.mass = 10
Player.cape.life = 0
Player.cape.speed = 15
Player.cape.attack = 1
Player.cape.type = "dynamic"
Player.cape.xPos = 20

function Player:new(world, xWorld, yWorld, pQuad, cQad, modifier)
	local player = {}
	player.char = char:new(
		world, 
		xWorld,
		yWorld, 
		Player.width,
		Player.height,
		Player.mass,
		Player.life,
		Player.speed,
		Player.attack,
		Player.type,
		modifier)

	player.cape = char:new(
		world, 
		xWorld + Player.cape.xPos * modifier,  
		yWorld, 
		Player.cape.width,
		Player.cape.height,
		Player.cape.mass,
		Player.cape.life,
		Player.cape.speed,
		Player.cape.attack,
		Player.cape.type,
		modifier)

	player.modifier = modifier
	player.quad = pQuad
	player.cape.quad = cQuad
	player.lastCollision = Player.collisionTime
	player.sprites = imagemng:new("sprites/player.png", 4, 32, 32)
	player.cape.sprites = imagemng:new("sprites/cape.png", 1, 32, 32)
	player.hud = imagemng:new("sprites/heart.png", 2, 16, 16)
	player.char.fixture:setUserData({player, chartype.playerChar})
	player.cape.fixture:setUserData({player, chartype.capeChar})

	function player:move()
		if player.char.alive then
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

			player.char.body:setLinearVelocity( player.char.speed * pVelX, player.char.speed * pVelY)
		else
			player.char.body:setLinearVelocity(0, 0)
		end
	end

	function player:capeMove()
		local vectorX = player.char.body:getX() - player.cape.body:getX()
		local vectorY = player.char.body:getY() - player.cape.body:getY()
		local mod = math.sqrt((vectorX*vectorX) + (vectorY*vectorY))
		if mod > (Player.cape.xPos * player.modifier) then -- distancia minima da capa
			local angle = math.atan2(vectorY, vectorX)
			local xVelocity = player.cape.speed * math.cos(angle)
			local yVelocity = player.cape.speed * math.sin(angle)
			player.cape.body:setLinearVelocity(xVelocity, yVelocity)
		else
			player.cape.body:setLinearVelocity(0, 0)
		end
	end

	function player:draw()
		local posX = player.char.body:getX()-((player.sprites.width/2)* modifier)
		local posY = player.char.body:getY()-((player.sprites.height/2)* modifier)
		local quady = player.sprites.quads[player.quad]
		love.graphics.draw(player.sprites.image, quady, posX, posY, 0, player.modifier, player.modifier)		
		
		posX = player.cape.body:getX()-((player.cape.sprites.width/2)* modifier)
		posY = player.cape.body:getY()-((player.cape.sprites.height/2)* modifier)
		quady = player.cape.sprites.quads[0]
		love.graphics.draw(player.cape.sprites.image, quady, posX, posY, 0, player.modifier, player.modifier)
	end

	function player:drawHUD()
		for i = 1, player.char.lifeTotal,1 do
			if i <= player.char.life then
				love.graphics.draw(player.hud.image, player.hud.quads[0], (((player.hud.width/2)+1)*player.modifier *i), (4*player.modifier), 0 , player.modifier ,player.modifier)
			else
				love.graphics.draw(player.hud.image, player.hud.quads[1], (((player.hud.height/2)+1)*player.modifier *i), (4*player.modifier), 0 , player.modifier ,player.modifier)
			end	
		end
	end

	function player:getHit(damage)
		if player.lastCollision <= 0 then
			player.lastCollision = Player.collisionTime
			if player.char.life > 0 then
				player.char.life = player.char.life-damage
			end
			if player.char.life <= 0 then
				player.char.alive = false
			end
		end
	end

	return player
end

return Player
