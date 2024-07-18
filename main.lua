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
camera.damping = 1
-- ALTERA O DESCOLAMENTO DA CAMERA
camera:setMasterOffset(-100, 50)
-- CONFIGURAÇÃO DO PARALLAX
camera:setParallax(1, 0.9, 0.8, 0.7, 0.6, 0.4, 0.2, 0)

camera.xScale = 1
camera.yScale = 1

local fundo = display.newImageRect("imagens/fundo.png", x, y)
fundo.x = x*0.5
fundo.y = y*0.5
camera:add(fundo, 8)

local nuvem = display.newImageRect( "imagens/nuvem.png", x*0.2, y*0.2)
nuvem.x = x*0.5
nuvem.y = y*0.2
camera:add(nuvem, 7)

local playerSheet = graphics.newImageSheet("imagens/player-sprite-sheet.png", {
  width = 540/6,
  height = 190/2,
  numFrames = 12
})

local playerAnimacao = {
  {name = "parado", start = 1, count = 3, time = 500 },
  {name = "correndo", start = 5, count = 9, time = 1000}
}

local player = display.newSprite( playerSheet, playerAnimacao )
player.x = x*0.5
player.y = y*0.5
-- player.xScale = 2.5
-- player.yScale = 2.5
physics.addBody(player,{bounce = 0,friction = 0.5})
player.isFixedRotation = true
player.direcao = "parado"
player.pulos = 0
-- Adiciona o player na camera e na camada1
camera:add(player, 1)

local function movimentacao(e)
  if e.phase == "down" then
    if e.keyName == "a" then
      player.direcao = "esquerda"
      player.xScale = -1
      player:setSequence("correndo")
      player:play()
    elseif e.keyName == "d" then
      player.direcao = "direita"
      player.xScale = 1
      player:setSequence("correndo")
      player:play()
    end
  end

  if e.phase == "up" then
    if e.keyName == "a" or e.keyName == "d" then
      player.direcao = "parado"
      player:setSequence("parado")
      player:play()
    end
  end
end
Runtime:addEventListener("key", movimentacao)


local function impulso()
  local velocidade = player:getLinearVelocity()
 
  if player.direcao == "direita" and velocidade < 700 then
    player:applyLinearImpulse(0.2, 0, player.x, player.y)
  elseif player.direcao == "esquerda" and velocidade > -700 then
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
   if(e.object1 == player and e.object2.id=="plataformaID") or(e.object2 == player and e.object1.id=="plataformaID")  then
      player.pulos = 0
   end
  end
end
Runtime:addEventListener("collision", colisaoPlayer)

function reiniciar()
  if player.y > y*4 then
    player.x = x*0.5
    player.y = y*0.5
  end
end
Runtime:addEventListener("enterFrame", reiniciar)

local function addPlataforma(posX, posY, largura, altura)
  local plataforma = display.newRect(posX, posY, largura, altura)
  plataforma.id = "plataformaID"
  physics.addBody(plataforma, "static", {bounce = 0, friction = 0.5})
  camera:add(plataforma, 1)
end

addPlataforma(x*0.5, y*0.8, x, y*0.2)
addPlataforma(x*1.7, y*0.6, x, y*0.2)
addPlataforma(x*3, y*0.4, x, y*0.2)
addPlataforma(x*3.8, y*0.1, x*0.2, y*0.2)
addPlataforma(x*4.2, -y*0.1, x*0.2, y*0.2)


-- FOCA A CAMERA EM UM OBJETO
camera:setFocus(player)
-- INICIA O RASTREAMENTO DA CAMERA
camera:track()