local Mode = {}
Mode.collisionTime = 2
	function Mode:new()
		local mode = {}
		mode.world = love.physics.newWorld(0, 0, false)
		mode.world:setCallbacks( beginContact, endContact, preSolve, postSolve )
		mode.lastCollision = Mode.collisionTime

		return mode
	end

return Mode