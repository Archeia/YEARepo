#==============================================================================
# 
# ▼ Yanfly Engine Ace - Extra Drops v1.01
# -- Last Updated: 2011.12.31
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ExtraDrops"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.31 - Bug Fixed: Drop ratios now work properly.
# 2011.12.17 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Enemies by default only drop three items maximum in RPG Maker VX Ace. The
# drop rates are also limited to rates that can only be achieved through
# denominator values. A drop rate of say, 75% cannot be achieved. This script
# provides the ability to add more than just three drops and more control over
# the drop rates, too.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <drop Ix: y%>
# <drop Wx: y%>
# <drop Ax: y%>
# Causes enemy to drop item, weapon, or armour (marked by I, W, or A) x at a
# rate of y percent. Insert multiples of this tag to increase the number of
# drops an enemy can possibly have.
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

module YEA
  module REGEXP
  module ENEMY
    
    DROP_PLUS = /<(?:DROP|drop)[ ]([IWA])(\d+):[ ](\d+)([%％])>/i
    
  end # ENEMY
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_edr load_database; end
  def self.load_database
    load_database_edr
    load_notetags_edr
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_al
  #--------------------------------------------------------------------------
  def self.load_notetags_edr
    for enemy in $data_enemies
      next if enemy.nil?
      enemy.load_notetags_edr
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :extra_drops
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_edr
  #--------------------------------------------------------------------------
  def load_notetags_edr
    @extra_drops = []
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::DROP_PLUS
        case $1.upcase
        when "I";  kind = 1
        when "W";  kind = 2
        when "A";  kind = 3
        else; next
        end
        item = RPG::Enemy::DropItem.new
        item.kind = kind
        item.data_id = $2.to_i
        item.drop_rate = $3.to_i * 0.01
        @extra_drops.push(item)
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# ■ RPG::Enemy::DropItem
#==============================================================================

class RPG::Enemy::DropItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :drop_rate
  
  #--------------------------------------------------------------------------
  # new method: drop_rate
  #--------------------------------------------------------------------------
  def drop_rate
    return 0 if @drop_rate.nil?
    return @drop_rate
  end
  
end # RPG::Enemy::DropItem

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # alias method: make_drop_items
  #--------------------------------------------------------------------------
  alias game_enemy_make_drop_items_edr make_drop_items
  def make_drop_items
    result = game_enemy_make_drop_items_edr
    result += make_extra_drops
    return result
  end
  
  #--------------------------------------------------------------------------
  # new method: make_extra_drops
  #--------------------------------------------------------------------------
  def make_extra_drops
    result = []
    for drop in enemy.extra_drops
      next if rand > drop.drop_rate
      result.push(item_object(drop.kind, drop.data_id))
    end
    return result
  end
  
end # Game_Enemy

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================