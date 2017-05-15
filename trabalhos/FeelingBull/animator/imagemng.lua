local ImageMng = {}

function ImageMng:new(fileName, quadsNumber, tamanho)
	local imagemng = {}
	imagemng.quads = {}
	imagemng.image = love.graphics.newImage(fileName)
	imagemng.image:setFilter("nearest")
	imagemng.tamanho = tamanho
	for i = 0, quadsNumber, 1 do
		imagemng.quads[i] = love.graphics.newQuad(0, i*imagemng.tamanho, imagemng.tamanho, imagemng.tamanho, imagemng.image:getDimensions())
	end


	return imagemng
end


return ImageMng