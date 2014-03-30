#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic States Package - Punishment v1.01
# -- Last Updated: 2011.12.15
# -- Level: Lunatic
# -- Requires: YEA - Lunatic States v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LSP-Punishment"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.31 - Bug Fixed: Error with battle popups not showing.
# 2011.12.15 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic States Package Effects with punishment themed
# effects. Included in it are effects that make battlers undead (take damage
# whenever they are healed), make battlers whenever they execute physical or
# magical attacks, make battlers take damage based on the original caster of
# the state's stats, and an effect that heals the original caster of the state
# whenever the battler takes HP or MP damage.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic States. Then, proceed to use the
# proper effects notetags to apply the proper LSP Punishment item desired.
# Look within the script for more instructions on how to use each effect.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires YEA - Lunatic States v1.00+ to work. It must be placed
# under YEA - Lunatic States v1.00+ in the script listing.
# 
#==============================================================================

if $imported["YEA-LunaticStates"]
class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # ● Lunatic States Package Effects - Punishment
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These effects are centered around the theme of punishment. These effects
  # punish users for doing various aspects that may benefit them by harming
  # them in different ways.
  #--------------------------------------------------------------------------
  alias lunatic_state_extension_lsp1 lunatic_state_extension
  def lunatic_state_extension(effect, state, user, state_origin, log_window)
    case effect.upcase
    #----------------------------------------------------------------------
    # Punish Effect No.1: Undead HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with react effect. This causes any HP healing done to become
    # reversed and deal HP damage to the healed target.
    # 
    # Recommended notetag:
    #   <react effect: undead hp>
    #----------------------------------------------------------------------
    when /UNDEAD HP/i
      return unless @result.hp_damage < 0
      @result.hp_damage *= -1
      @result.hp_drain *= -1
      
    #----------------------------------------------------------------------
    # Punish Effect No.2: Undead MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with react effect. This causes any MP healing done to become
    # reversed and deal MP damage to the healed target.
    # 
    # Recommended notetag:
    #   <react effect: undead mp>
    #----------------------------------------------------------------------
    when /UNDEAD MP/i
      return unless @result.mp_damage < 0
      @result.mp_damage *= -1
      @result.mp_drain *= -1
      
    #----------------------------------------------------------------------
    # Punish Effect No.3: Physical Backfire
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with while effect. Whenever the affected battler uses a
    # physical attack, that battler will take HP damage equal to its own
    # stats after finishing the current action. Battler cannot die from
    # this effect.
    # 
    # Recommended notetag:
    #   <while effect: physical backfire stat x%>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    # Replace x with the stat multiplier to affect damage dealt.
    #----------------------------------------------------------------------
    when /PHYSICAL BACKFIRE[ ](.*)[ ](\d+)([%％])/i
      return if user.current_action.nil?
      return unless user.current_action.item.physical?
      case $1.upcase
      when "MAXHP"; dmg = user.mhp
      when "MAXMP"; dmg = user.mmp
      when "ATK";   dmg = user.atk
      when "DEF";   dmg = user.def
      when "MAT";   dmg = user.mat
      when "MDF";   dmg = user.mdf
      when "AGI";   dmg = user.agi
      when "LUK";   dmg = user.luk
      else; return
      end
      dmg = (dmg * $2.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], dmg.group)
        user.create_popup(text, "HP_DMG")
      end
      user.perform_damage_effect
      user.hp = [user.hp - dmg, 1].max
      
    #----------------------------------------------------------------------
    # Punish Effect No.4: Magical Backfire
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with while effect. Whenever the affected battler uses a
    # magical attack, that battler will take HP damage equal to its own
    # stats after finishing the current action. Battler cannot die from
    # this effect.
    # 
    # Recommended notetag:
    #   <while effect: magical backfire stat x%>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    # Replace x with the stat multiplier to affect damage dealt.
    #----------------------------------------------------------------------
    when /MAGICAL BACKFIRE[ ](.*)[ ](\d+)([%％])/i
      return if user.current_action.nil?
      return unless user.current_action.item.magical?
      case $1.upcase
      when "MAXHP"; dmg = user.mhp
      when "MAXMP"; dmg = user.mmp
      when "ATK";   dmg = user.atk
      when "DEF";   dmg = user.def
      when "MAT";   dmg = user.mat
      when "MDF";   dmg = user.mdf
      when "AGI";   dmg = user.agi
      when "LUK";   dmg = user.luk
      else; return
      end
      dmg = (dmg * $2.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], dmg.group)
        user.create_popup(text, "HP_DMG")
      end
      user.perform_damage_effect
      user.hp = [user.hp - dmg, 1].max
      
    #----------------------------------------------------------------------
    # Punish Effect No.5: Stat Slip Damage
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with close effect. At the end of the turn, the affected
    # battler will take HP slip damage based on the stat of the of one who
    # casted the status effect onto the battler. Battler cannot die from
    # this effect.
    # 
    # Recommended notetag:
    #   <close effect: stat slip damage x%>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    # Replace x with the stat multiplier to affect damage dealt.
    #----------------------------------------------------------------------
    when /(.*)[ ]SLIP DAMAGE[ ](\d+)([%％])/i
      case $1.upcase
      when "MAXHP"; dmg = state_origin.mhp
      when "MAXMP"; dmg = state_origin.mmp
      when "ATK";   dmg = state_origin.atk
      when "DEF";   dmg = state_origin.def
      when "MAT";   dmg = state_origin.mat
      when "MDF";   dmg = state_origin.mdf
      when "AGI";   dmg = state_origin.agi
      when "LUK";   dmg = state_origin.luk
      else; return
      end
      dmg = (dmg * $2.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_dmg], dmg.group)
        user.create_popup(text, "HP_DMG")
      end
      user.perform_damage_effect
      user.hp = [user.hp - dmg, 1].max
      
    #----------------------------------------------------------------------
    # Punish Effect No.6: Stat Slip Heal
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with close effect. At the end of the turn, the affected
    # battler will heal HP  based on the stat of the of one who casted the
    # status effect onto the battler.
    # 
    # Recommended notetag:
    #   <close effect: stat slip heal x%>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    # Replace x with the stat multiplier to affect damage dealt.
    #----------------------------------------------------------------------
    when /(.*)[ ]SLIP HEAL[ ](\d+)([%％])/i
      case $1.upcase
      when "MAXHP"; dmg = state_origin.mhp
      when "MAXMP"; dmg = state_origin.mmp
      when "ATK";   dmg = state_origin.atk
      when "DEF";   dmg = state_origin.def
      when "MAT";   dmg = state_origin.mat
      when "MDF";   dmg = state_origin.mdf
      when "AGI";   dmg = state_origin.agi
      when "LUK";   dmg = state_origin.luk
      else; return
      end
      dmg = (dmg * $2.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_heal], dmg.group)
        user.create_popup(text, "HP_HEAL")
      end
      user.perform_damage_effect
      user.hp += dmg
      
    #----------------------------------------------------------------------
    # Punish Effect No.7: Drain HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with shock effect. Whenever user takes HP damage, the
    # original caster of the state will heal HP based on HP damage dealt.
    # 
    # Recommended notetag:
    #   <shock effect: drain hp x%>
    #----------------------------------------------------------------------
    when /DRAIN HP[ ](\d+)([%％])/i
      return unless @result.hp_damage > 0
      dmg = (@result.hp_damage * $1.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        Sound.play_recovery
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:hp_heal], dmg.group)
        user.create_popup(text, "HP_HEAL")
      end
      state_origin.hp += dmg
      
    #----------------------------------------------------------------------
    # Punish Effect No.8: Drain MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with shock effect. Whenever user takes MP damage, the
    # original caster of the state will heal MP based on MP damage dealt.
    # 
    # Recommended notetag:
    #   <shock effect: drain mp x%>
    #----------------------------------------------------------------------
    when /DRAIN MP[ ](\d+)([%％])/i
      return unless @result.mp_damage > 0
      dmg = (@result.mp_damage * $1.to_i * 0.01).to_i
      if $imported["YEA-BattleEngine"] && dmg > 0
        Sound.play_recovery
        text = sprintf(YEA::BATTLE::POPUP_SETTINGS[:mp_heal], dmg.group)
        user.create_popup(text, "MP_HEAL")
      end
      state_origin.mp += dmg
      
    #----------------------------------------------------------------------
    # Stop editting past this point.
    #----------------------------------------------------------------------
    else
      so = state_origin
      lw = log_window
      lunatic_state_extension_lsp1(effect, state, user, so, lw)
    end
  end
  
end # Game_BattlerBase
end # $imported["YEA-LunaticStates"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================