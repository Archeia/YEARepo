#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Damage Package - Power v1.00
# -- Last Updated: 2011.12.21
# -- Level: Lunatic
# -- Requires: YEA - Lunatic Damage v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LDP-Power"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.21 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic Damage Package with power themed formulas.
# These formulas will increase the damage dealt depending on whether or not
# the attacker or defender has high or low HP/MP.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic Damage. Then, proceed to use the
# proper effects notetags to apply the proper LDP Power item desired.
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
  # ● Lunatic Damage Package Effects - Power
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These effects are centered around the theme of dealing more damage by
  # various conditions, such as higher or lower HP/MP for the attacker or
  # defender.
  #--------------------------------------------------------------------------
  alias lunatic_damage_extension_ldp2 lunatic_damage_extension
  def lunatic_damage_extension(formula, a, b, item, total_damage)
    user = a; value = 0
    case formula.upcase
    #----------------------------------------------------------------------
    # Power Damage Formula No.1: Attacker High HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates damage formula using the normal damage formula. Depending
    # on how high the attacker's HP is, the damage will increase by +x% or
    # decrease by -x% for every 1% HP the attacker has.
    # 
    # Formula notetag:
    #   <custom damage: attacker high hp +x%>
    #   <custom damage: attacker high hp -x%>
    #----------------------------------------------------------------------
    when /ATTACKER HIGH HP[ ]([\+\-]\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      rate = (user.hp.to_f / user.mhp.to_f) * $1.to_i
      value *= 1.0 + rate
      
    #----------------------------------------------------------------------
    # Power Damage Formula No.2: Attacker High MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates damage formula using the normal damage formula. Depending
    # on how high the attacker's MP is, the damage will increase by +x% or
    # decrease by -x% for every 1% MP the attacker has.
    # 
    # Formula notetag:
    #   <custom damage: attacker high mp +x%>
    #   <custom damage: attacker high mp -x%>
    #----------------------------------------------------------------------
    when /ATTACKER HIGH MP[ ]([\+\-]\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      rate = (user.mp.to_f / [user.mmp, 1].max.to_f) * $1.to_i
      value *= 1.0 + rate
      
    #----------------------------------------------------------------------
    # Power Damage Formula No.3: Attacker Low HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates damage formula using the normal damage formula. Depending
    # on how low the attacker's HP is, the damage will increase by +x% or
    # decrease by -x% for every 1% HP the attacker is missing.
    # 
    # Formula notetag:
    #   <custom damage: attacker low hp +x%>
    #   <custom damage: attacker low hp -x%>
    #----------------------------------------------------------------------
    when /ATTACKER LOW HP[ ]([\+\-]\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      rate = (1.0 - (user.hp.to_f / user.mhp.to_f)) * $1.to_i
      value *= 1.0 + rate
      
    #----------------------------------------------------------------------
    # Power Damage Formula No.4: Attacker Low MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates damage formula using the normal damage formula. Depending
    # on how low the attacker's MP is, the damage will increase by +x% or
    # decrease by -x% for every 1% MP the attacker is missing.
    # 
    # Formula notetag:
    #   <custom damage: attacker low mp +x%>
    #   <custom damage: attacker low mp -x%>
    #----------------------------------------------------------------------
    when /ATTACKER LOW MP[ ]([\+\-]\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      rate = (1.0 - (user.mp.to_f / [user.mmp, 1].max.to_f)) * $1.to_i
      value *= 1.0 + rate
      
    #----------------------------------------------------------------------
    # Power Damage Formula No.5: Defender High HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates damage formula using the normal damage formula. Depending
    # on how high the defender's HP is, the damage will increase by +x% or
    # decrease by -x% for every 1% HP the defender has.
    # 
    # Formula notetag:
    #   <custom damage: defender high hp +x%>
    #   <custom damage: defender high hp -x%>
    #----------------------------------------------------------------------
    when /DEFENDER HIGH HP[ ]([\+\-]\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      rate = (self.hp.to_f / self.mhp.to_f) * $1.to_i
      value *= 1.0 + rate
      
    #----------------------------------------------------------------------
    # Power Damage Formula No.6: Defender High MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates damage formula using the normal damage formula. Depending
    # on how high the defender's MP is, the damage will increase by +x% or
    # decrease by -x% for every 1% MP the defender has.
    # 
    # Formula notetag:
    #   <custom damage: defender high mp +x%>
    #   <custom damage: defender high mp -x%>
    #----------------------------------------------------------------------
    when /DEFENDER HIGH MP[ ]([\+\-]\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      rate = (self.mp.to_f / [self.mmp, 1].max.to_f) * $1.to_i
      value *= 1.0 + rate
      
    #----------------------------------------------------------------------
    # Power Damage Formula No.7: Defender Low HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates damage formula using the normal damage formula. Depending
    # on how low the defender's HP is, the damage will increase by +x% or
    # decrease by -x% for every 1% HP the defender is missing.
    # 
    # Formula notetag:
    #   <custom damage: defender low hp +x%>
    #   <custom damage: defender low hp -x%>
    #----------------------------------------------------------------------
    when /DEFENDER LOW HP[ ]([\+\-]\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      rate = (1.0 - (user.hp.to_f / user.mhp.to_f)) * $1.to_i
      value *= 1.0 + rate
      
    #----------------------------------------------------------------------
    # Power Damage Formula No.8: Defender Low MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates damage formula using the normal damage formula. Depending
    # on how low the defender's MP is, the damage will increase by +x% or
    # decrease by -x% for every 1% MP the defender is missing.
    # 
    # Formula notetag:
    #   <custom damage: defender low mp +x%>
    #   <custom damage: defender low mp -x%>
    #----------------------------------------------------------------------
    when /DEFENDER LOW MP[ ]([\+\-]\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      rate = (1.0 - (user.mp.to_f / [user.mmp, 1].max.to_f)) * $1.to_i
      value *= 1.0 + rate
      
    else
      return lunatic_damage_extension_ldp2(formula, a, b, item, total_damage)
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