-- 0. DECLARACIÓN DE VARIABLES
local espiritu = {}
local carta = {}
local gravedad = 1000
local meta = {}
local enemigo = {}
local enemigo2 = {}
local bloques = {}
local compuerta = {}
local interruptor = {}
local compuerta2 = {}
local interruptor2 = {}

local gameState = "menu"
local menuOptions = {"Jugar", "Ajustes", "Salir"}
local settings = {volume = 0.5, resolutionIndex = 1}
local levelSelectOpen = false
local cameraX = 0
local cameraY = 0
local worldWidth = 2000
local worldHeight = 600
local currentLevel = 1
local levelCompleteTime = 0
local unlockedLevel = 1
local saveStateFile = "exhalare_save.txt"
local resolutions = {
    {800, 600},
    {1024, 768},
    {1280, 720}
}
local titleFont, buttonFont, smallFont

-- Variables de Audio
local musicaMenu
local musicaNivel1
local musicaNivel2
local sonidoAlerta
local sonidoDerrota
local sonidoVictoria

-- Variable del Cronómetro
local tiempoNivel = 0

-- Variables para imágenes
local fondoNivel
local texturaCarta
local texturaPuzzle
local texturaSueloSuperficie
local texturaSueloBase
local texturaPlataforma
local texturaCompuerta
local texturaPRE
local texturaPOS

-- Funciones utilitarias para texto estilizado (sombra + color acorde)
local function drawStyledPrint(text, font, x, y, r, g, b, a)
    r = r or 0.92; g = g or 0.96; b = b or 1; a = a or 1
    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0, 0.45 * a)
    love.graphics.print(text, x + 2, y + 2)
    love.graphics.setColor(r, g, b, a)
    love.graphics.print(text, x, y)
end

local function drawStyledPrintf(text, font, x, y, limit, align, r, g, b, a)
    r = r or 0.92; g = g or 0.96; b = b or 1; a = a or 1
    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0, 0.45 * a)
    love.graphics.printf(text, x + 2, y + 2, limit, align)
    love.graphics.setColor(r, g, b, a)
    love.graphics.printf(text, x, y, limit, align)
end
local texturaEspirituIdle
local texturaEspirituAir
local texturaEspirituMLeft
local texturaEspirituMRight
local texturaEnemigoFrames = {}
local texturaEnemigoRage

local function loadLevel(levelNumber)
    levelNumber = math.max(1, math.min(levelNumber or 1, unlockedLevel))
    currentLevel = levelNumber
    tiempoNivel = 0
    cameraX = 0
    cameraY = 0

    if levelNumber == 1 then
        worldWidth = 2000

        espiritu.x = 100
        espiritu.y = 260
        espiritu.velocidad = 240
        espiritu.fuerzaSalto = 400
        espiritu.velocidadY = 0
        espiritu.enSuelo = false
        espiritu.tieneCarta = false
        espiritu.ancho = 60
        espiritu.alto = 60
        espiritu.state = "idle"

        carta.x = 1160
        carta.y = 240
        carta.baseY = 240
        carta.ancho = 36
        carta.alto = 36
        carta.activa = true
        carta.floatTimer = 0

        meta.x = 1700
        meta.y = 260
        meta.ancho = 60
        meta.alto = 60
        meta.rotation = 0
        meta.rotationSpeed = 0
        meta.colorTimer = 0

        enemigo.x = 520
        enemigo.y = 248
        enemigo.ancho = 72
        enemigo.alto = 72
        enemigo.dir = 0
        enemigo.rango = 130
        enemigo.patrol = {min = 520, max = 620, vel = 80}
        enemigo.angulo = math.rad(45)
        enemigo.alertTimer = 0
        enemigo.alerta = false
        enemigo.chaseTimeLeft = 0
        enemigo.velocidadCaza = 140
        enemigo.animTimer = 0
        enemigo.animFrame = 1
        enemigo.animFrameDuration = 0.15
        enemigo.rageTimer = 0

        enemigo2.x = 1320
        enemigo2.y = 248
        enemigo2.ancho = 72
        enemigo2.alto = 72
        enemigo2.dir = math.pi
        enemigo2.rango = 130
        enemigo2.patrol = {min = 1260, max = 1470, vel = 90}
        enemigo2.angulo = math.rad(45)
        enemigo2.alertTimer = 0
        enemigo2.alerta = false
        enemigo2.chaseTimeLeft = 0
        enemigo2.velocidadCaza = 140
        enemigo2.animTimer = 0
        enemigo2.animFrame = 1
        enemigo2.animFrameDuration = 0.15
        enemigo2.rageTimer = 0

        compuerta.x = 1120
        compuerta.y = 0
        compuerta.alto = 320
        compuerta.ancho = 120
        compuerta.activa = true
        compuerta.activa = true

        interruptor.x = 980
        interruptor.y = 300
        interruptor.ancho = 30
        interruptor.alto = 20
        interruptor.pisada = false

        compuerta2.x = 1480
        compuerta2.y = 0
        compuerta2.alto = 320
        compuerta2.ancho = 120
        compuerta2.activa = true

        interruptor2.x = 1320
        interruptor2.y = 300
        interruptor2.ancho = 30
        interruptor2.alto = 20
        interruptor2.pisada = false

        bloques = {}
        bloques[1] = {x = 250, y = 240, ancho = 120, alto = 20}
        bloques[2] = {x = 450, y = 200, ancho = 120, alto = 20}
        bloques[3] = {x = 610, y = 240, ancho = 140, alto = 20}
        bloques[4] = {x = 860, y = 240, ancho = 100, alto = 20}
        bloques[5] = {x = 1240, y = 240, ancho = 140, alto = 20}
        bloques[6] = {x = 1420, y = 200, ancho = 100, alto = 20}
        bloques[7] = {x = 1580, y = 240, ancho = 120, alto = 20}
        bloques[8] = {x = 980, y = 160, ancho = 80, alto = 20}
        bloques[9] = {x = 200, y = 360, ancho = 90, alto = 20}
        bloques[10] = {x = 340, y = 410, ancho = 110, alto = 20}
        bloques[11] = {x = 520, y = 370, ancho = 90, alto = 20}
        bloques[12] = {x = 760, y = 400, ancho = 120, alto = 20}
        bloques[13] = {x = 1180, y = 390, ancho = 100, alto = 20}
        bloques[14] = {x = 1380, y = 360, ancho = 90, alto = 20}
        -- Ajustar la posición de la carta para que no esté sobre una compuerta
        if carta.activa then
            local targetX = carta.x
            local candidates = {}
            for _, p in ipairs(bloques) do table.insert(candidates, p) end
            table.sort(candidates, function(a,b) return math.abs((a.x+a.ancho/2)-targetX) < math.abs((b.x+b.ancho/2)-targetX) end)
            local function overlapsDoor(x)
                if compuerta and compuerta.x and compuerta.ancho then
                    if x < compuerta.x + compuerta.ancho and x + carta.ancho > compuerta.x then return true end
                end
                if compuerta2 and compuerta2.x and compuerta2.ancho then
                    if x < compuerta2.x + compuerta2.ancho and x + carta.ancho > compuerta2.x then return true end
                end
                return false
            end
            local placed = false
            for _, p in ipairs(candidates) do
                local newX = p.x + (p.ancho - carta.ancho)/2
                if not overlapsDoor(newX) then
                    carta.x = newX
                    carta.y = p.y - carta.alto - 2
                    carta.baseY = carta.y
                    placed = true
                    break
                end
            end
            if not placed then
                -- fallback: shift fuera de la puerta más cercana
                if compuerta and targetX >= compuerta.x and targetX <= compuerta.x + compuerta.ancho then
                    carta.x = math.max(0, compuerta.x - carta.ancho - 10)
                elseif compuerta2 and targetX >= compuerta2.x and targetX <= compuerta2.x + compuerta2.ancho then
                    carta.x = math.min(worldWidth - carta.ancho, compuerta2.x + compuerta2.ancho + 10)
                end
            end
        end
    else
        worldWidth = 2400

        espiritu.x = 90
        espiritu.y = 260
        espiritu.velocidad = 240
        espiritu.fuerzaSalto = 420
        espiritu.velocidadY = 0
        espiritu.enSuelo = false
        espiritu.tieneCarta = false
        espiritu.ancho = 60
        espiritu.alto = 60
        espiritu.state = "idle"

        carta.x = 1600
        carta.y = 220
        carta.baseY = 220
        carta.ancho = 36
        carta.alto = 36
        carta.activa = true
        carta.floatTimer = 0

        meta.x = 2140
        meta.y = 240
        meta.ancho = 60
        meta.alto = 60
        meta.rotation = 0
        meta.rotationSpeed = 0
        meta.colorTimer = 0

        enemigo.x = 420
        enemigo.y = 248
        enemigo.ancho = 72
        enemigo.alto = 72
        enemigo.dir = 0
        enemigo.rango = 140
        enemigo.patrol = {min = 360, max = 760, vel = 85}
        enemigo.angulo = math.rad(45)
        enemigo.alertTimer = 0
        enemigo.alerta = false
        enemigo.chaseTimeLeft = 0
        enemigo.velocidadCaza = 150
        enemigo.animTimer = 0
        enemigo.animFrame = 1
        enemigo.animFrameDuration = 0.15
        enemigo.rageTimer = 0

        enemigo2.x = 1760
        enemigo2.y = 248
        enemigo2.ancho = 72
        enemigo2.alto = 72
        enemigo2.dir = math.pi
        enemigo2.rango = 150
        enemigo2.patrol = {min = 1730, max = 1880, vel = 110}
        enemigo2.angulo = math.rad(45)
        enemigo2.alertTimer = 0
        enemigo2.alerta = false
        enemigo2.chaseTimeLeft = 0
        enemigo2.velocidadCaza = 150
        enemigo2.animTimer = 0
        enemigo2.animFrame = 1
        enemigo2.animFrameDuration = 0.15
        enemigo2.rageTimer = 0

        compuerta.x = 1320
        compuerta.y = 0
        compuerta.alto = 320
        compuerta.ancho = 120
        compuerta.activa = true

        interruptor.x = 1100
        interruptor.y = 300
        interruptor.ancho = 30
        interruptor.alto = 20
        interruptor.pisada = false

        compuerta2.x = 1960
        compuerta2.y = 0
        compuerta2.alto = 320
        compuerta2.ancho = 120
        compuerta2.activa = true

        interruptor2.x = 1800
        interruptor2.y = 300
        interruptor2.ancho = 30
        interruptor2.alto = 20
        interruptor2.pisada = false

        bloques = {}
        bloques[1] = {x = 220, y = 240, ancho = 120, alto = 20}
        bloques[2] = {x = 380, y = 180, ancho = 110, alto = 20}
        bloques[3] = {x = 620, y = 260, ancho = 130, alto = 20}
        bloques[4] = {x = 840, y = 200, ancho = 95, alto = 20}
        bloques[5] = {x = 1020, y = 360, ancho = 120, alto = 20}
        bloques[6] = {x = 1400, y = 180, ancho = 120, alto = 20}
        bloques[7] = {x = 1500, y = 300, ancho = 100, alto = 20}
        bloques[8] = {x = 1660, y = 240, ancho = 100, alto = 20}
        bloques[9] = {x = 1980, y = 210, ancho = 160, alto = 20}
        bloques[11] = {x = 200, y = 400, ancho = 100, alto = 20}
        bloques[12] = {x = 720, y = 410, ancho = 95, alto = 20}
        bloques[13] = {x = 1500, y = 400, ancho = 110, alto = 20}
        bloques[14] = {x = 1840, y = 420, ancho = 120, alto = 20}

        -- Colocar la carta justo después de la primera compuerta para que sea accesible
        carta.x = compuerta.x + compuerta.ancho + 60
        -- Ajustar la posición de la carta para que no esté sobre una compuerta
        if carta.activa then
            local targetX = carta.x
            local candidates = {}
            for _, p in ipairs(bloques) do table.insert(candidates, p) end
            table.sort(candidates, function(a,b) return math.abs((a.x+a.ancho/2)-targetX) < math.abs((b.x+b.ancho/2)-targetX) end)
            local function overlapsDoor(x)
                if compuerta and compuerta.x and compuerta.ancho then
                    if x < compuerta.x + compuerta.ancho and x + carta.ancho > compuerta.x then return true end
                end
                if compuerta2 and compuerta2.x and compuerta2.ancho then
                    if x < compuerta2.x + compuerta2.ancho and x + carta.ancho > compuerta2.x then return true end
                end
                return false
            end
            local placed = false
            for _, p in ipairs(candidates) do
                local newX = p.x + (p.ancho - carta.ancho)/2
                if not overlapsDoor(newX) then
                    carta.x = newX
                    carta.y = p.y - carta.alto - 2
                    carta.baseY = carta.y
                    placed = true
                    break
                end
            end
            if not placed then
                if compuerta and targetX >= compuerta.x and targetX <= compuerta.x + compuerta.ancho then
                    carta.x = math.max(0, compuerta.x - carta.ancho - 10)
                elseif compuerta2 and targetX >= compuerta2.x and targetX <= compuerta2.x + compuerta2.ancho then
                    carta.x = math.min(worldWidth - carta.ancho, compuerta2.x + compuerta2.ancho + 10)
                end
            end
        end
    end
end

local function resetLevel()
    loadLevel(currentLevel)
end

local pendingLevelToStart = nil

local function beginLevel(levelNumber)
    levelNumber = math.max(1, math.min(levelNumber or 1, unlockedLevel))
    loadLevel(levelNumber)
    gameState = "playing"
    musicaMenu:stop()
    musicaNivel1:stop()
    musicaNivel2:stop()
    -- usar la misma música del nivel 1 para todos los niveles
    musicaNivel1:play()
end

local function startLevel(levelNumber)
    -- Show pre-level screen first
    pendingLevelToStart = math.max(1, math.min(levelNumber or 1, unlockedLevel))
    gameState = "preLevel"
end

local function saveProgress()
    local content = string.format("return {unlockedLevel = %d, currentLevel = %d}", unlockedLevel, currentLevel)
    pcall(function()
        love.filesystem.write(saveStateFile, content)
    end)
end

local function completeLevel()
    if gameState ~= "playing" then
        return
    end

    levelCompleteTime = tiempoNivel
    if currentLevel == 1 then
        unlockedLevel = math.max(unlockedLevel, 2)
    end
    saveProgress()
    gameState = "levelComplete"
    sonidoVictoria:stop()
    sonidoVictoria:play()
    musicaNivel1:stop()
    musicaNivel2:stop()
end

local function continueFromVictory()
    if currentLevel == 1 then
        startLevel(2)
    else
        gameState = "menu"
        musicaNivel1:stop()
        musicaNivel2:stop()
        musicaMenu:play()
    end
end

local function isMouseInRect(mx, my, x, y, w, h)
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end

local function drawTiledTexture(texture, x, y, w, h, tileSize)
    if not texture then
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
        love.graphics.rectangle("fill", x, y, w, h)
        return
    end

    local imgW, imgH = texture:getDimensions()
    local cols = math.max(1, math.ceil(w / tileSize))
    local rows = math.max(1, math.ceil(h / tileSize))

    love.graphics.setColor(1, 1, 1, 1)
    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            local cellW = math.min(tileSize, w - col * tileSize)
            local cellH = math.min(tileSize, h - row * tileSize)
            local scaleX = cellW / imgW
            local scaleY = cellH / imgH
            love.graphics.draw(texture, x + col * tileSize, y + row * tileSize, 0, scaleX, scaleY)
        end
    end
end

local function rayIntersectsRect(rx, ry, dx, dy, rect)
    local tmin, tmax = -math.huge, math.huge

    local function checkAxis(origin, direction, minB, maxB)
        if direction == 0 then
            if origin < minB or origin > maxB then
                return false, nil, nil
            end
            return true, -math.huge, math.huge
        end
        local t1 = (minB - origin) / direction
        local t2 = (maxB - origin) / direction
        if t1 > t2 then
            t1, t2 = t2, t1
        end
        return true, t1, t2
    end

    local okX, tx1, tx2 = checkAxis(rx, dx, rect.x, rect.x + rect.ancho)
    if not okX then
        return nil
    end
    local okY, ty1, ty2 = checkAxis(ry, dy, rect.y, rect.y + rect.alto)
    if not okY then
        return nil
    end

    tmin = math.max(tmin, tx1, ty1)
    tmax = math.min(tmax, tx2, ty2)
    if tmax >= math.max(tmin, 0) then
        return math.max(tmin, 0)
    end
    return nil
end

local function getObstacleDistance(rx, ry, dx, dy, maxRange)
    local minDist = maxRange
    local floorRect = {x = 0, y = 320, ancho = worldWidth, alto = worldHeight - 320}
    local t = rayIntersectsRect(rx, ry, dx, dy, floorRect)
    if t and t >= 0 then
        minDist = math.min(minDist, t)
    end
    for _, bloque in ipairs(bloques) do
        local rect = {x = bloque.x, y = bloque.y, ancho = bloque.ancho, alto = bloque.alto}
        local t2 = rayIntersectsRect(rx, ry, dx, dy, rect)
        if t2 and t2 >= 0 then
            minDist = math.min(minDist, t2)
        end
    end
    return minDist
end

local function isLineBlocked(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dist = math.sqrt(dx * dx + dy * dy)
    if dist == 0 then
        return false
    end
    local dirX = dx / dist
    local dirY = dy / dist
    local floorRect = {x = 0, y = 320, ancho = worldWidth, alto = worldHeight - 320}
    local t = rayIntersectsRect(x1, y1, dirX, dirY, floorRect)
    if t and t > 0 and t < dist then
        return true
    end
    for _, bloque in ipairs(bloques) do
        local rect = {x = bloque.x, y = bloque.y, ancho = bloque.ancho, alto = bloque.alto}
        local t2 = rayIntersectsRect(x1, y1, dirX, dirY, rect)
        if t2 and t2 > 0 and t2 < dist then
            return true
        end
    end
    return false
end

local function updateEnemyAnimation(enemy, dt)
    if enemy.rageTimer > 0 then
        enemy.rageTimer = math.max(0, enemy.rageTimer - dt)
        return
    end

    enemy.animTimer = enemy.animTimer + dt
    if enemy.animTimer >= enemy.animFrameDuration then
        enemy.animTimer = enemy.animTimer - enemy.animFrameDuration
        enemy.animFrame = enemy.animFrame % 3 + 1
    end
end

local function getMenuButtonRect(index)
    local width = 260
    local height = 50
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local x = (screenW - width) / 2
    local y = screenH * 0.35 + (index - 1) * (height + 20)
    return x, y, width, height
end

local localArrowSize = 32

local function drawArrow(x, y, size, direction)
    if direction == "left" then
        love.graphics.polygon("fill", x + size * 0.65, y + size * 0.2, x + size * 0.65, y + size * 0.8, x + size * 0.35, y + size * 0.5)
    else
        love.graphics.polygon("fill", x + size * 0.35, y + size * 0.2, x + size * 0.35, y + size * 0.8, x + size * 0.65, y + size * 0.5)
    end
end

local function getSettingsArrowRects()
    local screenW = love.graphics.getWidth()
    local centerX = screenW / 2
    local arrowOffset = 160
    local volumeY = 220 - localArrowSize / 2
    local resolutionY = 260 - localArrowSize / 2
    return {
        volLeft = {x = centerX - arrowOffset - localArrowSize, y = volumeY, w = localArrowSize, h = localArrowSize},
        volRight = {x = centerX + arrowOffset, y = volumeY, w = localArrowSize, h = localArrowSize},
        resLeft = {x = centerX - arrowOffset - localArrowSize, y = resolutionY, w = localArrowSize, h = localArrowSize},
        resRight = {x = centerX + arrowOffset, y = resolutionY, w = localArrowSize, h = localArrowSize},
    }
end

local function setResolution(index)
    index = math.max(1, math.min(index, #resolutions))
    settings.resolutionIndex = index
    local width, height = resolutions[index][1], resolutions[index][2]
    love.window.setMode(width, height, {resizable = false, vsync = true})
end

local function loadProgress()
    local ok, data = pcall(function()
        return love.filesystem.read(saveStateFile)
    end)
    if not ok or not data then
        return
    end

    local success, state = pcall(function()
        return assert(loadstring("return " .. data))()
    end)

    if success and type(state) == "table" then
        unlockedLevel = math.max(1, tonumber(state.unlockedLevel) or 1)
        currentLevel = math.max(1, math.min(tonumber(state.currentLevel) or 1, unlockedLevel))
        settings.volume = math.max(0, math.min(1, tonumber(state.volume) or settings.volume))
        settings.resolutionIndex = math.max(1, math.min(tonumber(state.resolutionIndex) or settings.resolutionIndex, #resolutions))
    end
end

local function saveProgress()
    local content = string.format(
        "return {unlockedLevel = %d, currentLevel = %d, volume = %s, resolutionIndex = %d}",
        unlockedLevel,
        currentLevel,
        tostring(settings.volume),
        settings.resolutionIndex
    )
    pcall(function()
        love.filesystem.write(saveStateFile, content)
    end)
end

-- Función auxiliar para cargar audio sin que el juego crashee si falta el archivo
local function cargarAudioSeguro(ruta, tipo)
    local exito, fuente = pcall(love.audio.newSource, ruta, tipo)
    if exito then
        return fuente
    else
        print("Advertencia: No se encontró el archivo de audio -> " .. ruta)
        return {
            play = function() end,
            pause = function() end,
            stop = function() end,
            setLooping = function() end
        }
    end
end

-- 1. CONFIGURACIÓN INICIAL
function love.load()
    titleFont = love.graphics.newFont(64)
    buttonFont = love.graphics.newFont(24)
    smallFont = love.graphics.newFont(18)
    
    loadProgress()
    love.audio.setVolume(settings.volume)
    
    musicaMenu = cargarAudioSeguro("bgs/menu/Bone Bottom.mp3", "stream") 
    musicaMenu:setLooping(true)
    
    musicaNivel1 = cargarAudioSeguro("bgs/level/lvl1.mp3", "stream")
    musicaNivel1:setLooping(true)
    
    musicaNivel2 = cargarAudioSeguro("audio/nivel2_bgm.mp3", "stream")
    musicaNivel2:setLooping(true)
    
    sonidoAlerta = cargarAudioSeguro("audio/alerta.wav", "static")
    sonidoDerrota = cargarAudioSeguro("audio/derrota.wav", "static")
    sonidoVictoria = cargarAudioSeguro("audio/victoria.wav", "static")

    -- Iniciar la música del menú al arrancar
    musicaMenu:play()
    
    setResolution(settings.resolutionIndex)
    meta.frames = {}
    
    local success = pcall(function()
        for i = 1, 8 do
            meta.frames[i] = love.graphics.newImage("Assets/Animated Portal/Portal spinning/" .. i .. ".png")
        end
    end)
    
    if success and #meta.frames > 0 then
        meta.frameWidth, meta.frameHeight = meta.frames[1]:getDimensions()
    else
        meta.frameWidth, meta.frameHeight = 40, 40
    end
    
    meta.frameCount = #meta.frames > 0 and #meta.frames or 1
    meta.currentFrame = 1
    meta.frameTimer = 0
    meta.frameDuration = 0.1
    
    -- Cargar el fondo del nivel
    local successBg, bgImg = pcall(love.graphics.newImage, "Assets/background/LVLBG.png")
    if successBg then
        fondoNivel = bgImg
        fondoNivel:setFilter("linear", "linear") 
    else
        print("Advertencia: No se encontró la imagen del fondo en Assets/background/LVLBG.png")
    end

    -- Cargar la textura de la carta
    local successCarta, cartaImg = pcall(love.graphics.newImage, "Assets/textures/letter/letter.png")
    if successCarta then
        texturaCarta = cartaImg
        -- Si la imagen de la carta es un "pixel art" pequeño y quieres que se vea nítido y no borroso al escalarse, cambia "linear" a "nearest"
        texturaCarta:setFilter("nearest", "nearest") 
    else
        print("Advertencia: No se encontró la textura de la carta en Assets/textures/letter/letter.png")
    end

    -- Cargar la textura de la placa/puzzle (placa de presión)
    local successPuzzle, puzzleImg = pcall(love.graphics.newImage, "Assets/textures/puzzle/puzzle.png")
    if successPuzzle then
        texturaPuzzle = puzzleImg
        texturaPuzzle:setFilter("nearest", "nearest")
    else
        print("Advertencia: No se encontró la textura del puzzle en Assets/textures/puzzle/puzzle.png")
    end

    -- Cargar texturas del piso y plataformas
    local successFloor1, floor1Img = pcall(love.graphics.newImage, "Assets/textures/floor/floor1.png")
    if successFloor1 then
        texturaSueloSuperficie = floor1Img
        texturaSueloSuperficie:setFilter("nearest", "nearest")
    else
        print("Advertencia: No se encontró la textura del suelo superior en Assets/textures/floor/floor1.png")
    end

    local successFloor3, floor3Img = pcall(love.graphics.newImage, "Assets/textures/floor/floor3.png")
    if successFloor3 then
        texturaSueloBase = floor3Img
        texturaSueloBase:setFilter("nearest", "nearest")
    else
        print("Advertencia: No se encontró la textura del suelo inferior en Assets/textures/floor/floor3.png")
    end

    local successPlatform, platformImg = pcall(love.graphics.newImage, "Assets/textures/floor/platform.png")
    if successPlatform then
        texturaPlataforma = platformImg
        texturaPlataforma:setFilter("nearest", "nearest")
    else
        print("Advertencia: No se encontró la textura de la plataforma en Assets/textures/floor/platform.png")
    end

    -- Cargar imágenes PRE y POS para pantallas de nivel
    local function tryLoadVariants(base)
        local paths = {
            "Assets/background/" .. base .. ".png",
            "Assets/background/" .. base .. ".jpg",
            "Assets/background/" .. base .. ".jpeg"
        }
        for _, p in ipairs(paths) do
            local ok, img = pcall(love.graphics.newImage, p)
            if ok then return img end
        end
        return nil
    end

    texturaPRE = tryLoadVariants("PRELVL")
    if texturaPRE then texturaPRE:setFilter("linear", "linear") end
    texturaPOS = tryLoadVariants("POSLVL")
    if texturaPOS then texturaPOS:setFilter("linear", "linear") end

    -- Cargar textura de compuerta (alta y delgada)
    local successDoor, doorImg = pcall(love.graphics.newImage, "Assets/textures/door/door.png")
    if successDoor then
        texturaCompuerta = doorImg
        texturaCompuerta:setFilter("nearest", "nearest")
    else
        print("Advertencia: No se encontró la textura de la compuerta en Assets/textures/door/door.png")
    end

    local successIdle, idleImg = pcall(love.graphics.newImage, "Assets/characters/IDLE.png")
    if successIdle then
        texturaEspirituIdle = idleImg
        texturaEspirituIdle:setFilter("nearest", "nearest")
    else
        print("Advertencia: No se encontró la textura del personaje Idle en Assets/characters/IDLE.png")
    end

    local successAir, airImg = pcall(love.graphics.newImage, "Assets/characters/air.png")
    if successAir then
        texturaEspirituAir = airImg
        texturaEspirituAir:setFilter("nearest", "nearest")
    else
        print("Advertencia: No se encontró la textura del personaje Air en Assets/characters/air.png")
    end

    local successLeft, leftImg = pcall(love.graphics.newImage, "Assets/characters/mleft.png")
    if successLeft then
        texturaEspirituMLeft = leftImg
        texturaEspirituMLeft:setFilter("nearest", "nearest")
    else
        print("Advertencia: No se encontró la textura del personaje MLeft en Assets/characters/mleft.png")
    end

    local successRight, rightImg = pcall(love.graphics.newImage, "Assets/characters/mright.png")
    if successRight then
        texturaEspirituMRight = rightImg
        texturaEspirituMRight:setFilter("nearest", "nearest")
    else
        print("Advertencia: No se encontró la textura del personaje MRight en Assets/characters/mright.png")
    end

    for i = 1, 3 do
        local successEnemy, enemyImg = pcall(love.graphics.newImage, "Assets/characters/enemy/" .. i .. ".png")
        if successEnemy then
            texturaEnemigoFrames[i] = enemyImg
            enemyImg:setFilter("nearest", "nearest")
        else
            print("Advertencia: No se encontró la textura del enemigo " .. i .. " en Assets/characters/enemy/" .. i .. ".png")
        end
    end

    local successEnemyRage, enemyRageImg = pcall(love.graphics.newImage, "Assets/characters/enemy/RAGE.png")
    if successEnemyRage then
        texturaEnemigoRage = enemyRageImg
        texturaEnemigoRage:setFilter("nearest", "nearest")
    else
        print("Advertencia: No se encontró la textura RAGE del enemigo en Assets/characters/enemy/RAGE.png")
    end

    resetLevel()
end

-- 2. LÓGICA DEL JUEGO
function love.update(dt)
    if gameState ~= "playing" then
        return
    end

    -- Actualizar el tiempo del nivel
    tiempoNivel = tiempoNivel + dt

    if love.keyboard.isDown("r") then
        resetLevel()
    end

    -- Animación de la Carta Flotando
    if carta.activa then
        carta.floatTimer = carta.floatTimer + dt
        -- math.sin oscila suavemente. El multiplicador de adentro ajusta la velocidad, y el de afuera la altura (amplitud)
        carta.y = carta.baseY + math.sin(carta.floatTimer * 4) * 6
    end

    -- Movimiento Horizontal
    local dx = 0
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        dx = espiritu.velocidad * dt
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        dx = -espiritu.velocidad * dt
    end

    local nextX = espiritu.x + dx
    if compuerta.activa and dx ~= 0 then
        if dx > 0 and espiritu.x + espiritu.ancho <= compuerta.x and nextX + espiritu.ancho > compuerta.x then
            dx = 0
        elseif dx < 0 and espiritu.x >= compuerta.x + compuerta.ancho and nextX < compuerta.x + compuerta.ancho then
            dx = 0
        end
    end
    if compuerta2.activa and dx ~= 0 then
        if dx > 0 and espiritu.x + espiritu.ancho <= compuerta2.x and nextX + espiritu.ancho > compuerta2.x then
            dx = 0
        elseif dx < 0 and espiritu.x >= compuerta2.x + compuerta2.ancho and nextX < compuerta2.x + compuerta2.ancho then
            dx = 0
        end
    end
    espiritu.x = espiritu.x + dx
    
    -- Limitar al jugador dentro del mundo
    espiritu.x = math.max(0, math.min(worldWidth - espiritu.ancho, espiritu.x))

    -- Aplicar gravedad y movimiento vertical
    espiritu.velocidadY = espiritu.velocidadY + gravedad * dt
    espiritu.y = espiritu.y + espiritu.velocidadY * dt

    local sobreBloque = false
    for _, bloque in ipairs(bloques) do
        if espiritu.x + espiritu.ancho > bloque.x and
           espiritu.x < bloque.x + bloque.ancho and
           espiritu.y + espiritu.alto >= bloque.y and
           espiritu.y + espiritu.alto <= bloque.y + bloque.alto + 5 and
           espiritu.velocidadY >= 0 then
            espiritu.y = bloque.y - espiritu.alto
            espiritu.velocidadY = 0
            espiritu.enSuelo = true
            sobreBloque = true
        end
    end

    if not sobreBloque then
        local groundTop = 320 - espiritu.alto
        if espiritu.y >= groundTop then
            espiritu.y = groundTop
            espiritu.velocidadY = 0
            espiritu.enSuelo = true
        else
            espiritu.enSuelo = false
        end
    end

    -- Lógica de Salto
    if love.keyboard.isDown("space") and espiritu.enSuelo then
        espiritu.velocidadY = -espiritu.fuerzaSalto
        espiritu.enSuelo = false
    end

    -- Estado del personaje para dibujar la textura correcta
    if not espiritu.enSuelo then
        espiritu.state = "air"
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        espiritu.state = "right"
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        espiritu.state = "left"
    else
        espiritu.state = "idle"
    end

    -- Colisión con la Carta
    if carta.activa and
       espiritu.x < carta.x + carta.ancho and
       espiritu.x + espiritu.ancho > carta.x and
       espiritu.y < carta.y + carta.alto and
       espiritu.y + espiritu.alto > carta.y then
        espiritu.tieneCarta = true
        carta.activa = false
    end

    -- Lógica del Enemigo: Cono de Visión y Estado de Alerta
    do
        local ex = enemigo.x + enemigo.ancho/2
        local ey = enemigo.y + enemigo.alto/2
        local px = espiritu.x + espiritu.ancho / 2
        local py = espiritu.y + espiritu.alto / 2
        local dx2 = px - ex
        local dy2 = py - ey
        local dist = math.sqrt(dx2*dx2 + dy2*dy2)
        local angleToPlayer = 0
        local seen = false
        
        if dist > 0 and dist <= enemigo.rango then
            angleToPlayer = math.atan2(dy2, dx2)
            local diff = math.abs((angleToPlayer - enemigo.dir + math.pi) % (2*math.pi) - math.pi)
            if diff <= enemigo.angulo and not isLineBlocked(ex, ey, px, py) then
                seen = true
            end
        end

        if seen then
            if not enemigo.alerta then
                sonidoAlerta:stop()
                sonidoAlerta:play()
                enemigo.rageTimer = 1
                enemigo.animTimer = 0
                enemigo.animFrame = 1
                local dirX = (espiritu.x + espiritu.ancho / 2 > enemigo.x + enemigo.ancho / 2) and 1 or -1
                enemigo.dir = dirX == 1 and 0 or math.pi
            end
            
            enemigo.alerta = true
            enemigo.alertTimer = enemigo.alertTimer + dt
            enemigo.chaseTimeLeft = 2
            
            if enemigo.alertTimer >= 3 then
                sonidoDerrota:stop()
                sonidoDerrota:play()
                resetLevel()
            end
        else
            if enemigo.chaseTimeLeft > 0 then
                enemigo.chaseTimeLeft = enemigo.chaseTimeLeft - dt
                enemigo.alertTimer = 0 
                if enemigo.chaseTimeLeft <= 0 then
                    enemigo.alerta = false
                end
            else
                enemigo.alerta = false
                enemigo.alertTimer = 0
            end
        end
    end

    -- Movimiento del Enemigo
    if enemigo.alerta then
        if enemigo.rageTimer <= 0 then
            local dirX = (espiritu.x + espiritu.ancho / 2 > enemigo.x + enemigo.ancho/2) and 1 or -1
            enemigo.x = enemigo.x + dirX * enemigo.velocidadCaza * dt
            enemigo.dir = dirX == 1 and 0 or math.pi
        end
    else
        if enemigo.x < enemigo.patrol.min then
            enemigo.patrol.vel = math.abs(enemigo.patrol.vel) 
        elseif enemigo.x > enemigo.patrol.max then
            enemigo.patrol.vel = -math.abs(enemigo.patrol.vel) 
        end
        
        enemigo.x = enemigo.x + enemigo.patrol.vel * dt
        enemigo.dir = enemigo.patrol.vel >= 0 and 0 or math.pi
    end
    
    enemigo.x = math.max(0, math.min(worldWidth - enemigo.ancho, enemigo.x))

    do
        local ex = enemigo2.x + enemigo2.ancho/2
        local ey = enemigo2.y + enemigo2.alto/2
        local px = espiritu.x + espiritu.ancho / 2
        local py = espiritu.y + espiritu.alto / 2
        local dx2 = px - ex
        local dy2 = py - ey
        local dist = math.sqrt(dx2*dx2 + dy2*dy2)
        local angleToPlayer = 0
        local seen = false

        if dist > 0 and dist <= enemigo2.rango then
            angleToPlayer = math.atan2(dy2, dx2)
            local diff = math.abs((angleToPlayer - enemigo2.dir + math.pi) % (2*math.pi) - math.pi)
            if diff <= enemigo2.angulo and not isLineBlocked(ex, ey, px, py) then
                seen = true
            end
        end

        if seen then
            if not enemigo2.alerta then
                sonidoAlerta:stop()
                sonidoAlerta:play()
                enemigo2.rageTimer = 1
                enemigo2.animTimer = 0
                enemigo2.animFrame = 1
                local dirX2 = (espiritu.x + espiritu.ancho / 2 > enemigo2.x + enemigo2.ancho / 2) and 1 or -1
                enemigo2.dir = dirX2 == 1 and 0 or math.pi
            end

            enemigo2.alerta = true
            enemigo2.alertTimer = enemigo2.alertTimer + dt
            enemigo2.chaseTimeLeft = 2

            if enemigo2.alertTimer >= 3 then
                sonidoDerrota:stop()
                sonidoDerrota:play()
                resetLevel()
            end
        else
            if enemigo2.chaseTimeLeft > 0 then
                enemigo2.chaseTimeLeft = enemigo2.chaseTimeLeft - dt
                enemigo2.alertTimer = 0
                if enemigo2.chaseTimeLeft <= 0 then
                    enemigo2.alerta = false
                end
            else
                enemigo2.alerta = false
                enemigo2.alertTimer = 0
            end
        end
    end

    if enemigo2.alerta then
        if enemigo2.rageTimer <= 0 then
            local dirX2 = (espiritu.x + espiritu.ancho / 2 > enemigo2.x + enemigo2.ancho/2) and 1 or -1
            enemigo2.x = enemigo2.x + dirX2 * enemigo2.velocidadCaza * dt
            enemigo2.dir = dirX2 == 1 and 0 or math.pi
        end
    else
        if enemigo2.x < enemigo2.patrol.min then
            enemigo2.patrol.vel = math.abs(enemigo2.patrol.vel)
        elseif enemigo2.x > enemigo2.patrol.max then
            enemigo2.patrol.vel = -math.abs(enemigo2.patrol.vel)
        end
        enemigo2.x = enemigo2.x + enemigo2.patrol.vel * dt
        enemigo2.dir = enemigo2.patrol.vel >= 0 and 0 or math.pi
    end

    enemigo2.x = math.max(0, math.min(worldWidth - enemigo2.ancho, enemigo2.x))

    updateEnemyAnimation(enemigo, dt)
    updateEnemyAnimation(enemigo2, dt)

    -- Entregar la carta en la meta (Victoria)
    if espiritu.tieneCarta and
       espiritu.x < meta.x + meta.ancho and
       espiritu.x + espiritu.ancho > meta.x and
       espiritu.y < meta.y + meta.alto and
       espiritu.y + espiritu.alto > meta.y then
        completeLevel()
    end

    -- Detección colisión con enemigo
    if espiritu.x < enemigo.x + enemigo.ancho and
       espiritu.x + espiritu.ancho > enemigo.x and
       espiritu.y < enemigo.y + enemigo.alto and
       espiritu.y + espiritu.alto > enemigo.y then
        sonidoDerrota:stop()
        sonidoDerrota:play()
        resetLevel()
    end

    if espiritu.x < enemigo2.x + enemigo2.ancho and
       espiritu.x + espiritu.ancho > enemigo2.x and
       espiritu.y < enemigo2.y + enemigo2.alto and
       espiritu.y + espiritu.alto > enemigo2.y then
        sonidoDerrota:stop()
        sonidoDerrota:play()
        resetLevel()
    end

    -- Activación de la placa de presión (queda pisada permanentemente al tocarse una vez)
    local onInterruptor = (espiritu.x + espiritu.ancho > interruptor.x) and
                          (espiritu.x < interruptor.x + interruptor.ancho) and
                          (espiritu.y + espiritu.alto > interruptor.y) and
                          (espiritu.y < interruptor.y + interruptor.alto)
    if onInterruptor then
        interruptor.pisada = true
    end
    local onInterruptor2 = (espiritu.x + espiritu.ancho > interruptor2.x) and
                           (espiritu.x < interruptor2.x + interruptor2.ancho) and
                           (espiritu.y + espiritu.alto > interruptor2.y) and
                           (espiritu.y < interruptor2.y + interruptor2.alto)
    if onInterruptor2 then
        interruptor2.pisada = true
    end
    compuerta.activa = not interruptor.pisada
    compuerta2.activa = not interruptor2.pisada

    -- Animación de la meta
    if meta.frames and #meta.frames > 0 then
        meta.colorTimer = meta.colorTimer + dt * 0.35
        if meta.frameCount > 1 then
            meta.frameTimer = meta.frameTimer + dt
            if meta.frameTimer >= meta.frameDuration then
                meta.frameTimer = meta.frameTimer - meta.frameDuration
                meta.currentFrame = meta.currentFrame % meta.frameCount + 1
            end
        end
    end
end

-- 3. RENDERIZADO (DIBUJAR EN PANTALLA)
local function drawMenu()
    love.graphics.clear(0.08, 0.08, 0.12)
    drawStyledPrintf("EXHALARE", titleFont, 0, 80, love.graphics.getWidth(), "center", 0.98, 0.96, 0.9, 1)

    local labels = {"Jugar", "Ajustes", "Salir"}

    love.graphics.setFont(buttonFont)
    for i, option in ipairs(labels) do
        local x, y, w, h = getMenuButtonRect(i)
        love.graphics.setColor(0.16, 0.18, 0.22)
        love.graphics.rectangle("fill", x, y, w, h, 12, 12)
        drawStyledPrintf(option, buttonFont, x, y + 14, w, "center", 0.95, 0.95, 0.95, 1)
    end

    drawStyledPrintf("El progreso se guarda automáticamente", smallFont, 0, love.graphics.getHeight() - 60, love.graphics.getWidth(), "center", 0.78, 0.78, 0.85, 1)
end

local function drawLevelSelect()
    love.graphics.clear(0.08, 0.08, 0.12)
    drawStyledPrintf("Selecciona un nivel", titleFont, 0, 70, love.graphics.getWidth(), "center", 0.98, 0.96, 0.9, 1)

    local levels = {
        {label = "Nivel 1", levelNumber = 1, unlocked = true},
        {label = unlockedLevel >= 2 and "Nivel 2" or "Nivel 2 (bloqueado)", levelNumber = 2, unlocked = unlockedLevel >= 2}
    }

    love.graphics.setFont(buttonFont)
    for i, level in ipairs(levels) do
        local x, y, w, h = getMenuButtonRect(i)
        love.graphics.setColor(level.unlocked and 0.16 or 0.28, level.unlocked and 0.18 or 0.25, level.unlocked and 0.22 or 0.28)
        love.graphics.rectangle("fill", x, y, w, h, 12, 12)
        love.graphics.setColor(0.9, 0.9, 0.9)
        drawStyledPrintf(level.label, buttonFont, x, y + 14, w, "center", 0.95, 0.95, 0.95, 1)
    end

    drawStyledPrintf("Pulsa ESC para volver", smallFont, 0, love.graphics.getHeight() - 60, love.graphics.getWidth(), "center", 0.78, 0.78, 0.85, 1)
end

local function drawSettings()
    love.graphics.clear(0.08, 0.08, 0.12)
    drawStyledPrintf("Ajustes", titleFont, 0, 80, love.graphics.getWidth(), "center", 0.98, 0.96, 0.9, 1)

    local resolution = resolutions[settings.resolutionIndex]
    local rects = getSettingsArrowRects()

    love.graphics.setColor(0.16, 0.18, 0.22)
    love.graphics.rectangle("fill", rects.volLeft.x, rects.volLeft.y, rects.volLeft.w, rects.volLeft.h, 8, 8)
    love.graphics.rectangle("fill", rects.volRight.x, rects.volRight.y, rects.volRight.w, rects.volRight.h, 8, 8)
    love.graphics.rectangle("fill", rects.resLeft.x, rects.resLeft.y, rects.resLeft.w, rects.resLeft.h, 8, 8)
    love.graphics.rectangle("fill", rects.resRight.x, rects.resRight.y, rects.resRight.w, rects.resRight.h, 8, 8)

    love.graphics.setColor(0.95, 0.95, 0.95)
    drawArrow(rects.volLeft.x, rects.volLeft.y, rects.volLeft.w, "left")
    drawArrow(rects.volRight.x, rects.volRight.y, rects.volRight.w, "right")
    drawArrow(rects.resLeft.x, rects.resLeft.y, rects.resLeft.w, "left")
    drawArrow(rects.resRight.x, rects.resRight.y, rects.resRight.w, "right")

    drawStyledPrintf(string.format("Volumen: %d%%", math.floor(settings.volume * 100 + 0.5)), buttonFont, 0, 220, love.graphics.getWidth(), "center", 0.95, 0.95, 0.95, 1)
    drawStyledPrintf(string.format("Resolución: %dx%d", resolution[1], resolution[2]), buttonFont, 0, 260, love.graphics.getWidth(), "center", 0.95, 0.95, 0.95, 1)

    drawStyledPrintf("Pulsa ESC para volver al menú", smallFont, 0, love.graphics.getHeight() - 60, love.graphics.getWidth(), "center", 0.78, 0.78, 0.85, 1)
end

function love.draw()
    if gameState == "menu" then
        drawMenu()
        return
    elseif gameState == "levelSelect" then
        drawLevelSelect()
        return
    elseif gameState == "settings" then
        drawSettings()
        return
    elseif gameState == "preLevel" then
        -- Dibujar pantalla previa con imagen difuminada y texto según el nivel pendiente
        local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
        love.graphics.push()
        love.graphics.origin()
        if texturaPRE then
            local sx = screenW / texturaPRE:getWidth()
            local sy = screenH / texturaPRE:getHeight()
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(texturaPRE, 0, 0, 0, sx, sy)
        else
            love.graphics.clear(0.08, 0.08, 0.12)
        end
        love.graphics.setColor(0,0,0,0.45)
        love.graphics.rectangle("fill", 0, 0, screenW, screenH)

        love.graphics.setColor(1,1,1,1)
        -- usar fuentes más pequeñas para evitar solapamiento en PRE
        love.graphics.setFont(buttonFont)
        local titleY = screenH * 0.08
        local bodyY = screenH * 0.22
        local bodyW = screenW - 200
        if pendingLevelToStart == 1 then
            drawStyledPrintf("El despertar de las ruinas del silencio", buttonFont, 0, titleY, screenW, "center", 0.98,0.96,0.9,1)
            love.graphics.setFont(smallFont)
            local text = [[
Naces del último aliento de un mundo que se apaga, un espíritu errante hecho de viento en un vasto cementerio de acero frío y engranajes. Al materializarte en los límites de una imponente ciudad tecnológica en ruinas, el aire se siente denso y pesado, desprovisto de palabras. Los algoritmos de las máquinas han silenciado el pulso de la humanidad, y los pocos corazones de carne que quedan están al borde del olvido total, perdiendo la capacidad de comunicarse y de recordar quiénes son. Tu existencia tiene un propósito urgente: cruzar este páramo hostil antes de que el silencio sea absoluto y la última chispa de conexión humana se extinga para siempre. Guiado por la brisa, avanzas entre las sombras de las estructuras metálicas, esquivando las frías miradas de los vigilantes mecánicos, listo para rescatar la esencia de la vida.
            ]]
            drawStyledPrintf(text, smallFont, 100, bodyY, bodyW, "center", 0.92,0.96,1,1)
        else
            drawStyledPrintf("El Eco del labor incesante", buttonFont, 0, titleY, screenW, "center", 0.98,0.96,0.9,1)
            love.graphics.setFont(smallFont)
            local text2 = [[
El camino se vuelve más estrecho y la vigilancia se intensifica a medida que te adentras en los sectores más profundos del complejo industrial. Aunque has logrado sortear los primeros peligros y llevar los primeros fragmentos de memoria a manos temblorosas, la tarea apenas comienza y el peso del olvido sigue cubriendo el planeta. Como espíritu del viento, entiendes que tu labor no se detiene con una sola entrega; el pulso de la humanidad sigue siendo débil y las corrientes de aire te exigen continuar sin descanso. Nuevas barreras de acero y patrullas robóticas más estrictas bloquean el horizonte, pero la calidez de los recuerdos que transportas es el único motor capaz de desafiar la eficiencia de las máquinas. Con el viento a tu favor, te preparas para navegar las corrientes más hostiles, decidido a que ningún corazón se quede sin exhalar su propia historia.
            ]]
            drawStyledPrintf(text2, smallFont, 100, bodyY, bodyW, "center", 0.92,0.96,1,1)
        end

        drawStyledPrintf("Presiona cualquier tecla o clic para continuar", smallFont, 0, screenH * 0.86, screenW, "center", 0.85,0.85,0.9,1)
        love.graphics.pop()
        return
    end

    -- --- INICIO DEL ESCALADO DINÁMICO ---
    love.graphics.push()
    
    local baseWidth, baseHeight = 800, 600
    local scaleX = love.graphics.getWidth() / baseWidth
    local scaleY = love.graphics.getHeight() / baseHeight
    love.graphics.scale(scaleX, scaleY)

    local screenLeft = cameraX
    local screenRight = cameraX + baseWidth
    local playerCenterX = espiritu.x + espiritu.ancho / 2
    local margin = 180

    if playerCenterX < screenLeft + margin then
        cameraX = math.max(0, playerCenterX - margin)
    elseif playerCenterX > screenRight - margin then
        cameraX = math.min(worldWidth - baseWidth, playerCenterX - (baseWidth - margin))
    end

    cameraX = math.max(0, math.min(worldWidth - baseWidth, cameraX))
    love.graphics.translate(-cameraX, -cameraY)
    -- ------------------------------------

    -- 1. DIBUJAR EL FONDO PRIMERO
    if fondoNivel then
        love.graphics.setColor(0.3, 0.3, 0.3, 1) 
        local bgScaleX = (worldWidth / fondoNivel:getWidth())
        local bgScaleY = baseHeight / fondoNivel:getHeight()
        love.graphics.draw(fondoNivel, 0, 0, 0, bgScaleX, bgScaleY)
    end

    -- Restablecer el color a blanco antes de dibujar los demás elementos
    love.graphics.setColor(1, 1, 1, 1)

    -- Dibujar el suelo superior con la textura de la superficie
    local tileSize = 40
    drawTiledTexture(texturaSueloSuperficie, 0, 320, worldWidth, tileSize, tileSize)

    -- Dibujar el resto del suelo con la textura inferior
    drawTiledTexture(texturaSueloBase, 0, 320 + tileSize, worldWidth, worldHeight - 320 - tileSize, tileSize)

    -- Dibujar las plataformas flotantes con la textura de plataforma
    for _, bloque in ipairs(bloques) do
        drawTiledTexture(texturaPlataforma, bloque.x, bloque.y, bloque.ancho, bloque.alto, tileSize)
    end

    -- Dibujar al Espíritu
    local playerTexture = nil
    if espiritu.state == "air" then
        playerTexture = texturaEspirituAir
    elseif espiritu.state == "left" then
        playerTexture = texturaEspirituMLeft
    elseif espiritu.state == "right" then
        playerTexture = texturaEspirituMRight
    else
        playerTexture = texturaEspirituIdle
    end

    if playerTexture then
        love.graphics.setColor(1, 1, 1, 1)
        local texW, texH = playerTexture:getDimensions()
        love.graphics.draw(playerTexture, espiritu.x + espiritu.ancho / 2, espiritu.y + espiritu.alto / 2, 0, espiritu.ancho / texW, espiritu.alto / texH, texW / 2, texH / 2)
    else
        love.graphics.setColor(0, 1, 1)
        love.graphics.rectangle("fill", espiritu.x, espiritu.y, espiritu.ancho, espiritu.alto)
    end

    -- Dibujar la Carta
    if carta.activa then
        local centerX = carta.x + carta.ancho / 2
        local centerY = carta.y + carta.alto / 2
        if texturaCarta then
            local texW, texH = texturaCarta:getDimensions()
            local scale = math.min(carta.ancho / texW, carta.alto / texH)

            love.graphics.setBlendMode("alpha")
            love.graphics.setColor(1, 1, 1, 0.18)
            love.graphics.circle("fill", centerX, centerY - 2, math.max(carta.ancho, carta.alto) * 1.2)
            love.graphics.setColor(1, 1, 1, 0.10)
            love.graphics.circle("fill", centerX, centerY - 2, math.max(carta.ancho, carta.alto) * 1.6)
            love.graphics.setColor(1, 1, 1, 0.06)
            love.graphics.circle("fill", centerX, centerY - 2, math.max(carta.ancho, carta.alto) * 2.0)

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(texturaCarta, centerX, centerY, 0, scale, scale, texW / 2, texH / 2)
            love.graphics.setBlendMode("alpha")
        else
            love.graphics.setColor(1, 1, 0)
            love.graphics.rectangle("fill", carta.x, carta.y, carta.ancho, carta.alto)
        end
    end

    -- Dibujar la Meta
    if meta.frames and #meta.frames > 0 then
        local mScaleX = meta.ancho / meta.frameWidth
        local mScaleY = meta.alto / meta.frameHeight
        local r = 0.55 + 0.35 * math.sin(meta.colorTimer)
        local g = 0.55 + 0.3 * math.sin(meta.colorTimer + 2.1)
        local b = 0.75 + 0.25 * math.sin(meta.colorTimer + 4.2)
        for _, frameImage in ipairs(meta.frames) do
            love.graphics.setColor(r, g, b, 0.2)
            love.graphics.draw(frameImage, meta.x + meta.ancho / 2, meta.y + meta.alto / 2, 0, mScaleX, mScaleY, meta.frameWidth / 2, meta.frameHeight / 2)
        end
        love.graphics.setColor(r, g, b, 1)
        love.graphics.draw(meta.frames[meta.currentFrame], meta.x + meta.ancho / 2, meta.y + meta.alto / 2, 0, mScaleX, mScaleY, meta.frameWidth / 2, meta.frameHeight / 2)
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- Dibujar al Enemigo
    local function drawEnemy(enemy)
        local texture = nil
        if enemy.rageTimer > 0 and texturaEnemigoRage then
            texture = texturaEnemigoRage
        else
            texture = texturaEnemigoFrames[enemy.animFrame]
        end

        if texture then
            love.graphics.setColor(1, 1, 1, 1)
            local texW, texH = texture:getDimensions()
            local scaleX = enemy.ancho / texW
            local scaleY = enemy.alto / texH
            if enemy.dir == math.pi then
                scaleX = -scaleX
            end
            love.graphics.draw(texture, enemy.x + enemy.ancho / 2, enemy.y + enemy.alto / 2, 0, scaleX, scaleY, texW / 2, texH / 2)
        else
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.ancho, enemy.alto)
        end
    end

    drawEnemy(enemigo)
    drawEnemy(enemigo2)

    local function drawVisionCone(enemy)
        local ex = enemy.x + enemy.ancho / 2
        local ey = enemy.y + enemy.alto / 2
        local segments = 20
        local points = {ex, ey}
        local startAngle = enemy.dir - enemy.angulo
        local endAngle = enemy.dir + enemy.angulo
        for i = 0, segments do
            local t = i / segments
            local angle = startAngle + (endAngle - startAngle) * t
            local dx = math.cos(angle)
            local dy = math.sin(angle)
            local dist = getObstacleDistance(ex, ey, dx, dy, enemy.rango)
            table.insert(points, ex + dx * dist)
            table.insert(points, ey + dy * dist)
        end
        love.graphics.setColor(1, 0, 0.4, 0.25)
        love.graphics.polygon("fill", points)
    end

    drawVisionCone(enemigo)
    drawVisionCone(enemigo2)

    -- Dibujar la compuerta
    if texturaCompuerta then
        love.graphics.setColor(1,1,1,1)
        local texW, texH = texturaCompuerta:getDimensions()
        local sx = compuerta.ancho / texW
        local sy = compuerta.alto / texH
        love.graphics.draw(texturaCompuerta, compuerta.x + compuerta.ancho/2, compuerta.y + compuerta.alto/2, 0, sx, sy, texW/2, texH/2)
    else
        if compuerta.activa then
            love.graphics.setColor(0.4, 0.4, 0.8, 1)
        else
            love.graphics.setColor(0.2, 0.6, 0.2, 1)
        end
        love.graphics.rectangle("fill", compuerta.x, compuerta.y, compuerta.ancho, compuerta.alto)
    end

    if texturaCompuerta then
        love.graphics.setColor(1,1,1,1)
        local texW2, texH2 = texturaCompuerta:getDimensions()
        local sx2 = compuerta2.ancho / texW2
        local sy2 = compuerta2.alto / texH2
        love.graphics.draw(texturaCompuerta, compuerta2.x + compuerta2.ancho/2, compuerta2.y + compuerta2.alto/2, 0, sx2, sy2, texW2/2, texH2/2)
    else
        if compuerta2.activa then
            love.graphics.setColor(0.4, 0.4, 0.8, 1)
        else
            love.graphics.setColor(0.2, 0.6, 0.2, 1)
        end
        love.graphics.rectangle("fill", compuerta2.x, compuerta2.y, compuerta2.ancho, compuerta2.alto)
    end

    -- Dibujar la placa de presión (usar textura si está disponible). Cuando se pisa, se hunde ligeramente en el suelo.
    if texturaPuzzle then
        local imgW, imgH = texturaPuzzle:getDimensions()
        local targetW = interruptor.ancho * 2.8
        local targetH = interruptor.alto * 2.2
        local sx = targetW / imgW
        local sy = targetH / imgH
        local sinkPixels = interruptor.pisada and 4 or 0
        local drawX = interruptor.x + interruptor.ancho / 2
        local extraDown = 20
        local drawY = interruptor.y + interruptor.alto - (imgH / 2) * sy + sinkPixels + extraDown
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(texturaPuzzle, drawX, drawY, 0, sx, sy, imgW / 2, imgH / 2)

        local imgW2, imgH2 = texturaPuzzle:getDimensions()
        local targetW2 = interruptor2.ancho * 2.8
        local targetH2 = interruptor2.alto * 2.2
        local sx2 = targetW2 / imgW2
        local sy2 = targetH2 / imgH2
        local sinkPixels2 = interruptor2.pisada and 4 or 0
        local drawX2 = interruptor2.x + interruptor2.ancho / 2
        local drawY2 = interruptor2.y + interruptor2.alto - (imgH2 / 2) * sy2 + sinkPixels2 + extraDown
        love.graphics.draw(texturaPuzzle, drawX2, drawY2, 0, sx2, sy2, imgW2 / 2, imgH2 / 2)
    else
        if interruptor.pisada then
            love.graphics.setColor(0.8, 0.8, 0.2)
        else
            love.graphics.setColor(0.8, 0.4, 0.1)
        end
        love.graphics.rectangle("fill", interruptor.x, interruptor.y, interruptor.ancho, interruptor.alto)

        if interruptor2.pisada then
            love.graphics.setColor(0.8, 0.8, 0.2)
        else
            love.graphics.setColor(0.8, 0.4, 0.1)
        end
        love.graphics.rectangle("fill", interruptor2.x, interruptor2.y, interruptor2.ancho, interruptor2.alto)
    end

    -- Interfaz de texto (fija en pantalla)
    love.graphics.pop()

    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)
    love.graphics.setFont(smallFont)
    love.graphics.setColor(1, 1, 1, 1)

    local uiX, uiY = 10, 8
    if espiritu.tieneCarta then
        drawStyledPrint("Objetivo: Lleva la carta a la meta", smallFont, uiX, uiY, 0.96,0.96,0.9,1)
    else
        drawStyledPrint("Objetivo: Encuentra la carta", smallFont, uiX, uiY, 0.96,0.96,0.9,1)
    end
    drawStyledPrint("Presiona R para reiniciar", smallFont, uiX, uiY + 16, 0.9,0.9,0.95,1)
    drawStyledPrint("Tiempo: " .. string.format("%.2f", tiempoNivel) .. "s", smallFont, uiX, uiY + 32, 0.9,0.9,0.95,1)

    if enemigo.alerta or enemigo2.alerta then
        love.graphics.setColor(1, 0, 0, 1)
        if enemigo.alerta and enemigo2.alerta then
            drawStyledPrint("¡Ambos enemigos te detectaron!", smallFont, uiX, uiY + 48, 1,0.6,0.6,1)
        elseif enemigo2.alerta then
            drawStyledPrint("¡Segundo enemigo persiguiéndote!", smallFont, uiX, uiY + 48, 1,0.6,0.6,1)
        else
            drawStyledPrint("¡Enemigo persiguiéndote!", smallFont, uiX, uiY + 48, 1,0.6,0.6,1)
        end
    end

    love.graphics.pop()

    if gameState == "levelComplete" then
        local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
        love.graphics.push()
        love.graphics.origin()
        if texturaPOS then
            local sx = screenW / texturaPOS:getWidth()
            local sy = screenH / texturaPOS:getHeight()
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(texturaPOS, 0, 0, 0, sx, sy)
        else
            love.graphics.setColor(0, 0, 0, 0.7)
            love.graphics.rectangle("fill", 0, 0, screenW, screenH)
        end
        -- overlay difuminado
        love.graphics.setColor(0,0,0,0.35)
        love.graphics.rectangle("fill", 0, 0, screenW, screenH)

        love.graphics.setColor(1, 1, 1, 1)
        drawStyledPrintf("¡Nivel completado!", titleFont, 0, screenH * 0.2, screenW, "center", 0.98,0.96,0.9,1)

        drawStyledPrintf("Pasaste el nivel " .. currentLevel .. "", buttonFont, 0, screenH * 0.34, screenW, "center", 0.95,0.95,0.95,1)
        drawStyledPrintf("Tiempo: " .. string.format("%.2f", levelCompleteTime) .. "s", buttonFont, 0, screenH * 0.40, screenW, "center", 0.95,0.95,0.95,1)

        local buttonW, buttonH = 220, 48
        local buttonX, buttonY = (screenW - buttonW) / 2, screenH * 0.62
        love.graphics.setColor(0.16, 0.18, 0.22)
        love.graphics.rectangle("fill", buttonX, buttonY, buttonW, buttonH, 10, 10)
        drawStyledPrintf("Continuar", buttonFont, buttonX, buttonY + 12, buttonW, "center", 0.95,0.95,0.95,1)
        love.graphics.pop()
    end
end

function love.mousepressed(x, y, button)
    if gameState == "menu" and button == 1 then
        local labels = {"Jugar", "Ajustes", "Salir"}

        for i, option in ipairs(labels) do
            local bx, by, bw, bh = getMenuButtonRect(i)
            if isMouseInRect(x, y, bx, by, bw, bh) then
                if i == 1 then
                    gameState = "levelSelect"
                elseif i == 2 then
                    gameState = "settings"
                elseif i == 3 then
                    love.event.quit()
                end
            end
        end
    elseif gameState == "levelSelect" and button == 1 then
        local levels = {
            {levelNumber = 1, unlocked = true},
            {levelNumber = 2, unlocked = unlockedLevel >= 2}
        }

        for i, level in ipairs(levels) do
            local bx, by, bw, bh = getMenuButtonRect(i)
            if isMouseInRect(x, y, bx, by, bw, bh) and level.unlocked then
                startLevel(level.levelNumber)
                break
            end
        end
    elseif gameState == "settings" and button == 1 then
        local rects = getSettingsArrowRects()
        if isMouseInRect(x, y, rects.volLeft.x, rects.volLeft.y, rects.volLeft.w, rects.volLeft.h) then
            settings.volume = math.max(0, settings.volume - 0.1)
            love.audio.setVolume(settings.volume)
            saveProgress()
        elseif isMouseInRect(x, y, rects.volRight.x, rects.volRight.y, rects.volRight.w, rects.volRight.h) then
            settings.volume = math.min(1, settings.volume + 0.1)
            love.audio.setVolume(settings.volume)
            saveProgress()
        elseif isMouseInRect(x, y, rects.resLeft.x, rects.resLeft.y, rects.resLeft.w, rects.resLeft.h) then
            setResolution(settings.resolutionIndex - 1)
            saveProgress()
        elseif isMouseInRect(x, y, rects.resRight.x, rects.resRight.y, rects.resRight.w, rects.resRight.h) then
            setResolution(settings.resolutionIndex + 1)
            saveProgress()
        end
    elseif gameState == "levelComplete" and button == 1 then
        local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
        local buttonW, buttonH = 220, 48
        local buttonX, buttonY = (screenW - buttonW) / 2, screenH * 0.62
        if isMouseInRect(x, y, buttonX, buttonY, buttonW, buttonH) then
            continueFromVictory()
        end
    elseif gameState == "preLevel" and button == 1 then
        if pendingLevelToStart then
            beginLevel(pendingLevelToStart)
            pendingLevelToStart = nil
        end
    end
end

function love.keypressed(key)
    if gameState == "menu" then
        if key == "return" or key == "kpenter" then
            gameState = "levelSelect"
        elseif key == "escape" then
            love.event.quit()
        end
    elseif gameState == "levelSelect" then
        if key == "escape" then
            gameState = "menu"
        elseif key == "1" then
            startLevel(1)
        elseif key == "2" and unlockedLevel >= 2 then
            startLevel(2)
        end
    elseif gameState == "preLevel" then
        if pendingLevelToStart then
            beginLevel(pendingLevelToStart)
            pendingLevelToStart = nil
        end
    elseif gameState == "playing" then
        if key == "escape" then
            gameState = "menu"
            musicaNivel1:pause()
            musicaNivel2:pause()
            musicaMenu:play()
        end
    elseif gameState == "levelComplete" then
        if key == "return" or key == "kpenter" or key == "space" then
            continueFromVictory()
        end
    elseif gameState == "settings" then
        if key == "escape" then
            gameState = "menu"
        end
    end
end