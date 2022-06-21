local nk = require("nakama")
local function create_match_racingar(context, payload)
  local modulename = "racingar_match"
  local setupstate = { initialstate = payload }
  local matchid = nk.match_create(modulename, setupstate)

  return nk.json_encode({ matchid = matchid })
end
nk.register_rpc(create_match_racingar, "create_match_racingar")


local function get_match_data(context, payload)
  local status,payload_table = pcall(nk.json_decode, payload)
  if(status == true) then
    local matchid = payload_table.matchid
    local matchdata = nk.match_get(matchid)
    return nk.json_encode(matchdata)
  else
    return nk.json_encode(nil)
  end
end
nk.register_rpc(get_match_data, "get_match_data")

