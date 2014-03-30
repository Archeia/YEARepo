#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Targets Package - Conditions v1.00
# -- Last Updated: 2012.01.02
# -- Level: Lunatic
# -- Requires: YEA - Lunatic Targets v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LTP-Conditions"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.02 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic Targets Package Scopes with conditional themed
# scopes. These scopes include targeting a group of units whose stats are above
# or below a certain amount, current HP, MP, or TP is above or below a certain
# percentage, whether or not they're affected by a specific state, or whether
# or not they're affected by all of the specified states.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic Targets. Then, proceed to use the
# proper effects notetags to apply the proper LTP Conditions item desired.
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
  # ● Lunatic Targets Package Scopes - Conditions
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These scopes are centered around the theme of conditions. These scopes
  # will select target from the targeted party based on various conditions
  # such as current percentage of HP, MP, TP, their stats above a certain
  # value, whether or not they're affected by specific states, or whether or
  # not they're affected by all of the specified states.
  #--------------------------------------------------------------------------
  alias lunatic_targets_extension_ltp1 lunatic_targets_extension
  def lunatic_targets_extension(effect, user, smooth_target, targets)
    case effect.upcase
    #----------------------------------------------------------------------
    # Condition Scope No.1: Current Stat Above
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will select all targets in the specified team whose current
    # HP, MP, or TP is x% or above x%. Targets will not be re-added if the
    # targets already exist within the current targeting scope.
    # 
    # Recommended notetag:
    #   <custom target: foes stat above x%>
    #   <custom target: allies stat above x%>
    #   <custom target: every stat above x%>
    # 
    # Replace "stat" with HP, MP, or TP.
    # Replace x with the number percentage requirement.
    #----------------------------------------------------------------------
    when /(.*)[ ](.*)[ ]ABOVE[ ](\d+)([%％])/i
      case $1.upcase
      when "FOE", "FOES", "ENEMY", "ENEMIES"
        group = opponents_unit.members
      when "EVERYBODY", "EVERYONE", "EVERY"
        group = opponents_unit.members + friends_unit.members
      else
        group = friends_unit.members
      end
      for member in group
        case $2.upcase
        when "HP"
          current = member.hp
          maximum = member.mhp
        when "MP"
          current = member.mp
          maximum = member.mmp
        else
          current = member.tp
          maximum = member.max_tp
        end
        next unless current >= $3.to_i * 0.01 * maximum
        targets |= [member]
      end
      
    #----------------------------------------------------------------------
    # Condition Scope No.2: Current Stat Below
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will select all targets in the specified team whose current
    # HP, MP, or TP is x% or below x%. Targets will not be re-added if the
    # targets already exist within the current targeting scope.
    # 
    # Recommended notetag:
    #   <custom target: foes stat below x%>
    #   <custom target: allies stat below x%>
    #   <custom target: every stat below x%>
    # 
    # Replace "stat" with HP, MP, or TP.
    # Replace x with the number percentage requirement.
    #----------------------------------------------------------------------
    when /(.*)[ ](.*)[ ]BELOW[ ](\d+)([%％])/i
      case $1.upcase
      when "FOE", "FOES", "ENEMY", "ENEMIES"
        group = opponents_unit.members
      when "EVERYBODY", "EVERYONE", "EVERY"
        group = opponents_unit.members + friends_unit.members
      else
        group = friends_unit.members
      end
      for member in group
        case $2.upcase
        when "HP"
          current = member.hp
          maximum = member.mhp
        when "MP"
          current = member.mp
          maximum = member.mmp
        else
          current = member.tp
          maximum = member.max_tp
        end
        next unless current <= $3.to_i * 0.01 * maximum
        targets |= [member]
      end
      
    #----------------------------------------------------------------------
    # Condition Scope No.3: Stat Above
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will select all targets in the specified team whose specified
    # stat is x or above x. Targets will not be re-added if the targets
    # already exist within the current targeting scope.
    # 
    # Recommended notetag:
    #   <custom target: foes stat above x>
    #   <custom target: allies stat above x>
    #   <custom target: every stat above x>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    # Replace x with the number requirement.
    #----------------------------------------------------------------------
    when /(.*)[ ](.*)[ ]ABOVE[ ](\d+)/i
      case $1.upcase
      when "FOE", "FOES", "ENEMY", "ENEMIES"
        group = opponents_unit.members
      when "EVERYBODY", "EVERYONE", "EVERY"
        group = opponents_unit.members + friends_unit.members
      else
        group = friends_unit.members
      end
      case $2.upcase
      when "MAXHP"; stat = 0
      when "MAXMP"; stat = 1
      when "ATK";   stat = 2
      when "DEF";   stat = 3
      when "MAT";   stat = 4
      when "MDF";   stat = 5
      when "AGI";   stat = 6
      when "LUK";   stat = 7
      else; return targets
      end
      for member in group
        next unless member.param(stat) >= $3.to_i
        targets |= [member]
      end
      
    #----------------------------------------------------------------------
    # Condition Scope No.4: Stat Below
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will select all targets in the specified team whose specified
    # stat is x or below x. Targets will not be re-added if the targets
    # already exist within the current targeting scope.
    # 
    # Recommended notetag:
    #   <custom target: foes stat below x>
    #   <custom target: allies stat below x>
    #   <custom target: every stat below x>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    # Replace x with the number requirement.
    #----------------------------------------------------------------------
    when /(.*)[ ](.*)[ ]BELOW[ ](\d+)/i
      case $1.upcase
      when "FOE", "FOES", "ENEMY", "ENEMIES"
        group = opponents_unit.members
      when "EVERYBODY", "EVERYONE", "EVERY"
        group = opponents_unit.members + friends_unit.members
      else
        group = friends_unit.members
      end
      case $2.upcase
      when "MAXHP"; stat = 0
      when "MAXMP"; stat = 1
      when "ATK";   stat = 2
      when "DEF";   stat = 3
      when "MAT";   stat = 4
      when "MDF";   stat = 5
      when "AGI";   stat = 6
      when "LUK";   stat = 7
      else; return targets
      end
      for member in group
        next unless member.param(stat) <= $3.to_i
        targets |= [member]
      end
      
    #----------------------------------------------------------------------
    # Condition Scope No.5: Any State
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will select all targets in the specified team who is afflicted
    # by any of the listed states. Targets will not be re-added if the targets
    # already exist within the current targeting scope.
    # 
    # Recommended notetag:
    #   <custom target: foes any state x>
    #   <custom target: foes any state x, x>
    #   <custom target: allies any state x>
    #   <custom target: allies any state x, x>
    #   <custom target: every any state x>
    #   <custom target: every any state x, x>
    # 
    # Replace x with the state's ID.
    #----------------------------------------------------------------------
    when /(.*)[ ]ANY STATE[ ](\d+(?:\s*,\s*\d+)*)/i
      case $1.upcase
      when "FOE", "FOES", "ENEMY", "ENEMIES"
        group = opponents_unit.members
      when "EVERYBODY", "EVERYONE", "EVERY"
        group = opponents_unit.members + friends_unit.members
      else
        group = friends_unit.members
      end
      states = []
      $2.scan(/\d+/).each { |num| states.push(num.to_i) if num.to_i > 0 }
      for member in group
        for state_id in states
          targets |= [member] if member.state?(state_id)
        end
      end
      
    #----------------------------------------------------------------------
    # Condition Scope No.6: All States
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will select all targets in the specified team who is afflicted
    # by all of the listed states. Targets will not be re-added if the
    # targets already exist within the current targeting scope.
    # 
    # Recommended notetag:
    #   <custom target: foes all state x, x>
    #   <custom target: allies all state x, x>
    #   <custom target: every all state x, x>
    # 
    # Replace x with the state's ID.
    #----------------------------------------------------------------------
    when /(.*)[ ]ALL STATE[ ](\d+(?:\s*,\s*\d+)*)/i
      case $1.upcase
      when "FOE", "FOES", "ENEMY", "ENEMIES"
        group = opponents_unit.members
      when "EVERYBODY", "EVERYONE", "EVERY"
        group = opponents_unit.members + friends_unit.members
      else
        group = friends_unit.members
      end
      states = []
      $2.scan(/\d+/).each { |num| states.push(num.to_i) if num.to_i > 0 }
      for member in group
        for state_id in states
          next if member.state?(state_id)
          group -= [member]
        end
      end
      targets |= group
      
    #----------------------------------------------------------------------
    # Stop editting past this point.
    #----------------------------------------------------------------------
    else
      st = smooth_target
      return lunatic_targets_extension_ltp1(effect, user, st, targets)
    end
    if $imported["YEA-BattleEngine"]
      targets.sort! { |a,b| a.screen_x <=> b.screen_x }
    end
    return targets
  end
  
end # Game_BattlerBase
end # $imported["YEA-LunaticTargets"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================