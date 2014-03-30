#==============================================================================
# 
# ▼ Yanfly Engine Ace - Encounter Rate Manager v1.00
# -- Last Updated: 2012.01.24
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-EncounterRateManager"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.24 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script gives you more control over the encounter rate management process
# for your game. You can adjust the rate at which the encounter countdown drops
# by when walking over bushes or normal ground, a number of rules made for the
# encounter countdown value, and three different variables that allow you to
# control different aspects of the encounter rates.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Alter the module settings below to set encounter countdown creation to your
# liking and to bind specific encounter rate management variables.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module ENCOUNTER
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - General Reduction Rate Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This adjusts the encounter countdown rates for when the player enters a
    # bush or steps on a normal tile. This also adjusts the modifier rate used
    # when the half encounter rate trait is used.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    BUSH_REDUCTION = 2   # Encounter rate reduction in a bush. Default: 2
    NORM_REDUCTION = 1   # Normal encounter rate reduction. Default: 1
    HALF_RATE      = 0.5 # Rate applied for half encounter rate trait.
    SHIP_RATE      = 0.5 # Rate applied when on a ship.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Creating Encounter Countdown -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # After a battle, the encounter countdown rate is recreated. You can adjust
    # the settings here to standardize the amount of times the encounter rate
    # is rerolled (for better averages), an added minimum amount of steps free
    # of encounters through a base amount and a map's default encounter rate.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ENCOUNTER_ROLLS    = 4   # Number of times the countdown is re-rolled.
    MINIMUM_FREE_STEPS = 5   # Number of steps given to player free of battle.
    PERCENT_FREE_STEPS = 0.2 # Steps relative to the map's encounter rate free.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Encounter Variables -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These variables each contain various properties that modify encounter
    # rates. These variables can either increase the number of steps needed for
    # the next encounter by a certain amount, set a certain number of steps
    # that repel battles for the player, or set a certain of number of steps
    # with increased lure rates for the player.
    # 
    # If you do not wish to use a particular one of these variables, set the
    # variable to 0 and it will not be used.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    # This is the variable used for changing the encounter rate. Whatever value
    # this variable is, it gets added on to the encounter rate. If the value is
    # positive, the player will have more steps remaining before entering a
    # battle by that amount. If the value is negative, the player will have
    # less steps remaining before entering a battle.
    BOOST_VARIABLE = 41    # Set this variable to 0 to not use it.
    
    # This is the variable used to repel battles from the player. If this value
    # is positive, then the player will not encounter battles for each step
    # until this value reaches 0. This variable decreases by 1 each step. Until
    # this value is 0, the normal encounter countdown will not decrease.
    REPEL_VARIABLE = 42    # Set this variable to 0 to not use it.
    
    # This is the variable used to lure battles for the player. If this value
    # is positive, the encounter countdown will drop drastically faster for the
    # player each step. This variable decreases by 1 each step. While this
    # value above 0, the normal encounter countdown will decrease drastically.
    LURE_VARIABLE  = 43    # Set this variable to 0 to not use it.
    LURE_RATE      = 0.5   # Each step taken will reduce the countdown by 50%.
    
  end # ENCOUNTER
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Variable
#==============================================================================

module Variable
  
  #--------------------------------------------------------------------------
  # self.encounter_boost
  #--------------------------------------------------------------------------
  def self.encounter_boost
    return 0 if YEA::ENCOUNTER::BOOST_VARIABLE <= 0
    return $game_variables[YEA::ENCOUNTER::BOOST_VARIABLE]
  end
  
  #--------------------------------------------------------------------------
  # self.encounter_repel
  #--------------------------------------------------------------------------
  def self.encounter_repel
    return 0 if YEA::ENCOUNTER::REPEL_VARIABLE <= 0
    return $game_variables[YEA::ENCOUNTER::REPEL_VARIABLE]
  end
  
  #--------------------------------------------------------------------------
  # self.update_repel
  #--------------------------------------------------------------------------
  def self.update_repel
    return 0 if YEA::ENCOUNTER::REPEL_VARIABLE <= 0
    $game_variables[YEA::ENCOUNTER::REPEL_VARIABLE] -= 1
    return 0
  end
  
  #--------------------------------------------------------------------------
  # self.encounter_lure
  #--------------------------------------------------------------------------
  def self.encounter_lure
    return 0 if YEA::ENCOUNTER::LURE_VARIABLE <= 0
    return $game_variables[YEA::ENCOUNTER::LURE_VARIABLE]
  end
  
  #--------------------------------------------------------------------------
  # self.update_lure
  #--------------------------------------------------------------------------
  def self.update_lure
    return YEA::ENCOUNTER::LURE_RATE if YEA::ENCOUNTER::LURE_VARIABLE <= 0
    $game_variables[YEA::ENCOUNTER::LURE_VARIABLE] -= 1
    return YEA::ENCOUNTER::LURE_RATE
  end
  
end # Variable

#==============================================================================
# ■ Game_Player
#==============================================================================

class Game_Player < Game_Character
  
  #--------------------------------------------------------------------------
  # overwrite method: encounter_progress_value
  #--------------------------------------------------------------------------
  def encounter_progress_value
    return Variable.update_repel if Variable.encounter_repel > 0
    value = $game_map.bush?(@x, @y) ? bush_encounter_rate : norm_encounter_rate
    value *= YEA::ENCOUNTER::HALF_RATE if $game_party.encounter_half?
    value *= YEA::ENCOUNTER::SHIP_RATE if in_ship?
    if Variable.encounter_lure > 0
      value += @encounter_count *= Variable.update_lure
    end
    return value
  end
  
  #--------------------------------------------------------------------------
  # new method: bush_encounter_rate
  #--------------------------------------------------------------------------
  def bush_encounter_rate
    return YEA::ENCOUNTER::BUSH_REDUCTION
  end
  
  #--------------------------------------------------------------------------
  # new method: norm_encounter_rate
  #--------------------------------------------------------------------------
  def norm_encounter_rate
    return YEA::ENCOUNTER::NORM_REDUCTION
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: make_encounter_count
  #--------------------------------------------------------------------------
  def make_encounter_count
    n = $game_map.encounter_step
    @encounter_count = 0
    reroll = [YEA::ENCOUNTER::ENCOUNTER_ROLLS, 1].max
    reroll.times do @encounter_count += rand(n) end
    @encounter_count /= reroll
    @encounter_count += YEA::ENCOUNTER::MINIMUM_FREE_STEPS
    @encounter_count += (YEA::ENCOUNTER::PERCENT_FREE_STEPS * n).to_i
    @encounter_count += Variable.encounter_boost
    @encounter_count = [@encounter_count, 1].max
  end
  
end # Game_Player

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================