AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local player = source
    local name, setKickReason, deferrals = name, setKickReason, deferrals;
    local ipIdentifier
    local identifiers = GetPlayerIdentifiers(player)


    deferrals.defer()
    Wait(0)
    deferrals.update(string.format("Hola %s. Tu conexion esta siendo revisada por el sistema, porfavor espere", name))
    for _, v in pairs(identifiers) do
        if string.find(v, "ip") then
            ipIdentifier = v:sub(4)
            break
        end
    end
    Wait(0)
    if not ipIdentifier then
        deferrals.done("No pudimos verificar su conexion, intentelo de nuevo o contacto con el staff.")
    else
        PerformHttpRequest("http://ip-api.com/json/" .. ipIdentifier .. "?fields=proxy", function(err, text, headers)
            if tonumber(err) == 200 then
                local tbl = json.decode(text)
                if tbl["proxy"] == false then
                    deferrals.done()
                else
                    deferrals.done("Estás usando una VPN.Por favor, desactive y vuelva a intentarlo.")
                    sendDiscord('AntiVPN Draik', ' IP: ' .. ipIdentifier ..'| Acaba de intentar entrar con VPN o PROXY')
                end
            else
                deferrals.done("Hubo un error en la API.")
            end
        end)
    end
end)
webhookurl = 'XXXX' -- Cambiamos las XXXX por el webhooks de discord


function sendDiscord(name, message)
    PerformHttpRequest(webhookurl, function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
end


