#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Targets Package - Mathematics v1.00
# -- Last Updated: 2012.01.07
# -- Level: Lunatic
# -- Requires: YEA - Lunatic Targets v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LTP-Mathematics"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.07 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic Targets Package Scopes with the theme of
# selecting targets based on various math properties such as selecting odd
# numbers, even numbers, numbers divisible by certain values, or prime numbers.
# These targets are indiscriminant of allies or enemies unless specified.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic Targets. Then, proceed to use the
# proper effects notetags to apply the proper LTP Mathematics item desired.
# Look within the script for more instructions on how to use each effect.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires YEA - Lunatic Targets v1.00+ to work. It must be placed
# under YEA - Lunatic Targets v1.00+ in the script listing.
# 
#==============================================================================

if $imported["YEA-LunaticTargets"]
class Game_Action
  
  #--------------------------------------------------------------------------
  # ● Lunatic Targets Package Scopes - Mathematics
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These scopes are centered around the theme of creating targets based on
  # various math such as stats divisible by a certain number, stats that are
  # odd or even, or stats that are prime. These targeting scopes are
  # indiscriminant of allies or enemies with the exception of levels and EXP.
  # Levels will be actors only unless Yanfly Engine Ace - Enemy Levels is
  # installed. EXP will be strictly actors only.
  #--------------------------------------------------------------------------
  alias lunatic_targets_extension_ltp2 lunatic_targets_extension
  def lunatic_targets_extension(effect, user, smooth_target, targets)
    case effect.upcase
    #----------------------------------------------------------------------
    # Mathematics Scope No.1: Divisible
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will select all targets from both groups of allies and enemies
    # whose specified stat is divisible by a certain number. Any battlers
    # who don't meet the requirements will not be affected by targeting.
    # 
    # Recommended notetag:
    #   <custom target: stat divisible x>
    # 
    # Replace "stat" with MaxHP, MaxMP, HP, MP, TP, Level, EXP, ATK, DEF,
    # MAT, MDF, AGI, or LUK.
    # Replace x with the number to meet the conditions of.
    #----------------------------------------------------------------------
    when /(.*)[ ]DIVISIBLE[ ](\d+)/i
      modifier = $2.to_i == 0 ? 1 : $2.to_i
      for member in $game_troop.alive_members + $game_party.alive_members
        case $1.upcase
        when "MAXHP", "MHP"
          next unless member.mhp % modifier == 0
        when "MAXMP", "MMP", "MAXSP", "MSP"
          next unless member.mmp % modifier == 0
        when "HP"
          next unless member.hp % modifier == 0
        when "MP", "SP"
          next unless member.mp % modifier == 0
        when "TP"
          next unless member.tp % modifier == 0
        when "LEVEL"
          next if !$imported["YEA-EnemyLevels"] && !member.actor?
          next unless member.level % modifier == 0
        when "EXP"
          next unless member.actor?
          next unless member.exp % modifier == 0
        when "ATK"
          next unless member.atk % modifier == 0
        when "DEF"
          next unless member.def % modifier == 0
        when "MAT", "INT", "SPI"
          next unless member.mat % modifier == 0
        when "MDF", "RES"
          next unless member.mdf % modifier == 0
        when "AGI"
          next unless member.agi % modifier == 0
        when "LUK"
          next unless member.luk % modifier == 0
        else; next
        end
        targets |= [member]
      end
      
    #----------------------------------------------------------------------
    # Mathematics Scope No.2: Even Number
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will select all targets from both groups of allies and enemies
    # whose specified stat is an even number. Any battlers who don't meet
    # the requirements will not be affected by targeting.
    # 
    # Recommended notetag:
    #   <custom target: stat even>
    # 
    # Replace "stat" with MaxHP, MaxMP, HP, MP, TP, Level, EXP, ATK, DEF,
    # MAT, MDF, AGI, or LUK.
    #----------------------------------------------------------------------
    when /(.*)[ ]EVEN/i
      modifier = 2
      for member in $game_troop.alive_members + $game_party.alive_members
        case $1.upcase
        when "MAXHP", "MHP"
          next unless member.mhp % modifier == 0
        when "MAXMP", "MMP", "MAXSP", "MSP"
          next unless member.mmp % modifier == 0
        when "HP"
          next unless member.hp % modifier == 0
        when "MP", "SP"
          next unless member.mp % modifier == 0
        when "TP"
          next unless member.tp % modifier == 0
        when "LEVEL"
          next if !$imported["YEA-EnemyLevels"] && !member.actor?
          next unless member.level % modifier == 0
        when "EXP"
          next unless member.actor?
          next unless member.exp % modifier == 0
        when "ATK"
          next unless member.atk % modifier == 0
        when "DEF"
          next unless member.def % modifier == 0
        when "MAT", "INT", "SPI"
          next unless member.mat % modifier == 0
        when "MDF", "RES"
          next unless member.mdf % modifier == 0
        when "AGI"
          next unless member.agi % modifier == 0
        when "LUK"
          next unless member.luk % modifier == 0
        else; next
        end
        targets |= [member]
      end
      
    #----------------------------------------------------------------------
    # Mathematics Scope No.3: Odd Number
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will select all targets from both groups of allies and enemies
    # whose specified stat is an odd number. Any battlers who don't meet
    # the requirements will not be affected by targeting.
    # 
    # Recommended notetag:
    #   <custom target: stat odd>
    # 
    # Replace "stat" with MaxHP, MaxMP, HP, MP, TP, Level, EXP, ATK, DEF,
    # MAT, MDF, AGI, or LUK.
    #----------------------------------------------------------------------
    when /(.*)[ ]ODD/i
      modifier = 2
      for member in $game_troop.alive_members + $game_party.alive_members
        case $1.upcase
        when "MAXHP", "MHP"
          next unless member.mhp % modifier != 0
        when "MAXMP", "MMP", "MAXSP", "MSP"
          next unless member.mmp % modifier != 0
        when "HP"
          next unless member.hp % modifier != 0
        when "MP", "SP"
          next unless member.mp % modifier != 0
        when "TP"
          next unless member.tp % modifier != 0
        when "LEVEL"
          next if !$imported["YEA-EnemyLevels"] && !member.actor?
          next unless member.level % modifier != 0
        when "EXP"
          next unless member.actor?
          next unless member.exp % modifier != 0
        when "ATK"
          next unless member.atk % modifier != 0
        when "DEF"
          next unless member.def % modifier != 0
        when "MAT", "INT", "SPI"
          next unless member.mat % modifier != 0
        when "MDF", "RES"
          next unless member.mdf % modifier != 0
        when "AGI"
          next unless member.agi % modifier != 0
        when "LUK"
          next unless member.luk % modifier != 0
        else; next
        end
        targets |= [member]
      end
      
    #----------------------------------------------------------------------
    # Mathematics Scope No.4: Prime Number
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will select all targets from both groups of allies and enemies
    # whose specified stat is a prime number. Any battlers who don't meet
    # the requirements will not be affected by targeting.
    # 
    # Recommended notetag:
    #   <custom target: stat prime>
    # 
    # Replace "stat" with MaxHP, MaxMP, HP, MP, TP, Level, EXP, ATK, DEF,
    # MAT, MDF, AGI, or LUK.
    #----------------------------------------------------------------------
    when /(.*)[ ]ODD/i
      for member in $game_troop.alive_members + $game_party.alive_members
        case $1.upcase
        when "MAXHP", "MHP"
          next unless member.mhp.prime?
        when "MAXMP", "MMP", "MAXSP", "MSP"
          next unless member.mmp.prime?
        when "HP"
          next unless member.hp.prime?
        when "MP", "SP"
          next unless member.mp.prime?
        when "TP"
          next unless member.tp.prime?
        when "LEVEL"
          next if !$imported["YEA-EnemyLevels"] && !member.actor?
          next unless member.level.prime?
        when "EXP"
          next unless member.actor?
          next unless member.exp.prime?
        when "ATK"
          next unless member.atk.prime?
        when "DEF"
          next unless member.def.prime?
        when "MAT", "INT", "SPI"
          next unless member.mat.prime?
        when "MDF", "RES"
          next unless member.mdf.prime?
        when "AGI"
          next unless member.agi.prime?
        when "LUK"
          next unless member.luk.prime?
        else; next
        end
        targets |= [member]
      end
      
    #----------------------------------------------------------------------
    # Stop editting past this point.
    #----------------------------------------------------------------------
    else
      st = smooth_target
      return lunatic_targets_extension_ltp2(effect, user, st, targets)
    end
    if $imported["YEA-BattleEngine"]
      targets.sort! { |a,b| a.screen_x <=> b.screen_x }
    end
    return targets
  end
  
end # Game_BattlerBase
end # $imported["YEA-LunaticTargets"]

#==============================================================================
# ■ Numeric
#==============================================================================

class Numeric
  
  #--------------------------------------------------------------------------
  # new method: prime?
  #--------------------------------------------------------------------------
  def prime?
    n = self.abs
    return false if n < 2
    2.upto(Math.sqrt(n).to_i) { |i|  return false if n % i == 0 }
    return true
  end
    
end # Numeric

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================