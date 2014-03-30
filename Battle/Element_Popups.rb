#==============================================================================
# 
# ▼ Yanfly Engine Ace - Battle Engine Add-On: Elemental Popups v1.00
# -- Last Updated: 2011.12.26
# -- Level: Normal
# -- Requires: YEA - Ace Battle Engine v1.08+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-ElementalPopups"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.26 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script colour-coded element popups as they appear in battle for any kind
# of HP damage dealt. This does not include healing popups, MP damage popups,
# only HP damage dealt. Colour-coded element popups help the player quickly
# identify what kind of damage is dealt and streamlines the delivery of battle
# information to the audience.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# If you are using elements other than the default set of elements that came
# with a default project of RPG Maker VX Ace, adjust the element colours in the
# module below.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Ace Battle Engine v1.08+ and the
# script must be placed under Ace Battle Engine in the script listing.
# 
#==============================================================================

module YEA
  module ELEMENT_POPUPS
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Setting -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Description
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # This is the default font used for the popups. Adjust them accordingly
    # or even add new ones.
    DEFAULT = ["VL Gothic", "Verdana", "Arial", "Courier"]
    
    # The following are the various rules that govern the individual popup
    # types that will appear. Adjust them accordingly. Here is a list of what
    # each category does.
    #   Zoom1    The zoom the popup starts at. Values over 2.0 may cause lag.
    #   Zoom2    The zoom the popup goes to. Values over 2.0 may cause lag.
    #   Sz       The font size used for the popup text.
    #   Bold     Applying bold for the popup text.
    #   Italic   Applying italic for the popup text.
    #   Red      The red value of the popup text.
    #   Grn      The green value of the popup text.
    #   Blu      The blue value of the popup text.
    #   Font     The font used for the popup text.
    # 
    # Note that if an element doesn't appear here, it'll use the DEFAULT
    # ruleset from Ace Battle Engine.
    COLOURS ={
    # ElementID => [ Zoom1, Zoom2, Sz, Bold, Italic, Red, Grn, Blu, Font]
              3 => [   2.0,   1.0, 36, true,  false, 240,  60,  60, DEFAULT],
              4 => [   2.0,   1.0, 36, true,  false, 100, 200, 246, DEFAULT],
              5 => [   2.0,   1.0, 36, true,  false, 255, 255, 160, DEFAULT],
              6 => [   2.0,   1.0, 36, true,  false,   0, 115, 180, DEFAULT],
              7 => [   2.0,   1.0, 36, true,  false, 240, 135,  80, DEFAULT],
              8 => [   2.0,   1.0, 36, true,  false,  60, 180,  75, DEFAULT],
              9 => [   2.0,   1.0, 36, true,  false, 175, 210, 255, DEFAULT],
             10 => [   2.0,   1.0, 36, true,  false, 110,  80, 130, DEFAULT],
    } # Do not remove this.
    
  end # ELEMENT_POPUPS
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

if $imported["YEA-BattleEngine"]
  
module YEA
  module BATTLE
    module_function
    #--------------------------------------------------------------------------
    # add_element_popups
    #--------------------------------------------------------------------------
    def add_element_popups(hash)
      for key in YEA::ELEMENT_POPUPS::COLOURS
        string = sprintf("ELEMENT_%d", key[0])
        hash[string] = key[1]
      end
      return hash
    end
    #--------------------------------------------------------------------------
    # converted_contants
    #--------------------------------------------------------------------------
    POPUP_RULES = add_element_popups(POPUP_RULES)
  end # BATTLE
end # YEA

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: create_popup
  #--------------------------------------------------------------------------
  alias game_battlerbase_create_popup_elepop create_popup
  def create_popup(value, rules = "DEFAULT", flags = [])
    rules = @element_popup_tag if rules == "HP_DMG" && !@element_popup_tag.nil?
    game_battlerbase_create_popup_elepop(value, rules, flags)
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: item_apply
  #--------------------------------------------------------------------------
  alias game_battler_item_apply_elepop item_apply
  def item_apply(user, item)
    @element_popup_tag = element_popup_tag?(user, item)
    game_battler_item_apply_elepop(user, item)
    @element_popup_tag = nil
  end
  
  #--------------------------------------------------------------------------
  # new method: element_popup_tag?
  #--------------------------------------------------------------------------
  def element_popup_tag?(user, item)
    return "HP_DMG" if item.nil?
    text = "ELEMENT_"
    if item.damage.element_id < 0
      return "HP_DMG" if user.atk_elements.empty?
      rate = elements_max_rate(user.atk_elements)
      for i in user.atk_elements
        next unless element_rate(i) == rate
        text += i.to_s
        break
      end
    else
      text += item.damage.element_id.to_s
    end
    text = "HP_DMG" unless YEA::BATTLE::POPUP_RULES.include?(text)
    return text
  end
  
end # Game_Battler
  
end # $imported["YEA-BattleEngine"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================