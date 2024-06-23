thx_morale_boost_table = thx_morale_boost_table or {}

if not _G.thx_morale_boost_text then
    _G.thx_morale_boost_text = {}
	local path = ModPath .. "text.ini"
	local file = io.open(path, "r")
	if file then
		for line in file:lines() do
		    table.insert(_G.thx_morale_boost_text, line)
		end
	    file:close()
	end
end

local function benefaction(peer, times)
    local t = _G.thx_morale_boost_text[math.random(1,(table.getn(_G.thx_morale_boost_text)))]
	local t = string.gsub(t, "$PEERNAME", peer)
	local t = string.gsub(t, "$TIMES", times)
	local t0 = string.gsub(t, "times", "time")
	
	if times > 1 then
	    managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or "Offline", t )
	elseif times == 1 then
	    managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or "Offline", t0 )
	end
end

Hooks:PostHook(PlayerMovement, "on_morale_boost", "thx_morale_boost", function(self, benefactor_unit, ...)
	local benefactor_peer = managers.network:session():peer_by_unit(benefactor_unit)
	local key = benefactor_peer and benefactor_peer:user_id() or benefactor_peer:id()
	
	if benefactor_unit ~= managers.network:session():local_peer():unit() then
	    thx_morale_boost_table[key] = (thx_morale_boost_table[key] or 0) + 1
		benefaction(benefactor_peer:name(), thx_morale_boost_table[key])
	end
end)