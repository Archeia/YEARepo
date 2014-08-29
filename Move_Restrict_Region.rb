#==============================================================================
# 
# ▼ Yanfly Engine Ace - Move Restrict Region v1.03
# -- Last Updated: 2012.01.03
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-MoveRestrictRegion"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.23.08 - Added Feature: <all restrict: x>
# 2012.01.03 - Added Feature: <all restrict: x>
# 2011.12.26 - Bug Fixed: Player Restricted Regions.
# 2011.12.15 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Not everybody wants NPC's to travel all over the place. With this script, you
# can set NPC's to be unable to move pass tiles marked by a specified Region.
# Simply draw out the area you want to enclose NPC's in on and they'll be
# unable to move past it unless they have Through on. Likewise, there are
# regions that you can prevent the player from moving onto, too!
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
# <all restrict: x>
# <all restrict: x, x>
# Players and NPC's on the map will be unable to move past region x even if
# they have the "through" flag set. The only thing that can go past is if the
# player is using the debug through flag. Draw out the area you want to close
# the player and NPC's in with the regions and both will be unable to move onto
# any of those tiles marked by region x. If you want to have more regions
# restrict NPC's, insert multiples of this tag.
# 
# <npc restrict: x>
# <npc restrict: x, x>
# NPC's on that map will be unable to move past regions x unless they have a
# "Through" flag on. Draw out the area you want to close NPC's in with the
# regions and the NPC's will be unable to move onto any of those tiles marked
# by region x. If you want to have more regions restrict NPC's, insert
# multiples of this tag.
# 
# <player restrict: x>
# <player restrict: x, x>
# Players will not be able to move on tiles marked by region x unless the
# player has a "Through" flag on. Draw out the area you want to close the
# player in with the regions and the player will be unable to move past any of
# those tiles marked by region x. If you want to have more regions restrict the
# player, insert multiples of this tag.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module MOVE_RESTRICT
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Default Completely Restricted Regions -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # If you want there to always be a region ID that will forbid both the
    # player and NPC's from passing through, insert that region ID into the
    # array below. This effect will completely block out both players and NPC's
    # even if they have the "through" flag. However, it does not block the
    # debug_through flag for players.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_ALL = [61]
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Default Player Restricted Regions -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # If you want there to always be a region ID that will forbid the player
    # from passing through, insert that region ID into the array below.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_PLAYER = [62]
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Default NPC Restricted Regions -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # If you want there to always be a region ID that will forbid NPC's from
    # passing through, insert that region ID into the array below.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_NPC = [63]
    
  end # MOVE_RESTRICT
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module MAP
    
    ALL_RESTRICT = 
      /<(?:ALL_RESTRICT|all restrict):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    NPC_RESTRICT = 
      /<(?:NPC_RESTRICT|npc restrict):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    PLAYER_RESTRICT = 
      /<(?:PLAYER_RESTRICT|player restrict):[ ]*(\d+(?:\s*,\s*\d+)*)>/i
    
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
  attr_accessor :all_restrict_regions
  attr_accessor :npc_restrict_regions
  attr_accessor :player_restrict_regions
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_mrr
  #--------------------------------------------------------------------------
  def load_notetags_mrr
    @all_restrict_regions = YEA::MOVE_RESTRICT::DEFAULT_ALL.clone
    @npc_restrict_regions = YEA::MOVE_RESTRICT::DEFAULT_NPC.clone
    @player_restrict_regions = YEA::MOVE_RESTRICT::DEFAULT_PLAYER.clone
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::MAP::ALL_RESTRICT
        $1.scan(/\d+/).each { |num| 
        @all_restrict_regions.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::MAP::NPC_RESTRICT
        $1.scan(/\d+/).each { |num| 
        @npc_restrict_regions.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::MAP::PLAYER_RESTRICT
        $1.scan(/\d+/).each { |num| 
        @player_restrict_regions.push(num.to_i) if num.to_i > 0 }
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
  alias game_map_setup_mrr setup
  def setup(map_id)
    game_map_setup_mrr(map_id)
    @map.load_notetags_mrr
  end
  
  #--------------------------------------------------------------------------
  # new method: all_restrict_regions
  #--------------------------------------------------------------------------
  def all_restrict_regions
    return @map.all_restrict_regions
  end
  
  #--------------------------------------------------------------------------
  # new method: npc_restrict_regions
  #--------------------------------------------------------------------------
  def npc_restrict_regions
    return @map.npc_restrict_regions
  end
  
  #--------------------------------------------------------------------------
  # new method: player_restrict_regions
  #--------------------------------------------------------------------------
  def player_restrict_regions
    return @map.player_restrict_regions
  end
  
end # Game_Map

#==============================================================================
# ■ Game_CharacterBase
#==============================================================================

class Game_CharacterBase
  
  #--------------------------------------------------------------------------
  # alias method: passable?
  #--------------------------------------------------------------------------
  alias game_characterbase_passable_mrr passable?
  def passable?(x, y, d)
    return false if npc_region_forbid?(x, y, d)
    return false if player_region_forbid?(x, y, d)
    return game_characterbase_passable_mrr(x, y, d)
  end
  
  #--------------------------------------------------------------------------
  # new method: npc_forbid?
  #--------------------------------------------------------------------------
  def npc_region_forbid?(x, y, d)
    return false unless self.is_a?(Game_Event)
    region = 0
    case d
    when 1; region = $game_map.region_id(x-1, y+1)
    when 2; region = $game_map.region_id(x+0, y+1)
    when 3; region = $game_map.region_id(x+1, y+1)
    when 4; region = $game_map.region_id(x-1, y+0)
    when 5; region = $game_map.region_id(x+0, y+0)
    when 6; region = $game_map.region_id(x+1, y+0)
    when 7; region = $game_map.region_id(x-1, y-1)
    when 8; region = $game_map.region_id(x+0, y-1)
    when 9; region = $game_map.region_id(x+1, y-1)
    end
    return true if $game_map.all_restrict_regions.include?(region)
    return false if @through
    return $game_map.npc_restrict_regions.include?(region)
  end
  
  #--------------------------------------------------------------------------
  # new method: player_region_forbid?
  #--------------------------------------------------------------------------
  def player_region_forbid?(x, y, d)
    return false unless self.is_a?(Game_Player)
    return false if debug_through?
    region = 0
    case d
    when 1; region = $game_map.region_id(x-1, y+1)
    when 2; region = $game_map.region_id(x+0, y+1)
    when 3; region = $game_map.region_id(x+1, y+1)
    when 4; region = $game_map.region_id(x-1, y+0)
    when 5; region = $game_map.region_id(x+0, y+0)
    when 6; region = $game_map.region_id(x+1, y+0)
    when 7; region = $game_map.region_id(x-1, y-1)
    when 8; region = $game_map.region_id(x+0, y-1)
    when 9; region = $game_map.region_id(x+1, y-1)
    end
    return true if $game_map.all_restrict_regions.include?(region)
    return false if @through
    return $game_map.player_restrict_regions.include?(region)
  end
  
end # Game_CharacterBase

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================