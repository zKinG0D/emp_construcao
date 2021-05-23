-- Conexão
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
kinG = {}
Tunnel.bindInterface("emp_construcao",kinG)

-------------------------------------------------------------------------------------
-- CREDITS zKinG#8563 --
-------------------------------------------------------------------------------------

local salario = math.random(100, 800) -- Salário entre 70 a 100

-- Funções

function kinG.Payment()
    local source = source
	local user_id = vRP.getUserId(source)
    
    TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
    vRP.giveMoney(user_id, parseInt(salario))
    TriggerClientEvent("Notify", source, "sucesso", "Você ganhou +R$"..salario.." por entregar.")
end

-------------------------------------------------------------------------------------
-- CREDITS zKinG#8563 --
-------------------------------------------------------------------------------------