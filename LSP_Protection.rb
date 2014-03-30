#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic States Package - Protection v1.00
# -- Last Updated: 2011.12.17
# -- Level: Lunatic
# -- Requires: YEA - Lunatic States v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LSP-Protection"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.17 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic States Package Effects with protection themed
# effects. These effects reduce damage based on various situations and
# conditions, but they overall protect the user.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic States. Then, proceed to use the
# proper effects notetags to apply the proper LSP Protection item desired.
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
  # ● Lunatic States Package Effects - Protection
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These effects are centered around the theme of protection through mostly
  # damage reduction effects.
  #--------------------------------------------------------------------------
  alias lunatic_state_extension_lsp2 lunatic_state_extension
  def lunatic_state_extension(effect, state, user, state_origin, log_window)
    case effect.upcase
    #----------------------------------------------------------------------
    # Protection Effect No.1: Damage Cut
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with react effect. This causes any HP damage under the
    # marked MaxHP percentage to be nullified.
    # 
    # Recommended notetag:
    #   <react effect: damage cut x%>
    #----------------------------------------------------------------------
    when /DAMAGE CUT[ ](\d+)([%％])/i
      return unless @result.hp_damage > 0
      return unless self.mhp * $1.to_i * 0.01 >= @result.hp_damage
      @result.hp_damage = 0
      return unless $imported["YEA-BattleEngine"]
      create_popup(state.name, "IMMU_ELE")
      
    #----------------------------------------------------------------------
    # Protection Effect No.2: Damage Barrier
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with react effect. This causes any HP damage over the
    # marked MaxHP percentage to be nullified.
    # 
    # Recommended notetag:
    #   <react effect: damage barrier x%>
    #----------------------------------------------------------------------
    when /DAMAGE BARRIER[ ](\d+)([%％])/i
      return unless @result.hp_damage > 0
      return unless self.mhp * $1.to_i * 0.01 <= @result.hp_damage
      @result.hp_damage = 0
      return unless $imported["YEA-BattleEngine"]
      create_popup(state.name, "IMMU_ELE")
      
    #----------------------------------------------------------------------
    # Protection Effect No.3: Damage Shelter
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with react effect. This causes any HP damage over the
    # marked MaxHP percentage to be capped at the marked MaxHP percentage.
    # 
    # Recommended notetag:
    #   <react effect: damage shelter x%>
    #----------------------------------------------------------------------
    when /DAMAGE SHELTER[ ](\d+)([%％])/i
      return unless @result.hp_damage > 0
      return unless self.mhp * $1.to_i * 0.01 <= @result.hp_damage
      @result.hp_damage = (self.mhp * $1.to_i * 0.01).to_i
      return unless $imported["YEA-BattleEngine"]
      create_popup(state.name, "REST_ELE")
      
    #----------------------------------------------------------------------
    # Protection Effect No.4: Damage Block
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with react effect. This causes any HP damage to decrease
    # (or increase if you use the + tag) by a set amount. Decreased damage
    # will not go under zero.
    # 
    # Recommended notetag:
    #   <react effect: damage block -x>
    #   <react effect: damage block +x>
    #----------------------------------------------------------------------
    when /DAMAGE BLOCK[ ]([\+\-]\d+)/i
      return unless @result.hp_damage > 0
      @result.hp_damage = [@result.hp_damage + $1.to_i, 0].max
      
    #----------------------------------------------------------------------
    # Protection Effect No.5: Heal Boost
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with react effect. This causes any HP healing done to be
    # increased (or decreased) by a multiplier.
    # 
    # Recommended notetag:
    #   <react effect: heal boost x%>
    #----------------------------------------------------------------------
    when /HEAL BOOST[ ](\d+)([%％])/i
      return unless @result.hp_damage < 0
      @result.hp_damage = (@result.hp_damage * $1.to_i * 0.01).to_i
      
    #----------------------------------------------------------------------
    # Protection Effect No.6: Heal Bonus
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with react effect. This causes any HP healing done to be
    # increased (or decreased) by a set amount. Healing done cannot be
    # changed to damage.
    # 
    # Recommended notetag:
    #   <react effect: heal bonus +x>
    #   <react effect: heal bonus -x>
    #----------------------------------------------------------------------
    when /HEAL BONUS[ ]([\+\-]\d+)/i
      return unless @result.hp_damage < 0
      @result.hp_damage = [@result.hp_damage - $1.to_i, 0].min
      
    #----------------------------------------------------------------------
    # Protection Effect No.7: Persist
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with remove effect. If the user receives damage that would
    # be lethal, there is a chance that the user will persist and live at
    # 1 HP left. 
    # 
    # Recommended notetag:
    #   <react effect: persist x%>
    #----------------------------------------------------------------------
    when /PERSIST[ ](\d+)([%％])/i
      return unless @result.hp_damage >= self.hp
      return if rand > $1.to_i * 0.01
      @result.hp_damage = self.hp - 1
      return unless $imported["YEA-BattleEngine"]
      create_popup(state.name, "WEAK_ELE")
      
    #----------------------------------------------------------------------
    # Stop editting past this point.
    #----------------------------------------------------------------------
    else
      so = state_origin
      lw = log_window
      lunatic_state_extension_lsp2(effect, state, user, so, lw)
    end
  end
  
end # Game_BattlerBase
end # $imported["YEA-LunaticStates"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================