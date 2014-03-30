#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Damage v1.01
# -- Last Updated: 2011.12.22
# -- Level: Lunatic
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LunaticDamage"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.22 - Small bugfix on notetags and Ace Battle Engine compatibility.
# 2011.12.20 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Lunatic mode effects have always been a core part of Yanfly Engine scripts.
# They exist to provide more effects for those who want more power and control
# for their items, skills, status effects, etc., but the users must be able to
# add them in themselves.
# 
# At first, I thought the need for Lunatic Damage tags would be no longer
# needed due to RPG Maker VX Ace's custom damage formula box, but after
# realizing that it's limited in size (100 characters max), Lunatic Damage will
# have to take over if needed.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # ● Welcome to Lunatic Mode
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Lunatic Damage Formulas allows skills and items to use custom damage
  # formulas that allow for more than 100 characters. Use the following
  # notetag to assign the formulas to be used.
  # 
  #     <custom damage: string>
  # 
  # The string used will refer to the formula used below. Also, note that
  # through this script, all items and skills will run through this method
  # even if the <custom damage> notetag isn't used.
  # 
  # "NORMAL FORMULA" will be the formula used if no custom damage formulas
  # are inserted. In addition to that, you may also insert "NORMAL FORMULA"
  # to have the custom damage formula add on the normal damage formula used
  # in "Formula Calculation" within the database editor.
  # 
  # If multiple tags of the custom damage notetags are used in the same
  # skill/item's notebox, then the calculations will occur in that order.
  # Replace "string" in the tags with the appropriate flag for the method
  # below to search for. Note that unlike the previous versions, these are
  # all upcase.
  # 
  # Should you choose to use multiple lunatic formulas for a single skill or
  # item, you may use these notetags in place of the one shown above.
  # 
  #     <custom damage>
  #      string
  #      string
  #     </custom damage>
  # 
  # All of the string information in between those two notetags will be
  # stored the same way as the notetags shown before those. There is no
  # difference between using either.
  #--------------------------------------------------------------------------
  def lunatic_damage_formula(user, item)
    formulas = item.custom_damage
    @calc_element = true
    @calc_pdr = true
    @calc_mdr = true
    @calc_rec = true
    @calc_cri = true
    @calc_var = true
    @calc_guard = true
    a = user
    b = self
    value = 0
    for formula in formulas
      case formula.upcase
      #----------------------------------------------------------------------
      # Damage Formula: Normal Formula
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This formula uses/adds on the normal formula displayed in the
      # database editor. If no custom damage formulas are used, this will
      # take effect.
      #----------------------------------------------------------------------
      when /NORMAL FORMULA/i
        value += item.damage.eval(user, self, $game_variables)
        
      #----------------------------------------------------------------------
      # Damage Formula: Common Damage
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a part of the damage formulas that will run every time damage
      # is calculated. This step will always occur at the end but right
      # before the Finalization step.
      #----------------------------------------------------------------------
      when /COMMON DAMAGE/i
        # No common after effects added.
        
      #----------------------------------------------------------------------
      # Damage Formula: Finalization
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # All damage calculations will run "FINALIZATION" after calculating.
      # Adjust whatever settings you want done here. By default, this setting
      # will correct certain values in case they go under specific amounts
      # under specific conditions (like HP draining).
      #----------------------------------------------------------------------
      when /FINALIZATION/i
        value *= item_element_rate(user, item) if @calc_element
        value *= pdr if item.physical? && @calc_pdr
        value *= mdr if item.magical? && @calc_mdr
        value *= rec if item.damage.recover? && @calc_rec
        value = apply_critical(value) if @result.critical && @calc_cri
        value = apply_variance(value, item.damage.variance) if @calc_var
        value = apply_guard(value) if @calc_guard
        #---
        if formulas.include?("NORMAL FORMULA")
          if item.damage.to_mp?
            value = [b.mp, value].min
          elsif item.damage.to_hp? && item.damage.drain?
            value = [b.hp, value].min
          end
        end # formulas.include?("NORMAL FORMULA")
        
      #----------------------------------------------------------------------
      # Stop editting past this point.
      #----------------------------------------------------------------------
      else
        value += lunatic_damage_extension(formula, a, b, item, value)
      end
    end
    return value.to_i
  end # lunatic_damage_formula(user, item)
  
end # Game_Battler

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module USABLEITEM
    
    CUSTOM_DAMAGE_STR = /<(?:CUSTOM_DAMAGE|custom damage):[ ](.*)>/i
    CUSTOM_DAMAGE_ON  = /<(?:CUSTOM_DAMAGE|custom damage)>/i
    CUSTOM_DAMAGE_OFF = /<\/(?:CUSTOM_DAMAGE|custom damage)>/i
    
  end # USABLEITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_ldmg load_database; end
  def self.load_database
    load_database_ldmg
    load_notetags_ldmg
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_ldmg
  #--------------------------------------------------------------------------
  def self.load_notetags_ldmg
    groups = [$data_items, $data_skills]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_ldmg
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :custom_damage
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_ldmg
  #--------------------------------------------------------------------------
  def load_notetags_ldmg
    @custom_damage = []
    @custom_damage_on = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::CUSTOM_DAMAGE_STR
        @custom_damage.push($1.to_s)
      #---
      when YEA::REGEXP::USABLEITEM::CUSTOM_DAMAGE_ON
        @custom_damage_on = true
      when YEA::REGEXP::USABLEITEM::CUSTOM_DAMAGE_OFF
        @custom_damage_on = false
      #---
      else
        @custom_damage.push(line.to_s) if @custom_damage_on
      end
    } # self.note.split
    #---
    @custom_damage.push("NORMAL FORMULA") if @custom_damage == []
    @custom_damage.push("COMMON DAMAGE")
    @custom_damage.push("FINALIZATION")
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ Game_ActionResult
#==============================================================================

class Game_ActionResult
  
  #--------------------------------------------------------------------------
  # overwrite method: make_damage
  #--------------------------------------------------------------------------
  def make_damage(value, item)
    @critical = false if value == 0
    @hp_damage += value if item.damage.to_hp?
    @mp_damage += value if item.damage.to_mp?
    @hp_drain += @hp_damage if item.damage.drain?
    @mp_drain += @mp_damage if item.damage.drain?
    @success = true if item.damage.to_hp? || @mp_damage != 0
  end
  
end # Game_ActionResult

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # overwrite method: make_damage_value
  #--------------------------------------------------------------------------
  def make_damage_value(user, item)
    value = lunatic_damage_formula(user, item)
    @result.make_damage(value.to_i, item)
    return unless $imported["YEA-BattleEngine"]
    rate = item_element_rate(user, item)
    make_rate_popup(rate) unless $game_temp.evaluating
  end
  
  #--------------------------------------------------------------------------
  # new method: lunatic_damage_extension
  #--------------------------------------------------------------------------
  def lunatic_damage_extension(formula, a, b, item, total_damage)
    # Reserved for future Add-ons.
    value = 0
    return value
  end
  
end # Game_Battler

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================