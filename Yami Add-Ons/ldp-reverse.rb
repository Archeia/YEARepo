$imported = {} if $imported.nil?
$imported["Yami-LDP-Package1"] = true

if $imported["YEA-LunaticDamage"]
class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # ● Lunatic Damage Package Effects - Package Reverse Damage
  # -------------------------------------------------------------------------
  # This package will focus on reversing damage, which healing skill will be
  # damage skill on some specific situations, and the same for damage skill.
  # 
  # * Notice: Only use one of these below lunatic formula, and always put
  # one of these formula at the end of lunatic formulas list in a skill.
  #--------------------------------------------------------------------------
  alias lunatic_damage_extension_yamildp1 lunatic_damage_extension
  def lunatic_damage_extension(formula, a, b, item, total_damage)
    user = a; value = 0
    case formula.upcase
    #----------------------------------------------------------------------
    # Damage Formula No.1: Reverse Damage on enemy
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes an enemy with specific ID, damage will be 
    # reverse, heal will become to deal damage, damage will be heal.
    # 
    # Formula notetag:
    #   <custom damage: rev on enemy ID>
    #----------------------------------------------------------------------
    when /REV ON ENEMY[ ](\d+)/i
      sid = b.enemy.id if b.enemy?
      value += item.damage.eval(user, self, $game_variables)
      value = total_damage * 2 if total_damage != 0 && sid && sid == $1.to_i
      value = -value if sid && sid == $1.to_i
      
    #----------------------------------------------------------------------
    # Damage Formula No.2: Reverse Damage on actor
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes an actor with specific ID, damage will be 
    # reverse, heal will become to deal damage, damage will be heal.
    # 
    # Formula notetag:
    #   <custom damage: rev on actor ID>
    #----------------------------------------------------------------------
    when /REV ON ACTOR[ ](\d+)/i
      sid = b.actor.id if b.actor?
      value += item.damage.eval(user, self, $game_variables)
      value = total_damage * 2 if total_damage != 0 && sid && sid == $1.to_i
      value = -value if sid && sid == $1.to_i
      
    #----------------------------------------------------------------------
    # Damage Formula No.3: Reverse Damage for friends
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes a friend, damage will be reverse, 
    # heal will become to deal damage, damage will be heal.
    # 
    # Formula notetag:
    #   <custom damage: rev for friends>
    #----------------------------------------------------------------------
    when /REV FOR FRIENDS/i
      friend = (a.actor? && b.actor?) || (a.enemy? && b.enemy?)
      value += item.damage.eval(user, self, $game_variables)
      value = total_damage * 2 if total_damage != 0 && friend
      value = -value if friend
      
    #----------------------------------------------------------------------
    # Damage Formula No.4: Reverse Damage for opponents
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the attacker strikes an opponent, damage will be reverse, 
    # heal will become to deal damage, damage will be heal.
    # 
    # Formula notetag:
    #   <custom damage: rev for opponents>
    #----------------------------------------------------------------------
    when /REV FOR OPPONENTS/i
      opponent = (a.actor? && b.enemy?) || (a.enemy? && b.actor?)
      value += item.damage.eval(user, self, $game_variables)
      value = total_damage * 2 if total_damage != 0 && opponent
      value = -value if opponent
      
    #----------------------------------------------------------------------
    # Damage Formula No.5: Reverse Damage random
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This skill will be either damage or healing skill randomly. This formula
    # will have a chance to be reversed.
    # 
    # Formula notetag:
    #   <custom damage: rev random X%>
    #----------------------------------------------------------------------
    when /REV RANDOM[ ](\d+)([%％])/i
      reverse = $1.to_i <= (rand(100) + 1)
      value += item.damage.eval(user, self, $game_variables)
      value = total_damage * 2 if total_damage != 0 && reverse
      value = -value if reverse
            
    else
      return lunatic_damage_extension_yamildp1(formula, a, b, item, total_damage)
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