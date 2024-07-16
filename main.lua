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

local plataforma = display.newRect( x*0.5, y*0.9, x, y*0.2 )
plataforma:setFillColor(200/255, 92/255, 35/255)
physics.addBody(plataforma, "static", {bounce = 0, friction = 0.5})
-- Adiciona a plataforma na camera e na camada1
camera:add(plataforma, 1)

local player = display.newRect( x*0.15, y*0.7, 100, 100 )
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
    elseif e.keyName == "d" then
      player.direcao = "direita"
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
  elseif player.direcao == "esquerda" and velocidade > -500 then
    player:applyLinearImpulse(-0.2, 0, player.x, player.y)
  end
end
Runtime:addEventListener("enterFrame", impulso)

local function pular(e)
  if e.phase == "down" then
    if e.keyName == "w" or e.keyName == "space" then
      if player.pulos < 2 then
        player:applyLinearImpulse(0, -3, player.x, player.y)
        player.pulos = player.pulos + 1
      end
    end
  end
end
Runtime:addEventListener("key", pular)

local function colisaoPlayer(e)
  if e.phase == "began" then
    if (e.object1 == player and e.object2 == plataforma) or (e.object2 == player and e.object1 == plataforma)  then
      player.pulos = 0
    end
  end
end
Runtime:addEventListener("collision", colisaoPlayer)

-- FOCA A CAMERA EM UM OBJETO
camera:setFocus(player)
-- INICIA O RASTREAMENTO DA CAMERA
camera:track()