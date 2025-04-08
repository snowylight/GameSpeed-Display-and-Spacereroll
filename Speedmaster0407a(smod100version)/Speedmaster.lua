--- STEAMODDED HEADER
--- MOD_NAME: Speedmaster
--- MOD_ID: Speedmaster
--- MOD_AUTHOR: [snowylight]
--- PREFIX: spma
--- MOD_DESCRIPTION: Some useful keybinds!
--- PRIORITY: -100
--- VERSION: 1.1.1
----------------------------------------------
------------MOD CODE -------------------------


local spacereroll = G.FUNCS.reroll_shop
local last_reroll_time = 0
local reroll_interval = 0.2
love.graphics.print = function() end

G.FUNCS.debugzuobi = function()
    if not G.debug_tools then
        G.debug_tools = UIBox{
            definition = create_UIBox_debug_tools(),
            config = {align='cr', offset = {x=G.ROOM.T.x + 11,y=0},major = G.ROOM_ATTACH, bond = 'Weak'}
        }
        G.E_MANAGER:add_event(Event({
            blockable = false,
            func = function()
                G.debug_tools.alignment.offset.x = -4
                return true
            end
        }))
    elseif G.debug_tools then
        G.debug_tools:remove()
        G.debug_tools = nil
    end
end

G.FUNCS.cundang_button = function()
    if G.STAGE == G.STAGES.RUN then
        play_sound('negative')
        compress_and_save(G.SETTINGS.profile .. '/' .. 'debugsave' .. '10' .. '.jkr', G.ARGS.save_run)
    end
end

G.FUNCS.dudang_button = function()
    if G.STAGE == G.STAGES.RUN then
        play_sound('holo1')
        G:delete_run()
            G.SAVED_GAME = get_compressed(G.SETTINGS.profile .. '/' .. 'debugsave' .. '10' .. '.jkr')
            if G.SAVED_GAME ~= nil then
                G.SAVED_GAME = STR_UNPACK(G.SAVED_GAME)
            end
            G:start_run({
            savetext = G.SAVED_GAME
        })
    end
end

local createOptionsRef = create_UIBox_options
function create_UIBox_options()
	contents = createOptionsRef()
	local cundang_button = UIBox_button({
		minw = 5,
		button = "cundang_button",
		label = {localize("k_speedmastersave")}
	})
    local dudang_button = UIBox_button({
		minw = 5,
		button = "dudang_button",
		label = {localize("k_speedmasterload")}
	})
    table.insert(contents.nodes[1].nodes[1].nodes[1].nodes, #contents.nodes[1].nodes[1].nodes[1].nodes + 1, cundang_button)
	table.insert(contents.nodes[1].nodes[1].nodes[1].nodes, #contents.nodes[1].nodes[1].nodes[1].nodes + 1, dudang_button)
	return contents
end

--UIbox
cuiboxhud = create_UIBox_HUD
function create_UIBox_HUD()
    local hud = cuiboxhud()
    hud.nodes[1].nodes[1].nodes[1].nodes[#hud.nodes[1].nodes[1].nodes[1].nodes+1] = 
    {n=G.UIT.R, config={align = "cm"}, nodes={
      {n=G.UIT.T, config={text = localize('k_speedmaster'), scale = 0.6, colour = G.C.CHIPS, pop_in = 0.5, maxw = 5, button = "debugzuobi"}},
      {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.SETTINGS, ref_value = 'GAMESPEED'}}, colours = {G.C.MULT}, scale = 0.6, pop_in = 0.5, maxw = 5})}}
    }}
    return hud
end

--functions
local game_speedsa = {0.5, 1, 2, 4, 8, 16, 32, 64, 128, 999}
local game_speedsb = {1, 4, 32, 999}
local function find_speed_index(current_speed)
    for i, speed in ipairs(game_speedsa) do
        if speed == current_speed then
            return i
        end
    end
    return 1
end

local function cycle_game_speeda()
    local current_speed = G.SETTINGS.GAMESPEED
    local index = find_speed_index(current_speed)
    local next_speed = game_speedsa[index % #game_speedsa + 1]
    G.SETTINGS.GAMESPEED = next_speed
end

local function find_speed_index(current_speed)
  for i, speed in ipairs(game_speedsb) do
      if speed == current_speed then
          return i
      end
  end
  return 1
end

local function cycle_game_speedb()
  local current_speed = G.SETTINGS.GAMESPEED
  local index = find_speed_index(current_speed)
  local next_speed = game_speedsb[index % #game_speedsb + 1]
  G.SETTINGS.GAMESPEED = next_speed
end

--These are keybinds from example mods
-------------------------------------------------------------------
SMODS.Keybind{
	key = 'winblind',
	key_pressed = 'q',
    held_keys = {'lctrl'}, -- other key(s) that need to be held

    action = function(controller)
        if G.STATE ~= G.STATES.SELECTING_HAND then
            return
        end
        G.GAME.chips = G.GAME.blind.chips
        G.STATE = G.STATES.HAND_PLAYED
        G.STATE_COMPLETE = true
        play_sound('coin1')
        end_round()
        sendInfoMessage("win this blind")
    end,
}

SMODS.Keybind{
	key = 'imrich',
	key_pressed = 'w',
    held_keys = {'lctrl'}, -- other key(s) that need to be held

    action = function(controller)
        if G.STAGE == G.STAGES.RUN then
        play_sound('coin1')
        G.GAME.dollars = 1000000
        sendInfoMessage("money set to 1 million")
        end
    end,
}
-------------------------------------------------------------------

--Speed froze keybind
SMODS.Keybind{
	key = 'speedfroze',
	key_pressed = 'lalt',
    original_speed = nil,

    action = function(self, controller)
        if G.STAGE == G.STAGES.RUN then
        if G.SETTINGS.GAMESPEED == 0.5 then
        play_sound('tarot1')
        G.SETTINGS.GAMESPEED = self.original_speed
        else
        play_sound('tarot1')
        self.original_speed = G.SETTINGS.GAMESPEED
        G.SETTINGS.GAMESPEED = 0.5
        end
        sendInfoMessage("froze")
        end
    end,
}

--Joker collection
SMODS.Keybind{
	key = 'cojoker',
	key_pressed = 'z',
    held_keys = {'lctrl'}, -- other key(s) that need to be held
    action = function(controller)
        G.SETTINGS.paused = true
        G.FUNCS.overlay_menu{
          definition = create_UIBox_your_collection_jokers(),
        }
    end,
}

--save the run
SMODS.Keybind{
	key = 'spsave',
	key_pressed = 's',
    held_keys = {'lctrl'}, -- other key(s) that need to be held
    action = function(controller)
        if G.STAGE == G.STAGES.RUN then
            play_sound('negative')
            compress_and_save(G.SETTINGS.profile .. '/' .. 'debugsave' .. '10' .. '.jkr', G.ARGS.save_run)
        end
    end,
}

--Shift speed
SMODS.Keybind{
	key = 'rshiftspeed',
	key_pressed = 'rshift',

    action = function(self, controller)
        if G.STAGE == G.STAGES.RUN then
        cycle_game_speeda()
        play_sound('tarot1')
        sendInfoMessage("rshiftspeed")
        end
    end,
}

SMODS.Keybind{
	key = 'lshiftspeed',
	key_pressed = 'lshift',

    action = function(self, controller)
        if G.STAGE == G.STAGES.RUN then
        cycle_game_speedb()
        play_sound('tarot1')
        sendInfoMessage("lshiftspeed")
        end
    end,
}

--Spacereroll
SMODS.Keybind{
	key = 'Spacereroll',
	key_pressed = 'space',

    action = function(self, controller)
        if G.STATE == G.STATES.SHOP and G.shop then
                local current_time = os.time()
                if current_time - last_reroll_time >= reroll_interval and 
                   ((G.GAME.dollars - G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost >= 0) or 
                   G.GAME.current_round.reroll_cost == 0 then
                    spacereroll()
                    last_reroll_time = current_time
    
                    
                    if G.GAME.used_vouchers.v_4d_boosters then
                        my_reroll_shop(get_booster_pack_max(), G.P_CENTERS.v_4d_boosters.config.extra)
                    end
                end
        end
        sendInfoMessage("Spacereroll")
    end,
}
----------------------------------------------
------------MOD CODE END----------------------
