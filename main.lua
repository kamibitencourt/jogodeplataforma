local x, y = display.contentWidth, display.contentHeight

local physics = require 'physics'

physics.start()
physics.setGravity ( 0, 80)
physics.setDrawMode( "hybrid")

local plataforma = display.newRect( x*0.5, y*0.9, x, y*0.2)
plataforma: setFillColor(144/255, 92/255, 35/255)
physics.addBody( plataforma,  "static")

local player = display.newRect ( x*0.15, y*0.7, 100, 100 )
physics.addBody (player)
player.vidas= 3
player.direcao = "parado"

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


local function impulso ()
    local velocidade = player:getLinearVelocity()

    if player.direcao == "direita" and velocidade < 500 then
        player:applyLinearImpulse(0.2, 0, player.x, player.y)
    

    elseif player.direcao == "esquerda" and velocidade > -500 then
        player:applyLinearImpulse(-0.2, 0, player.x, player.y)

    end
end
Runtime:addEventListener("enterFrame", impulso)