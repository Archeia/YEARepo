#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Damage Package - Gemini v1.00
# -- Last Updated: 2011.12.22
# -- Level: Lunatic
# -- Requires: YEA - Lunatic Damage v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LDP-Gemini"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.22 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic Damage Package with "Gemini" themed formulas.
# This script causes damage to be dealt to both HP and MP with various formats
# such as a percentage of the main damage dealt, set damage, a percentage of
# one's MaxHP or MaxMP, or even custom formulas.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic Damage. Then, proceed to use the
# proper effects notetags to apply the proper LDP Gemini item desired.
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
  # ● Lunatic Damage Package Effects - Gemini
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These effects are centered around the theme of dealing damage to both
  # HP and MP through various means.
  #--------------------------------------------------------------------------
  alias lunatic_damage_extension_ldp3 lunatic_damage_extension
  def lunatic_damage_extension(formula, a, b, item, total_damage)
    user = a; value = 0
    case formula
    #----------------------------------------------------------------------
    # Gemini Damage Formula No.1: Gemini MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates main damage formula using the normal damage formula. After
    # that, a percentage of damage dealt to HP will be dealt to MP. MP
    # damage will not be affected by elements, guarding, and/or other
    # damage modifiers.
    # 
    # Formula notetag:
    #   <custom damage: gemini mp x%>
    #----------------------------------------------------------------------
    when /GEMINI MP[ ](\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      @result.mp_damage += ($1.to_i * 0.01 * value).to_i
      
    #----------------------------------------------------------------------
    # Gemini Damage Formula No.2: Gemini HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates main damage formula using the normal damage formula. After
    # that, a percentage of damage dealt to MP will be dealt to HP. MP
    # damage will not be affected by elements, guarding, and/or other
    # damage modifiers.
    # 
    # Formula notetag:
    #   <custom damage: gemini hp x%>
    #----------------------------------------------------------------------
    when /GEMINI HP[ ](\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      @result.hp_damage += ($1.to_i * 0.01 * value).to_i
      
    #----------------------------------------------------------------------
    # Gemini Damage Formula No.3: Gemini Set MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates main damage formula using the normal damage formula. After
    # that, set damage will be dealt to MP. MP damage will not be affected
    # by elements, guarding, and/or other damage modifiers.
    # 
    # Formula notetag:
    #   <custom damage: gemini set mp +x>
    #   <custom damage: gemini set mp -x>
    #----------------------------------------------------------------------
    when /GEMINI SET MP[ ]([\+\-]\d+)/i
      value += item.damage.eval(user, self, $game_variables)
      @result.mp_damage += $1.to_i
      
    #----------------------------------------------------------------------
    # Gemini Damage Formula No.4: Gemini Set HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates main damage formula using the normal damage formula. After
    # that, set damage will be dealt to HP. HP damage will not be affected
    # by elements, guarding, and/or other damage modifiers.
    # 
    # Formula notetag:
    #   <custom damage: gemini set hp +x>
    #   <custom damage: gemini set hp -x>
    #----------------------------------------------------------------------
    when /GEMINI SET HP[ ]([\+\-]\d+)/i
      value += item.damage.eval(user, self, $game_variables)
      @result.hp_damage += $1.to_i
      
    #----------------------------------------------------------------------
    # Gemini Damage Formula No.5: Gemini Percent MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates main damage formula using the normal damage formula. After
    # that, a percentage of the defender's MP will be depleted. MP damage
    # will not be affected by elements, guarding, and/or other damage
    # modifiers.
    # 
    # Formula notetag:
    #   <custom damage: gemini per mp +x%>
    #   <custom damage: gemini per mp -x%>
    #----------------------------------------------------------------------
    when /GEMINI PER MP[ ]([\+\-]\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      @result.mp_damage += ($1.to_i * 0.01 * self.mmp).to_i
      
    #----------------------------------------------------------------------
    # Gemini Damage Formula No.6: Gemini Percent HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates main damage formula using the normal damage formula. After
    # that, a percentage of the defender's HP will be depleted. HP damage
    # will not be affected by elements, guarding, and/or other damage
    # modifiers.
    # 
    # Formula notetag:
    #   <custom damage: gemini per hp +x%>
    #   <custom damage: gemini per hp -x%>
    #----------------------------------------------------------------------
    when /GEMINI PER HP[ ]([\+\-]\d+)([%％])/i
      value += item.damage.eval(user, self, $game_variables)
      @result.hp_damage += ($1.to_i * 0.01 * self.mhp).to_i
      
    #----------------------------------------------------------------------
    # Gemini Damage Formula No.7: Gemini Eval MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates main damage formula using the normal damage formula. After
    # that, the damage dealt to MP will be calculated with another formula.
    # MP damage will not be affected by elements, guarding, and/or other
    # damage modifiers.
    # 
    # Formula notetag:
    #   <custom damage>
    #    gemini eval mp: formula
    #   </custom damage>
    #----------------------------------------------------------------------
    when /GEMINI EVAL MP:[ ](.*)/i
      value += item.damage.eval(user, self, $game_variables)
      @result.mp_damage += (eval($1.to_s)).to_i
      
    #----------------------------------------------------------------------
    # Gemini Damage Formula No.8: Gemini Eval HP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Calculates main damage formula using the normal damage formula. After
    # that, the damage dealt to HP will be calculated with another formula.
    # MP damage will not be affected by elements, guarding, and/or other
    # damage modifiers.
    # 
    # Formula notetag:
    #   <custom damage>
    #    gemini eval hp: formula
    #   </custom damage>
    #----------------------------------------------------------------------
    when /GEMINI EVAL HP:[ ](.*)/i
      value += item.damage.eval(user, self, $game_variables)
      @result.hp_damage += (eval($1.to_s)).to_i
      
    else
      return lunatic_damage_extension_ldp3(formula, a, b, item, total_damage)
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