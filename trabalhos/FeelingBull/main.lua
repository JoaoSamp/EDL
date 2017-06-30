mode = require "modes/mode"
kcfg = require "config/keyconfig"
gamestatus = require "config/gamestatus"
dtime = 0
	
function love.load()	
	gameMode = mode:new()
end 

function love.keypressed (key)
	if gameMode.status ~= gamestatus.gameRun then
		if key == kcfg.kUp and gameMode.selected > 1 then
			gameMode.selected = gameMode.selected - 1
		elseif (key == kcfg.kDown) and (gameMode.selected < gameMode.maxItem[gameMode.status]) then
			gameMode.selected = gameMode.selected + 1
		elseif key == kcfg.kConfirm then
			gameMode:confirmMenu()
		end
	else 
		if key == kcfg.kEsc then
			gameMode:changeStatus(gamestatus.gameMenu)
		end
	end
end

function love.update(dt)
	if gameMode.status == gamestatus.gameRun then
		gameMode.scene:update(dt)
	end
	dtime = dt
end


function love.draw()
	gameMode:draw(dtime)
end



-- POR FAVOR, JOGUE UM POUCO !! 

-- TRABALHO-05

-- Nome: =
-- Propriedade: operação de atribuição
-- Binding time: design
-- Explicação: o significado do símbolo = foi definido durante a criação da linguagem

-- Nome: false
-- Propriedade: representa um valor verdadeiro
-- Binding time: design
-- Explicação: o valor da palavra false foi definido durante a criação da linguagem
-- seu valor é o mesmo em qualquer programa em lua e não pode ser alterado
-- Localização: modes/mode.lua linha 51 - mode:startGame(false)

-- Nome: kcfg
-- Propriedade: endereço
-- Binding time: compilação
-- Explicação: por ser uma variavel global e constante durante o jogo, a tabela mode é definida em tempo de compilação

-- Nome: kUp
-- Propriedade: valor
-- Binding time: compilação
-- Explicação: o valor de kUp é atribuito no mesmo momento que kcfg e seu valor é o mesmo durante todo o programa
-- Localização: config/keyconfig.lua

-- Nome: scene.bulls
-- Propriedade: endereço
-- Binding time: execução
-- Explicação: a amarração da tabela scene.bulls é feita mediante a chamada de scene:start(), isso ocorre apenas em tempo de execução
-- Localização: modes/scenes.lua scene:start(level) linha 19

-- Nome: posX
-- Propriedade: valor
-- Binding time: execução
-- Explicação: por ser uma variavel local, sua atribuição ocorre no momento em que a função player:draw() é chamada
-- Localização: chars/player.lua player:draw() linha 107



-- TRABALHO-06

-- Enumeração: CharType			Localização: config/chartype.lua
-- Array: scene.stones			Localização: modes/scenes.lua scene:start(level) linha 33
-- Registro: Player				Localização: chars/player.lua
-- Union: data1					Localização: modes/mode.lua beginContact() linha 175
-- Data1 é formada por um registro e um identificador - Podendo ser um player bull stone ou cape



-- TRABALHO-07

-- Localização: modes/scenes.lua scene:start(level) linha 33
-- Descrição: Sempre que a fase inicia, um número aleatório de pedras é gerado.
-- Sempre que um touro acertar a pedra ela é destruída

-- Coleção
-- Escopo: A coleção é visível dentro do objeto Scenes e pode ser acessada através de um instacia do objeto
-- Tempo de Vida: O tempo de vida da coleção inicia junto com a chamada da função scene:start()
				-- O tempo termina quando o jogo é encerrado ou até que a função seja chamada novamente, dessa forma,
				-- a coleção anterior da lugar a uma nova
-- Alocação: Em toda chamada de scene:start()
-- Desalocação:	A partir da segunda chamada de scene:start() ou encerramento do jogo

-- Objeto
-- Escopo: O objeto é visivel em dentro do própio objeto Stones e suas instancias podem ser acessadas através da coleção
		-- criada em Scenes
-- Tempo de Vida: O tempo de vida do objeto inicia quando a função stone:new() é chamada e o objeto é adicionado no array
				-- Ele encerra quando o objeto é removido da lista 
-- Alocação: Na chamada da função stone:new() 
-- Desalocação: Na chamada da função stone:destroy()



-- TRABALHO-08

-- Closure: Objetos Player, Bull, Stone e Char
-- Localização: chars/

-- Coroutines
-- Definição do próximo movimento do Touro
-- Localização: chars/bull.lua linha 143 bull.nextMove
