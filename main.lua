local x, y = display.contentWidth, display.contentHeight

local physics = require "physics"
physics.start()
physics.setGravity( 0, 80 )
physics.setDrawMode( "hybrid" )

-- CHAMA A BIBLIOTECA
local perspective = require "perspective"
-- CRIA A CAMERA VIRTUAL
local camera = perspective.createView()
-- PREPARA AS CAMADAS DA CAMERA PARA SEREM UTILIZADAS
camera:prependLayer()
-- ALTERA A VELOCIDADE DA CAMERA
camera.damping = 30
--ALTERA O DESLOCAMENTO DA CAMERA
camera:setMasterOffset(-100, 150 )
--CONFIGURAÇAO DO PARALLAX
camera:setParallax (1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.2, 0)

camera.xScale = 1
camera.yScale = 1

local fundo = display.newImageRect ("imagens/fundo.png", x, y)
fundo.x = x*0.5
fundo.y = y*0.5
camera:add(fundo, 8)

local nuvem = display.newImageRect ("imagens/nuvem.png", x*0.2, y*0.2)
nuvem.x = x*0.5
nuvem.y = y*0.2
camera:add(nuvem, 7)

local plataforma = display.newRect( x*0.5, y*0.9, x, y*0.2 )
plataforma:setFillColor(200/255, 92/255, 35/255)
physics.addBody(plataforma, "static", {bounce = 0, friction = 0.5})

-- Adiciona a plataforma na camera e na camada1
camera:add(plataforma, 1)

local player = display.newImageRect("imagens/player.png", 100, 200)
player.x = x*0.5
player.y = y*0.5

physics.addBody(player,{bounce = 0, friction = 0.5})
player.isFixedRotation = true
player.direcao = "parado"
player.pulos = 0

-- Adiciona o player na camera e na camada1
camera:add(player, 1)

local function movimentacao(e)
  if e.phase == "down" then
    if e.keyName == "a" then
      player.direcao = "esquerda"
      player.xScale= -1
    elseif e.keyName == "d" then
      player.direcao = "direita"
      player.xScale = 1
    end
  end

  if e.phase == "up" then
    if e.keyName == "a" or e.keyName == "d" then
      player.direcao = "parado"
    end
  end
end
Runtime:addEventListener("key", movimentacao)


local function impulso()
  local velocidade = player:getLinearVelocity()
 
  if player.direcao == "direita" and velocidade < 500 then
    player:applyLinearImpulse(0.2, 0, player.x, player.y)
  elseif player.direcao == "esquerda" and velocidade > -700 then
    player:applyLinearImpulse(-0.2, 0, player.x, player.y)
  end
end
Runtime:addEventListener("enterFrame", impulso)

local function pular(e)
  if e.phase == "down" then
    if e.keyName == "w" or e.keyName == "space" then
      if player.pulos < 100 then
        player:applyLinearImpulse(0, -7, player.x, player.y)
        player.pulos = player.pulos + 1
      end
    end
  end
end
Runtime:addEventListener("key", pular)

local function colisaoPlayer(e)
  if e.phase == "began" then
    if (e.object1 == player and e.object2.id == "plataformaID") or (e.object2 == player and e.object1.id == "plataformaID")  then
      player.pulos = 0
    end
  end
end
Runtime:addEventListener("collision", colisaoPlayer)

function reiniciar ()
  if player.y > y*10 then
     player.x = x*0.5
     player.y = y*0.5
  end
end

local function addPlataforma(posX, posY, largura, altura)
  local plataforma = display.newRect(posX, posY, largura, altura)
  plataforma.id = "plataformaID"
  physics.addBody(plataforma, "static", {bounce = 0, friction = 0.5})
  camera:add(plataforma, 1)
end

addPlataforma(x*0.5, y*0.8, x, y*0.2)
addPlataforma(x*1.7, y*0.6, x, y*0.2)
addPlataforma(x*3, y*0.4, x, y*0.2)
addPlataforma(x*4., -y*0.2, x, y*0.2)


-- FOCA A CAMERA EM UM OBJETO
camera:setFocus(player)
-- INICIA O RASTREAMENTO DA CAMERA
camera:track()

timer.performWithDelay( 3000, function ()
end )

