#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Damage Package - Critical v1.01
# -- Last Updated: 2012.02.12
# -- Level: Lunatic
# -- Requires: YEA - Lunatic Damage v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LDP-Critical"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.02.12 - Bug Fixed: Typo between Critical Bonus and Critical Boost.
# 2011.12.20 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic Damage Package with critical themed formulas.
# Critical hits here can be triggered with various guarantees or increased
# chances depending on circumstances.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic Damage. Then, proceed to use the
# proper effects notetags to apply the proper LDP Critical item desired.
# Look within the script for more instructions on how to use each effect.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires YEA - Lunatic Damage v1.00+ to work. It must be placed
# under YEA - Lunatic Damage v1.00+ in the script listing.
# 
#==============================================================================

if $imported["YEA-LunaticDamage"]
class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # ● Lunatic Damage Package Effects - Critical
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These effects are centered around the theme of dealing more damage by
  # actively triggering critical hits through various conditions (such as
  # low HP, low MP, how full the TP gauge is, and more).
  #--------------------------------------------------------------------------
  alias lunatic_damage_extension_ldp1 lunatic_damage_extension
  def lunatic_damage_extension(formula, a, b, item, total_damage)
    user = a; value = 0
    case formula.upcase
    #----------------------------------------------------------------------
    # Critical Damage Formula No.1: Attacker HP Crisis
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes while his/her HP is under x%, then the attack
    # will cause a guaranteed critical hit using the normal damage formula.
    # 
    # Formula notetag:
    #   <custom damage: attacker hp crisis x%>
    #----------------------------------------------------------------------
    when /ATTACKER HP CRISIS[ ](\d+)([%％])/i
      rate = $1.to_i * 0.01
      @result.critical = true if user.hp <= user.mhp * rate
      value += item.damage.eval(user, self, $game_variables)
      
    #----------------------------------------------------------------------
    # Critical Damage Formula No.2: Attacker MP Crisis
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes while his/her MP is under x%, then the attack
    # will cause a guaranteed critical hit using the normal damage formula.
    # 
    # Formula notetag:
    #   <custom damage: attacker mp crisis x%>
    #----------------------------------------------------------------------
    when /ATTACKER MP CRISIS[ ](\d+)([%％])/i
      rate = $1.to_i * 0.01
      @result.critical = true if user.mp <= user.mmp * rate
      value += item.damage.eval(user, self, $game_variables)
      
    #----------------------------------------------------------------------
    # Critical Damage Formula No.3: Defender HP Crisis
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes while the defender's HP is under x%, then
    # the attack will cause a guaranteed critical hit using the normal
    # damage formula.
    # 
    # Formula notetag:
    #   <custom damage: defender hp crisis x%>
    #----------------------------------------------------------------------
    when /DEFENDER HP CRISIS[ ](\d+)([%％])/i
      rate = $1.to_i * 0.01
      @result.critical = true if self.hp <= self.mhp * rate
      value += item.damage.eval(user, self, $game_variables)
      
    #----------------------------------------------------------------------
    # Critical Damage Formula No.4: Defender MP Crisis
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes while the defender's MP is under x%, then
    # the attack will cause a guaranteed critical hit using the normal
    # damage formula.
    # 
    # Formula notetag:
    #   <custom damage: defender mp crisis x%>
    #----------------------------------------------------------------------
    when /DEFENDER MP CRISIS[ ](\d+)([%％])/i
      rate = $1.to_i * 0.01
      @result.critical = true if self.mp <= self.mmp * rate
      value += item.damage.eval(user, self, $game_variables)
      
    #----------------------------------------------------------------------
    # Critical Damage Formula No.5: High TP Critical
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This causes the attack's critical hit rate to be influenced by how
    # high the attacker's TP is (relative to the attacker's MaxTP). Then,
    # the attack will use the normal damage formula.
    # 
    # Formula notetag:
    #   <custom damage: high tp critical>
    #----------------------------------------------------------------------
    when /HIGH TP CRITICAL/i
      rate = 1.0 * user.tp / user.max_tp
      @result.critical = (rand < rate)
      value += item.damage.eval(user, self, $game_variables)
      
    #----------------------------------------------------------------------
    # Critical Damage Formula No.6: Low TP Critical
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This causes the attack's critical hit rate to be influenced by how
    # low the attacker's TP is (relative to the attacker's MaxTP). Then,
    # the attack will use the normal damage formula.
    # 
    # Formula notetag:
    #   <custom damage: low tp critical>
    #----------------------------------------------------------------------
    when /LOW TP CRITICAL/i
      rate = 1.0 * (user.max_tp - user.tp) / user.max_tp
      @result.critical = (rand < rate)
      value += item.damage.eval(user, self, $game_variables)
      
    #----------------------------------------------------------------------
    # Critical Damage Formula No.7: Critical Boost
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker lands a critical hit, the damage dealt will have an
    # additional multiplier on top of the critical multiplier. Best used
    # with another damage formula.
    # 
    # Formula notetag:
    #   <custom damage: critical boost +x%>
    #   <custom damage: critical boost -x%>
    #----------------------------------------------------------------------
    when /CRITICAL BOOST[ ]([\+\-]\d+)([%％])/i
      rate = $1.to_i * 0.01 + 1.0
      value = total_damage * rate if @result.critical
      
    #----------------------------------------------------------------------
    # Critical Damage Formula No.8: Critical Bonus
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker lands a critical hit, the damage dealt will have an
    # additional bonus added on top of the critical multiplier. Best used
    # with another damage formula.
    # 
    # Formula notetag:
    #   <custom damage: critical bonus +x>
    #   <custom damage: critical bonus -x>
    #----------------------------------------------------------------------
    when /CRITICAL BONUS[ ]([\+\-]\d+)/i
      bonus = $1.to_i
      value += bonus if @result.critical
      
    else
      return lunatic_damage_extension_ldp1(formula, a, b, item, total_damage)
    end
    return value
  end
  
end # Game_Battler
end # $imported["YEA-LunaticDamage"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================