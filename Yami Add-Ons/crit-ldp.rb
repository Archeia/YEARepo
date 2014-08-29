$imported = {} if $imported.nil?
$imported["Yami-LDP-Package2"] = true

if $imported["YEA-LunaticDamage"]
class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # ● Lunatic Damage Package Effects - Critical Damage on Specific Targets
  # -------------------------------------------------------------------------
  # This package will focus on critical damage on specific target(s) using
  # normal damage calculation.
  #--------------------------------------------------------------------------
  alias lunatic_damage_extension_yamildp2 lunatic_damage_extension
  def lunatic_damage_extension(formula, a, b, item, total_damage)
    user = a; value = 0
    case formula.upcase
    #----------------------------------------------------------------------
    # Damage Formula No.1: Critical Damage on enemy
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes an enemy with specific ID, damage will be 
    # critical.
    # 
    # Formula notetag:
    #   <custom damage: crit on enemy ID>
    #----------------------------------------------------------------------
    when /CRIT ON ENEMY[ ](\d+)/i
      sid = b.enemy.id if b.enemy?
      @result.critical = true if sid && sid == $1.to_i
      value += item.damage.eval(user, self, $game_variables)
      
    #----------------------------------------------------------------------
    # Damage Formula No.2: Critical Damage on actor
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes an actor with specific ID, damage will be 
    # reverse, heal will become to deal damage, damage will be heal.
    # 
    # Formula notetag:
    #   <custom damage: crit on actor ID>
    #----------------------------------------------------------------------
    when /CRIT ON ACTOR[ ](\d+)/i
      sid = b.actor.id if b.actor?
      @result.critical = true if sid && sid == $1.to_i
      value += item.damage.eval(user, self, $game_variables)
      
    #----------------------------------------------------------------------
    # Damage Formula No.3: Critical Damage for friends
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes a friend, damage will be reverse, 
    # heal will become to deal damage, damage will be heal.
    # 
    # Formula notetag:
    #   <custom damage: crit for friends>
    #----------------------------------------------------------------------
    when /CRIT FOR FRIENDS/i
      friend = (a.actor? && b.actor?) || (a.enemy? && b.enemy?)
      @result.critical = true if friend
      value += item.damage.eval(user, self, $game_variables)
      
    #----------------------------------------------------------------------
    # Damage Formula No.4: Critical Damage for opponents
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes an opponent, damage will be reverse, 
    # heal will become to deal damage, damage will be heal.
    # 
    # Formula notetag:
    #   <custom damage: crit for opponents>
    #----------------------------------------------------------------------
    when /CRIT FOR OPPONENTS/i
      opponent = (a.actor? && b.enemy?) || (a.enemy? && b.actor?)
      @result.critical = true if opponent
      value += item.damage.eval(user, self, $game_variables)
            
    else
      return lunatic_damage_extension_yamildp2(formula, a, b, item, total_damage)
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