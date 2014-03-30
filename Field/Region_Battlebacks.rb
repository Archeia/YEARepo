#==============================================================================
# 
# ▼ Yanfly Engine Ace - Region Battlebacks v1.00
# -- Last Updated: 2011.12.30
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-RegionBattleBacks"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.30 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# RPG Maker VX Ace lacks any kind of a good battleback management system. All
# battlebacks for the overworld are predetermined based on their autotile. This
# becomes a problem when users would like to use different autotiles or when
# users aren't using an overworld tileset. This script allows developers to
# bind certain battlebacks to regions and have the battleback shown change and
# vary depending on the region ID used if no specified battleback is used for
# that map.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Map Notetags - These notetags go in the map notebox in a map's properties.
# -----------------------------------------------------------------------------
# <region battlebacks>
#  x-y: string
#  x-y: string
# </region battlebacks>
# This will set the region x to change battleback y to the string for the image
# filename. Insert as many "x-y: string" as needed for custom battlebacks. The
# region battlebacks that aren't defined will refer to the hash in the Region
# Battlebacks script module.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module BATTLEBACKS
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Default Region Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This will set the default backdrops for maps without custom region
    # settings. These settings will always be used unless there is a forced
    # battleback or the map specifies certain battlebacks. Note that if your
    # party encounters battles while on a ship, the ship battleback will take
    # priority over all of these. Adjust the ship battlebacks further below.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT ={
    # RegionID => [  Battleback1,   Battleback2],
             0 => [  "Grassland",   "Grassland"],
             1 => [  "Grassland",     "Forest1"],
             2 => [  "Dirtfield",     "Forest2"],
             3 => [  "Dirtfield",     "Forest2"],
             4 => [      "Dirt1",       "Cliff"],
             5 => [     "Desert",      "Desert"],
             6 => [  "Wasteland",   "Wasteland"],
             7 => [      "Lava1",        "Lava"],
             8 => [      "Lava2",        "Lava"],
             9 => [  "Snowfield",   "Snowfield"],
            10 => ["PoisonSwamp", "PoisonSwamp"],
    } # Do not remove this.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Other Default Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # These settings will be applied for battleback areas without marked region
    # battlebacks. They'll appear when nothing in the above hash appears and
    # there is no specified battleback.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_BATTLEBACK_FOOT1 = "Grassland" # Battleback1 for traveling on foot.
    DEFAULT_BATTLEBACK_FOOT2 = "Grassland" # Battleback2 for traveling on foot.
    DEFAULT_BATTLEBACK_SHIP1 = "Ship"      # Battleback1 for traveling on ship.
    DEFAULT_BATTLEBACK_SHIP2 = "Ship"      # Battleback2 for traveling on ship.
    
  end # BATTLEBACKS
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module MAP
    
    REGION_BATTLEBACKS_ON  = /<(?:REGION_BATTLEBACKS|region battlebacks)>/i
    REGION_BATTLEBACKS_OFF = /<\/(?:REGION_BATTLEBACKS|region battlebacks)>/i
    REGION_BATTLEBACK_ID   = /(\d+)([-－])(\d+):[ ](.*)/i
    
  end # MAP
  end # REGEXP
end # YEA

#==============================================================================
# ■ RPG::Map
#==============================================================================

class RPG::Map
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :region_battlebacks
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_rbb
  #--------------------------------------------------------------------------
  def load_notetags_rbb
    @region_battlebacks = YEA::BATTLEBACKS::DEFAULT.clone
    @region_battlebacks_on = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::MAP::REGION_BATTLEBACKS_ON
        @region_battlebacks_on = true
      when YEA::REGEXP::MAP::REGION_BATTLEBACKS_OFF
        @region_battlebacks_on = false
      when YEA::REGEXP::MAP::REGION_BATTLEBACK_ID
        next unless @region_battlebacks_on
        rid = $1.to_i
        @region_battlebacks[rid] = ["", ""] if @region_battlebacks[rid].nil?
        case $3.to_i
        when 1
          @region_battlebacks[rid][0] = $4.to_s
        when 2
          @region_battlebacks[rid][1] = $4.to_s
        end
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Map


#==============================================================================
# ■ Spriteset_Battle
#==============================================================================

class Spriteset_Battle
  
  #--------------------------------------------------------------------------
  # overwrite method: battleback1_name
  #--------------------------------------------------------------------------
  def battleback1_name
    if $BTEST
      $data_system.battleback1_name
    elsif $game_map.battleback1_name
      $game_map.battleback1_name
    else
      overworld_battleback1_name
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: battleback2_name
  #--------------------------------------------------------------------------
  def battleback2_name
    if $BTEST
      $data_system.battleback2_name
    elsif $game_map.battleback2_name
      $game_map.battleback2_name
    else
      overworld_battleback2_name
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: normal_battleback1_name
  #--------------------------------------------------------------------------
  alias normal_battleback1_name_rbb normal_battleback1_name
  def normal_battleback1_name
    $game_map.region_battleback1 || normal_battleback1_name_rbb
  end
  
  #--------------------------------------------------------------------------
  # alias method: normal_battleback2_name
  #--------------------------------------------------------------------------
  alias normal_battleback2_name_rbb normal_battleback2_name
  def normal_battleback2_name
    $game_map.region_battleback2 || normal_battleback2_name_rbb
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: default_battleback1_name
  #--------------------------------------------------------------------------
  def default_battleback1_name
    return YEA::BATTLEBACKS::DEFAULT_BATTLEBACK_FOOT1
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: default_battleback2_name
  #--------------------------------------------------------------------------
  def default_battleback2_name
    return YEA::BATTLEBACKS::DEFAULT_BATTLEBACK_FOOT2
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: ship_battleback1_name
  #--------------------------------------------------------------------------
  def ship_battleback1_name
    return YEA::BATTLEBACKS::DEFAULT_BATTLEBACK_SHIP1
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: ship_battleback2_name
  #--------------------------------------------------------------------------
  def ship_battleback2_name
    return YEA::BATTLEBACKS::DEFAULT_BATTLEBACK_SHIP2
  end
  
end # Spriteset_Battle

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  
  #--------------------------------------------------------------------------
  # alias method: setup
  #--------------------------------------------------------------------------
  alias game_map_setup_rbb setup
  def setup(map_id)
    game_map_setup_rbb(map_id)
    @map.load_notetags_rbb
  end
  
  #--------------------------------------------------------------------------
  # new method: region_battlebacks
  #--------------------------------------------------------------------------
  def region_battlebacks
    return @map.region_battlebacks
  end
  
  #--------------------------------------------------------------------------
  # new method: region_battleback1
  #--------------------------------------------------------------------------
  def region_battleback1
    return region_battlebacks[$game_player.region_id][0]
  end
  
  #--------------------------------------------------------------------------
  # new method: region_battleback2
  #--------------------------------------------------------------------------
  def region_battleback2
    return region_battlebacks[$game_player.region_id][1]
  end
  
end # Game_Map

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================