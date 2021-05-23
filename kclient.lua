-- Conexão
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
kinG = Tunnel.getInterface("emp_construcao")

-- Variáveis
local processo = false
local metal = false
local coleta = false
local caixanamao = false
local destino = math.random(1,8)
-- Coords
local iniciarTrabalhoX, iniciarTrabalhoY, iniciarTrabalhoZ = config.iniciarTrabalhoX, config.iniciarTrabalhoY, config.iniciarTrabalhoZ -- Coordenadas de iniciar o emprego
local coletaTrabalhoX, coletaTrabalhoY, coletaTrabalhoZ = config.coletaTrabalhoX, config.coletaTrabalhoY, config.coletaTrabalhoZ -- Coordenadas de coletar a caixa
local iniciarblipcolorR, iniciarblipcolorG, iniciarblipcolorB = config.iniciarblipcolorR, config.iniciarblipcolorG, config.iniciarblipcolorB -- Cores do blip de inicio
local iniciarblipcolorR2, iniciarblipcolorG2, iniciarblipcolorB2 = config.iniciarblipcolorR2, config.iniciarblipcolorG2, config.iniciarblipcolorB2 -- Cores do blip de coleta
local iniciarblipcolorR3, iniciarblipcolorG3, iniciarblipcolorB3 = config.iniciarblipcolorR3, config.iniciarblipcolorG3, config.iniciarblipcolorB3 -- Cores do blip de entrega

-------------------------------------------------------------------------------------
-- CREDITS zKinG#8563 --
-------------------------------------------------------------------------------------

-- Iniciar

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local bowz,cdz = GetGroundZFor_3dCoord(iniciarTrabalhoX,iniciarTrabalhoY,iniciarTrabalhoZ)
		local distance = GetDistanceBetweenCoords(iniciarTrabalhoX,iniciarTrabalhoY,cdz,x,y,z,true)
        local zking = 1000

        if not processo then
            if distance <= 4 then
                zking = 4
                DrawMarker(21,iniciarTrabalhoX,iniciarTrabalhoY,iniciarTrabalhoZ-0.5, 0, 0, 0, 0.0, 0, 0, 0.7, 0.7, 0.7, iniciarblipcolorR, iniciarblipcolorG, iniciarblipcolorB, 100, 1, 0, 0, 1)
            
                if distance <= 1.2 then
                    drawTxt("PRESSIONE  ~r~E~w~  PARA INICIAR O TRABALHO",4,0.5,0.93,0.50,255,255,255,180)
                    if IsControlJustPressed(0,38) then
                        processo = true
                        coleta = true
                        TriggerEvent("Notify","sucesso","Você começou a trabalhar.")
                    end
                end
            end
        end

        Citizen.Wait(zking)
    end
end)


-- Coletar

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local bowz,cdz = GetGroundZFor_3dCoord(coletaTrabalhoX, coletaTrabalhoY, coletaTrabalhoZ)
		local distance = GetDistanceBetweenCoords(coletaTrabalhoX, coletaTrabalhoY,cdz,x,y,z,true)

        if coleta then
            if distance <= 40 then
                DrawMarker(20,coletaTrabalhoX, coletaTrabalhoY, coletaTrabalhoZ-0.5, 0, 0, 0, 0.0, 0, 0, 0.7, 0.7, 0.7, iniciarblipcolorR3, iniciarblipcolorG3, iniciarblipcolorB3, 100, 1, 0, 0, 1)
                  
                if distance <= 1.2 then
                    drawTxt("PRESSIONE  ~r~E~w~  PARA COLETAR A CAIXA DE MADEIRA",4,0.5,0.93,0.50,255,255,255,180)
                    if IsControlJustPressed(0,38) then
                        metal = true
                        coleta = false
                        caixanamao = true
                        andamento = true
                        vRP._CarregarObjeto("anim@heists@box_carry@","idle","prop_champ_box_01",50,28422)
                        CriandoBlip(config.locais,destino)
                    end
                end
            end
        end
    end
end)


-- Entregar

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
        local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),config.locais[destino].x,config.locais[destino].y,config.locais[destino].z,true)
        local frozen = false

        if metal and caixanamao then
            if distance <= 40 then
                DrawMarker(20,config.locais[destino].x, config.locais[destino].y, config.locais[destino].z-0.5, 0, 0, 0, 0.0, 0, 0, 0.7, 0.7, 0.7, iniciarblipcolorR2, iniciarblipcolorG2, iniciarblipcolorB2, 100, 1, 0, 0, 1)
                  
                if distance <= 1.2 then
                    drawTxt("PRESSIONE  ~r~E~w~  PARA ENTREGAR A CAIXA DE MADEIRA",4,0.5,0.93,0.50,255,255,255,180)
                    if IsControlJustPressed(0,38) then
                        metal = false
                        coleta = true
                        andamento = false
                        FreezeEntityPosition(ped,true)
                        RequestAnimDict("anim@heists@money_grab@briefcase")
				        while not HasAnimDictLoaded("anim@heists@money_grab@briefcase") do
					        Citizen.Wait(0) 
				        end
				        TaskPlayAnim(ped,"anim@heists@money_grab@briefcase","put_down_case",100.0,200.0,0.3,120,0.2,0,0,0)
                        RemoveBlip(blip)
				        Wait(800)
				        vRP._DeletarObjeto()
						Wait(600)
						ClearPedTasksImmediately(ped)
                        FreezeEntityPosition(ped,false)
                        kinG.Payment()
                    end
                end
            end
        end
    end
end)

-- Cancelar teclas

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if andamento then
			BlockWeaponWheelThisFrame()
		end
	end
end)

-- Cancelar Trabalho

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0,168) and processo then
            processo = false
            metal = false
            coleta = false
            caixanamao = false
            andamento = false
            vRP._DeletarObjeto()
            vRP._stopAnim(false)
            TriggerClientEvent("Notify",source,"negado","Você cancelou o trabalho.")
        end
    end
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlip(locais,destino)
	blip = AddBlipForCoord(config.locais[destino].x,config.locais[destino].y,config.locais[destino].z)
	SetBlipSprite(blip,162)
	SetBlipColour(blip,5)
	SetBlipScale(blip,0.45)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entregar Caixa de Madeira")
	EndTextCommandSetBlipName(blip)
end

-------------------------------------------------------------------------------------
-- CREDITS zKinG#8563 --
-------------------------------------------------------------------------------------