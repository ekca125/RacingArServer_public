local nk = require("nakama")
local M = {}

function M.match_init(context, setupstate)
  local status,setuptable = pcall(nk.json_decode, setupstate.initialstate)
  if(status == true) then
    local gamestate = "GAME_READY"
    local tickrate = 10
    local label = setuptable.label
    return gamestate, tickrate, label
  else
    local gamestate = {}
    local tickrate = 1
    local label = ""
    return gamestate, tickrate, label
  end
end

function M.match_join_attempt(context, dispatcher, tick, state, presence, metadata)
  local acceptuser = true
  return state, acceptuser
end

function M.match_join(context, dispatcher, tick, state, presences)
  return state
end

function M.match_leave(context, dispatcher, tick, state, presences)
  return state
end

function M.match_loop(context, dispatcher, tick, state, messages)
  for key, message_obj in pairs(messages) do
    local message_opcode = message_obj.op_code
    local message_data = message_obj.data
    local presences = nil -- send to all.
    local sender = message_obj.sender -- used if a message should come from a specific user.
    dispatcher.broadcast_message(message_opcode, message_data, presences, sender)
    if message_opcode == 1 or message_opcode == 3 then -- start op code
      local label_table = nk.json_decode(context.match_label)
      label_table.opened = false
      local new_match_label = nk.json_encode(label_table)
      dispatcher.match_label_update(new_match_label)
      return "running"
    end
  end
  return state
end

function M.match_terminate(context, dispatcher, tick, state, grace_seconds)
  return state
end

function M.match_signal(context, dispatcher, tick, state, data)
  return state, data
end

return M