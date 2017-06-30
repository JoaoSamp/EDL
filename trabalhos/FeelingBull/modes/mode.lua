local scene = require "modes/scenes"
local imagemng = require "animator/imagemng"
local gamestatus = require "config/gamestatus"
local chartype = require "config/chartype"
local Mode = {}

function Mode:new()
	local mode = {}

	love.graphics.setBackgroundColor( 0,153,153)	
	mode.status = gamestatus.mainMenu
	mode.selected = 1
	mode.maxItem = {2, 3, 2, 2}
	mode.modifier = 2
	mode.level = 1
	mode.menu = imagemng:new("sprites/menu.png", 9, 192, 16)
	mode.menu.sel = imagemng:new("sprites/menusel.png", 1, 16, 16)
	mode.menu.backgrd = imagemng:new("sprites/background.png", 4, 512, 512)
	mode.menu.posX = 0	
	mode.menu.posY = 0
	mode.drawTime = 0


	function mode:changeStatus(status)
		mode.status = status
		mode.selected = 1
	end

	function mode:draw(dt)
		if mode.status == gamestatus.gameRun then
			mode.scene:draw()
		elseif mode.status == gamestatus.mainMenu then
			mode:drawBackground(dt)
			mode:drawMainMenu()
		elseif mode.status == gamestatus.gameMenu then
			mode:drawBackground(dt)
			mode:drawGameMenu()
		elseif mode.status == gamestatus.gameOver then
			mode.scene:draw()
			mode:drawGameOver()
		elseif mode.status == gamestatus.gameWin then
			mode.scene:draw()
			mode:drawWin()
		end
	end


	function mode:confirmMenu()
		if mode.status == gamestatus.mainMenu then		-- Main Menu
			if mode.selected == 1 then
				mode:startGame(false)
			elseif mode.selected == 2 then
				mode:quitGame()
			end

		elseif mode.status == gamestatus.gameMenu then		-- Game Menu
			if mode.selected == 1 then
				mode:resumeGame()
			elseif mode.selected == 2 then
				mode:mainMenu()
			elseif mode.selected == 3 then
				mode:quitGame()
			end
		elseif mode.status == gamestatus.gameWin then		-- Game Win
			if mode.selected == 1 then
				mode:startGame(true)
			elseif mode.selected == 2 then					
				mode:quitGame()
			end
		elseif mode.status == gamestatus.gameOver then		-- Game Over
			if mode.selected == 1 then
				mode:startGame(false)
			elseif mode.selected == 2 then					
				mode:quitGame()
			end
		elseif mode.status == gamestatus.gameMenu then		-- Win
			mode:mainMenu()
		end
	end

	function mode:startGame(nextLevel)		
		if (mode.level < 5)  and nextLevel then
			mode.level = mode.level+1
		end
		mode.scene = scene:new(mode.modifier)
		mode.scene:start(mode.level)
		mode:changeStatus(gamestatus.gameRun)
	end	

	function mode:mainMenu()
		mode.scene = nil
		mode:changeStatus(gamestatus.mainMenu)
	end

	function mode:resumeGame()
		mode:changeStatus(gamestatus.gameRun)
		--comentario
	end

	function mode:quitGame()
		love.event.quit()
		--comentario
	end

	function mode:drawMainMenu()
		local posX =  400 - (576/2)		
		local posY =  50
		love.graphics.draw(mode.menu.image, mode.menu.quads[0], posX, posY, 0,3,3)		
		posX =  400 - (192/2)
		posY =  300
		love.graphics.draw(mode.menu.image, mode.menu.quads[1], posX, posY, 0,2,2)
		posY =  350
		love.graphics.draw(mode.menu.image, mode.menu.quads[4], posX, posY, 0,2,2)
		posX = posX - 32
		if mode.selected == 1 then
			posY =  300
		end
		love.graphics.draw(mode.menu.sel.image, mode.menu.sel.quads[0], posX, posY, 0,2,2)
	end

	function mode:drawGameMenu()
		local posX =  400 - (576/2)		
		local posY =  50
		love.graphics.draw(mode.menu.image, mode.menu.quads[0], posX, posY, 0,3,3)		
		posX =  400 - (192/2)
		posY =  300
		love.graphics.draw(mode.menu.image, mode.menu.quads[3], posX, posY, 0,2,2)
		posY =  350
		love.graphics.draw(mode.menu.image, mode.menu.quads[2], posX, posY, 0,2,2)		
		posY =  400
		love.graphics.draw(mode.menu.image, mode.menu.quads[4], posX, posY, 0,2,2)
		posX = posX - 32
		if mode.selected == 1 then
			posY =  300
		elseif mode.selected == 2 then
			posY = 350
		end
		love.graphics.draw(mode.menu.sel.image, mode.menu.sel.quads[0], posX, posY, 0,2,2)
	end	

	function mode:drawGameOver()
		local posX =  400 - (432/2)		
		local posY =  50
		love.graphics.draw(mode.menu.image, mode.menu.quads[7], posX, posY, 0,3,3)	
		posX =  400 - (192/2)
		posY =  300
		love.graphics.draw(mode.menu.image, mode.menu.quads[5], posX, posY, 0,2,2)
		posY =  350
		love.graphics.draw(mode.menu.image, mode.menu.quads[4], posX, posY, 0,2,2)
		posX = posX - 32
		if mode.selected == 1 then
			posY =  300
		end
		love.graphics.draw(mode.menu.sel.image, mode.menu.sel.quads[0], posX, posY, 0,2,2)
	end	

	function mode:drawWin()
		local posX =  400 - (336/2)		
		local posY =  50
		love.graphics.draw(mode.menu.image, mode.menu.quads[6], posX, posY, 0,3,3)	
		posX =  400 - (192/2)
		posY =  300
		love.graphics.draw(mode.menu.image, mode.menu.quads[8], posX, posY, 0,2,2)
		posY =  350
		love.graphics.draw(mode.menu.image, mode.menu.quads[4], posX, posY, 0,2,2)
		posX = posX - 32
		if mode.selected == 1 then
			posY =  300
		end
		love.graphics.draw(mode.menu.sel.image, mode.menu.sel.quads[0], posX, posY, 0,2,2)
	end		


	function beginContact(a, b, coll)
		local data1 = a:getUserData()
		local data2 = b:getUserData()
		local char1, type1 = data1[1],  data1[2]
		local char2, type2 = data2[1],  data2[2]
		local bVelX, bVelY = 0, 0
		local deadBulls

		if (type1 == chartype.bullChar) then
			bVelX, bVelY = char1.char.body:getLinearVelocity()
			if type2 == chartype.capeChar then
				if (bVelX ~= 0 or bVelY ~= 0)then
					char1:getHit(char2.char.attack)
				end
			elseif type2 == chartype.playerChar then
				if (bVelX ~= 0 or bVelY ~= 0) then
					char2:getHit(char1.char.attack)
				end
			elseif type2 == chartype.stoneChar then
				if (bVelX ~= 0 or bVelY ~= 0) then
					char2:destroy(mode.scene.stones)
					char1:stop()
				end
			end
		elseif ((type1 == chartype.capeChar) and (type2 == chartype.bullChar)) then
				bVelX, bVelY = char2.char.body:getLinearVelocity()
				if (bVelX ~= 0 or bVelY ~= 0) then
					char2:getHit(char1.char.attack)
				end
		elseif ((type1 == chartype.playerChar) and (type2 == chartype.bullChar)) then
				bVelX, bVelY = char2.char.body:getLinearVelocity()
				if (bVelX ~= 0 or bVelY ~= 0) then
					char1:getHit(char2.char.attack)
				end
		end


		if mode.scene.player.char.alive == false then
			mode:changeStatus(gamestatus.gameOver)
		else
			for i, v in ipairs(mode.scene.bulls) do
				deadBulls = v.char.alive
			end
			if deadBulls == false then			
				mode:changeStatus(gamestatus.gameWin)
			end
		end
	end

	function mode:drawBackground(dt)
		local pt = dt
		mode.drawTime = (mode.drawTime+pt)
		if mode.drawTime >= .8 then
			mode.drawTime = 0
			if mode.menu.posX <= -64 then
				mode.menu.posX = 0
				mode.menu.posY = 0
			end
		end
		mode.menu.posX = mode.menu.posX - (20*dt)
		mode.menu.posY = mode.menu.posY - (20*dt)
		love.graphics.draw(mode.menu.backgrd.image, mode.menu.backgrd.quads[math.floor(mode.drawTime / .2)], mode.menu.posX, mode.menu.posY, 0,2,2)		
	end

	return mode
end


return Mode