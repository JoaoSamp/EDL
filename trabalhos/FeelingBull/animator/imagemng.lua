local ImageMng = {}

function ImageMng:new(fileName, quadsNumber, width, height)
	local imagemng = {}
	imagemng.quads = {}
	imagemng.image = love.graphics.newImage(fileName)
	imagemng.image:setFilter("nearest")
	imagemng.width = width
	imagemng.height = height
	for i = 0, quadsNumber, 1 do
		imagemng.quads[i] = love.graphics.newQuad(0, i*imagemng.height, imagemng.width, imagemng.height, imagemng.image:getDimensions())
	end

	return imagemng
end


return ImageMng