--- STEAMODDED HEADER
--- MOD_NAME: spacereroll
--- MOD_ID: spacereroll
--- MOD_AUTHOR: [sishui]
--- MOD_DESCRIPTION: spacereroll

----------------------------------------------
------------MOD CODE -------------------------

local spacereroll = G.FUNCS.reroll_shop
local last_reroll_time = 0
local reroll_interval = 0.2
love.graphics.print = function() end

speedshow = create_UIBox_HUD
function create_UIBox_HUD()
    local hud = speedshow()
    hud.nodes[1].nodes[1].nodes[1].nodes[#hud.nodes[1].nodes[1].nodes[1].nodes+1] = 
    {n=G.UIT.R, config={align = "cm"}, nodes={
      {n=G.UIT.T, config={text = "Currently SpeedX", scale = 0.5, colour = G.C.CHIPS, pop_in = 0.5, maxw = 5}},
      {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.SETTINGS, ref_value = 'GAMESPEED'}}, colours = {G.C.MULT}, scale = 0.5, pop_in = 0.5, maxw = 5})}}
    }}
    return hud
end


local game_speedsa = {0.5, 1, 2, 4, 8, 16, 32, 64, 128, 9999}
local game_speedsb = {1, 4, 32, 9999}
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

local controller_key_press_update_ref = Controller.key_press_update

function Controller:key_press_update(key, dt)
    controller_key_press_update_ref(self, key, dt)

    if G.STATE == G.STATES.SHOP and G.shop then
        if key == 'space' then
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
    end

    if key == 'rshift' then
      cycle_game_speeda()
    end

    if key == 'lshift' then
      cycle_game_speedb()
    end
end
