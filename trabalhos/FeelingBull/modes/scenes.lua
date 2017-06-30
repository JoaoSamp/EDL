local player = require "chars/player"
local bull = require "chars/bull"
local stone = require "chars/stone"
local imagemng = require "animator/imagemng"
local char = require "chars/character"
local chartype = require "config/chartype"
local Scene = {}

	function Scene:new(modifier)
		local scene = {}
		scene.modifier = modifier
		scene.world = love.physics.newWorld(0, 0, false)
		scene.world:setCallbacks( beginContact, endContact, preSolve, postSolve )		
		scene.scenario = imagemng:new("sprites/scene.png", 1, 400, 300)
		
		function scene:start(level)	
			scene:createWalls()
			scene.player = player:new(scene.world, 200, 200, 2, 0, scene.modifier)
			scene.bulls = {}
			if level == 1 then
				table.insert(scene.bulls, bull:new(scene.world, 200, 100, 0, scene.modifier, level))
			elseif level == 2 then
				table.insert(scene.bulls, bull:new(scene.world, 200, 100, 1, scene.modifier, level))
			elseif level == 3 then
				table.insert(scene.bulls, bull:new(scene.world, 200, 100, 2, scene.modifier, level))
			elseif level == 4 then
				table.insert(scene.bulls, bull:new(scene.world, 150, 100, 2, scene.modifier, level-1))
				table.insert(scene.bulls, bull:new(scene.world, 250, 100, 1, scene.modifier, level - 2))
			elseif level == 5 then
				table.insert(scene.bulls, bull:new(scene.world, 200/2, 100/2, 2, scene.modifier+2, level))
			end

			scene.stones = {}
			local posX, posY
			local stns = love.math.random( 4, 12 )
			for i = 0, stns, 1 do
				local mod = i % 4
				if ( mod == 0) then
					posX = love.math.random( 75, 150 )
					posY = love.math.random( 60, 120 )
				elseif ( mod == 1) then
					posX = love.math.random( 250, 325 )
					posY = love.math.random( 60, 120 )
				elseif ( mod == 2) then
					posX = love.math.random( 75, 150 )
					posY = love.math.random( 180, 240 )
				elseif ( mod == 3) then
					posX = love.math.random( 250, 325 )
					posY = love.math.random( 180, 240 )
				end
				table.insert(scene.stones, stone:new(scene.world, posX, posY, 0, scene.modifier, i+1))
			end
		end

		function scene:update(dt)
			scene.player:move()
			scene.player:capeMove()
			if scene.player.lastCollision > 0 then
		    	scene.player.lastCollision = scene.player.lastCollision - dt
		    end
			
			for i, b in ipairs(scene.bulls) do
		    	b:move(dt, scene.player.char.body:getX(), scene.player.char.body:getY())
		    	if b.lastCollision > 0 then
		    		b.lastCollision = b.lastCollision - dt
		    	end
		   	end
			scene.world:update(dt)
		end


		function scene:draw()	
			love.graphics.draw(scene.scenario.image, 0, 0, 0, scene.modifier, scene.modifier)	
			for i, s in ipairs(scene.stones) do
				s:draw()
			end
			scene.player.drawHUD()
			scene.player.draw()		
			for i, b in ipairs(scene.bulls) do
				b:draw()
			end
		end

		function scene:createWalls()
			scene.walls = {}

			table.insert(scene.walls, char:new(
						scene.world, 
						24,
						150,
						48,
						300,
						100,
						0,
						0,
						0,
						'static',
						scene.modifier)
			)

			table.insert(scene.walls, char:new(
						scene.world, 
						200,
						15, 
						304,
						60,
						100,
						0,
						0,
						0,
						'static',
						scene.modifier)
			)

			table.insert(scene.walls, char:new(
						scene.world, 
						376,
						150, 
						48,
						300,
						100,
						0,
						0,
						0,
						'static',
						scene.modifier)
			)

			table.insert(scene.walls, char:new(
						scene.world, 
						200,
						285, 
						304,
						60,
						100,
						0,
						0,
						0,
						'static',
						scene.modifier)
			)

			for i, w in ipairs(scene.walls) do
				w.fixture:setUserData({scene, chartype.wallChar})
			end
		end

		return scene
	end

return Scene
