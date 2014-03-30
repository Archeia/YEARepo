#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Objects Package - Recoil
# -- Last Updated: 2012.01.14
# -- Level: Lunatic
# -- Requires: YEA - Lunatic Objects v1.02+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LOP-Recoil"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.14 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic Objects Package Effects with recoil themed
# effects. Upon attacking the target, the user of a skill/item can take damage
# through either a set amount of a percentage of the damage dealt.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic Objects. Then, proceed to use the
# proper before, prepare, during, or after effects notetags to apply the proper
# LOP Recoil item desired. Look within the script for more instructions on how
# to use each effect.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires YEA - Lunatic Objects v1.00+ to work. It must be placed
# under YEA - Lunatic Objects v1.00+ in the script listing.
# 
#==============================================================================

if $imported["YEA-LunaticObjects"]
class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Lunatic Objects Package Effects - Recoil
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These effects are centered around the theme of recoil effects for skills
  # and items, such as dealing damage and to have a percentage of it return
  # back to the user or a set amount of damage returned back to the user.
  #--------------------------------------------------------------------------
  alias lunatic_object_extension_lop3 lunatic_object_extension
  def lunatic_object_extension(effect, item, user, target, line_number)
    case effect.upcase
    #----------------------------------------------------------------------
    # Recoil Effect No.1: Recoil Set HP Damage
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will return exactly x amount of HP damage to the user regardless
    # of how much damage the user has dealt to the target. The user can die
    # from this effect.
    # 
    # Recommended notetag:
    #   <during effect: recoil x hp damage>
    #----------------------------------------------------------------------
    when /RECOIL[ ](\d+)[ ]HP DAMAGE/i
      dmg = $1.to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], dmg.group)
        user.create_popup(text, "HP_DMG")
      end
      user.hp -= dmg
      text = sprintf("%s takes %s recoil damage!", user.name, dmg.group)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
      
    #----------------------------------------------------------------------
    # Recoil Effect No.2: Recoil Set MP Damage
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will return exactly x amount of MP damage to the user regardless
    # of how much damage the user has dealt to the target.
    # 
    # Recommended notetag:
    #   <during effect: recoil x mp damage>
    #----------------------------------------------------------------------
    when /RECOIL[ ](\d+)[ ]MP DAMAGE/i
      dmg = $1.to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:mp_dmg], dmg.group)
        user.create_popup(text, "MP_DMG")
      end
      user.mp -= dmg
      vocab = Vocab::mp
      text = sprintf("%s loses %s %s from recoil!", user.name, dmg.group, vocab)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
      
    #----------------------------------------------------------------------
    # Recoil Effect No.3: Recoil Set TP Damage
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will return exactly x amount of TP damage to the user regardless
    # of how much damage the user has dealt to the target.
    # 
    # Recommended notetag:
    #   <during effect: recoil x tp damage>
    #----------------------------------------------------------------------
    when /RECOIL[ ](\d+)[ ]TP DAMAGE/i
      dmg = $1.to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:tp_dmg], dmg.group)
        user.create_popup(text, "TP_DMG")
      end
      user.mp -= dmg
      vocab = Vocab::tp
      text = sprintf("%s loses %s %s from recoil!", user.name, dmg.group, vocab)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
      
    #----------------------------------------------------------------------
    # Recoil Effect No.4: Recoil Percent HP Damage
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will return a percentage of the damage dealt as HP damage to
    # the user. This will factor in both HP damage dealt to the target and
    # MP damage dealt to the target. The user can die from this effect.
    # 
    # Recommended notetag:
    #   <during effect: recoil x% hp damage>
    #----------------------------------------------------------------------
    when /RECOIL[ ](\d+)([%％])[ ]HP DAMAGE/i
      dmg = ($1.to_i * 0.01 * target.result.hp_damage).to_i
      dmg += ($1.to_i * 0.01 * target.result.mp_damage).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], dmg.group)
        user.create_popup(text, "HP_DMG")
      end
      user.hp -= dmg
      text = sprintf("%s takes %s recoil damage!", user.name, dmg.group)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
      
    #----------------------------------------------------------------------
    # Recoil Effect No.5: Recoil Percent MP Damage
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will return a percentage of the damage dealt as MP damage to
    # the user. This will factor in both HP damage dealt to the target and
    # MP damage dealt to the target. 
    # 
    # Recommended notetag:
    #   <during effect: recoil x% mp damage>
    #----------------------------------------------------------------------
    when /RECOIL[ ](\d+)([%％])[ ]MP DAMAGE/i
      dmg = ($1.to_i * 0.01 * target.result.hp_damage).to_i
      dmg += ($1.to_i * 0.01 * target.result.mp_damage).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:mp_dmg], dmg.group)
        user.create_popup(text, "MP_DMG")
      end
      user.mp -= dmg
      vocab = Vocab::mp
      text = sprintf("%s loses %s %s from recoil!", user.name, dmg.group, vocab)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
      
    #----------------------------------------------------------------------
    # Recoil Effect No.6: Recoil Percent TP Damage
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will return a percentage of the damage dealt as MP damage to
    # the user. This will factor in both HP damage dealt to the target and
    # MP damage dealt to the target. 
    # 
    # Recommended notetag:
    #   <during effect: recoil x% tp damage>
    #----------------------------------------------------------------------
    when /RECOIL[ ](\d+)([%％])[ ]TP DAMAGE/i
      dmg = ($1.to_i * 0.01 * target.result.hp_damage).to_i
      dmg += ($1.to_i * 0.01 * target.result.mp_damage).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:tp_dmg], dmg.group)
        user.create_popup(text, "TP_DMG")
      end
      user.mp -= dmg
      vocab = Vocab::tp
      text = sprintf("%s loses %s %s from recoil!", user.name, dmg.group, vocab)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
      
    #----------------------------------------------------------------------
    # Stop editting past this point.
    #----------------------------------------------------------------------
    else
      lunatic_object_extension_lop3(effect, item, user, target, line_number)
    end
  end # lunatic_object_extension
  
end # Scene_Battle
end # $imported["YEA-LunaticObjects"]

#==============================================================================
# ■ Numeric
#==============================================================================

class Numeric
  
  #--------------------------------------------------------------------------
  # new method: group_digits
  #--------------------------------------------------------------------------
  unless $imported["YEA-CoreEngine"]
  def group; return self.to_s; end
  end # $imported["YEA-CoreEngine"]
    
end # Numeric

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================