#==============================================================================
# 
# ▼ Yanfly Engine Ace - No Encounter Region v1.00
# -- Last Updated: 2011.12.15
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-NoEncounterRegion"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.15 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Regions are used here to prevent encounters from happening if the player is
# on them. This can be used for event areas, puzzle areas, that may share the
# same map with random encounters.
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
# <no encounter: x>
# <no encounter: x, x>
# Tiles marked by region x will be free of random encounters and the encounter
# countdown will not go down while the player is on top of that region. If you
# wish to have more region ID's to be free of encounters, insert multiples of
# this notetag into the map properties notebox.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module NO_ENCOUNTER
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Default No Encounter Regions -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This array marks region ID's that will, by default, have no encounters
    # (thus, saving you the need to keep marking every single map with no
    # encounter noteboxes). Insert the region ID's here.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_NO_ENCOUNTER = [61]
    
  end # NO_ENCOUNTER
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module MAP
    
    NO_ENCOUNTER = /<(?:NO_ENCOUNTER|no encounter):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
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
  attr_accessor :no_encounter_regions
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_ner
  #--------------------------------------------------------------------------
  def load_notetags_ner
    @no_encounter_regions = YEA::NO_ENCOUNTER::DEFAULT_NO_ENCOUNTER.clone
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::MAP::NO_ENCOUNTER
        $1.scan(/\d+/).each { |num| 
        @no_encounter_regions.push(num.to_i) if num.to_i > 0 }
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Map

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  
  #--------------------------------------------------------------------------
  # alias method: setup
  #--------------------------------------------------------------------------
  alias game_map_setup_ner setup
  def setup(map_id)
    game_map_setup_ner(map_id)
    @map.load_notetags_ner
  end
  
  #--------------------------------------------------------------------------
  # new method: no_encounter_regions
  #--------------------------------------------------------------------------
  def no_encounter_regions
    return @map.no_encounter_regions
  end
  
end # Game_Map

#==============================================================================
# ■ Game_Player
#==============================================================================

class Game_Player < Game_Character
  
  #--------------------------------------------------------------------------
  # alias method: update_encounter
  #--------------------------------------------------------------------------
  alias game_player_update_encounter_ner update_encounter
  def update_encounter
    return if $game_map.no_encounter_regions.include?(region_id)
    return game_player_update_encounter_ner
  end
  
end # Game_Player

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================