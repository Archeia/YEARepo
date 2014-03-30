#==============================================================================
# 
# ▼ Yanfly Engine Ace - Call Random Battle v1.00
# -- Last Updated: 2011.12.06
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-CallRandomBattle"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.06 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# For users who like to use touch encounters, I'm sure you've encountered the
# difficulty of randomizing what kinds of encounters can come with each touch
# encounter. This script call will randomize what battle will be held based on
# what random encounters would occur on the map.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# call_random_battle
# This call will generate a random battle based on the tile (and region) that
# the player is currently standing on. Any battles outside of the tile's marked
# region will not be added to the random pool.
# 
# call_region_battle(x)
# call_region_battle(x, x, x)
# This call will generate a random battle based on the tile (and region) that
# is marked by x. Any battles that can occur within those x regions will be
# added to the random pool.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # new method: call_random_battle
  #--------------------------------------------------------------------------
  def call_random_battle
    troop_id = $game_player.make_encounter_troop_id
    return if $data_troops[troop_id].nil?
    BattleManager.setup(troop_id)
    BattleManager.on_encounter
    SceneManager.call(Scene_Battle)
  end
  
  #--------------------------------------------------------------------------
  # new method: call_region_battle
  #--------------------------------------------------------------------------
  def call_region_battle(*args)
    regions = []
    args.each do |arg_item|
      case arg_item
      when Integer
        regions.push(arg_item)
      when Array
        regions |= arg_item
      else
        regions.push(arg_item.to_i)
      end
    end
    troop_id = $game_player.make_region_encounter_troop_id(regions.uniq)
    return if $data_troops[troop_id].nil?
    BattleManager.setup(troop_id)
    BattleManager.on_encounter
    SceneManager.call(Scene_Battle)
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Game_Player
#==============================================================================

class Game_Player < Game_Character
  
  #--------------------------------------------------------------------------
  # new method: make_region_encounter_troop_id
  #--------------------------------------------------------------------------
  def make_region_encounter_troop_id(regions)
    encounter_list = []
    weight_sum = 0
    $game_map.encounter_list.each do |encounter|
      next unless region_encounter_ok?(encounter, regions)
      encounter_list.push(encounter)
      weight_sum += encounter.weight
    end
    if weight_sum > 0
      value = rand(weight_sum)
      encounter_list.each do |encounter|
        value -= encounter.weight
        return encounter.troop_id if value < 0
      end
    end
    return 0
  end
  
  #--------------------------------------------------------------------------
  # new method: region_encounter_ok?
  #--------------------------------------------------------------------------
  def region_encounter_ok?(encounter, regions)
    return true if encounter.region_set.empty?
    return true if (encounter.region_set & regions).size > 0
    return false
  end
  
end # Game_Player

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================