#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Parameters Package - Empower v1.00
# -- Last Updated: 2012.01.26
# -- Level: Lunatic
# -- Requires: YEA - Lunatic Parameters v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LPP-Empower"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.26 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic Parameters Package Effects with power up themed
# boosts. The script provides the ability to increase a stat based on how high
# or low HP, MP, or TP is, whether or not an actor, class, or enemy type is
# present or absent. For those with Mr. Bubbles' Gender Functions script, you
# can also increase parameters based on how many male, female, or genderless
# members are in the battler's party.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic Parameters. Then, proceed to use the
# proper effects notetags to apply the proper LPP Empower item desired. Look
# within the script for more instructions on how to use each effect.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires YEA - Lunatic Parameters v1.00+ to work. It must be
# placed under YEA - Lunatic Parameters v1.00+ in the script listing.
# 
#==============================================================================

if $imported["YEA-LunaticParameters"]
class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # ● Lunatic Parameters Package Effects - Empower
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These effects are centered around the theme of powering up from various
  # conditions. These effects can increase parameters based on HP, MP, or TP,
  # whether or not actors, classes, or enemies are present or absent, and for
  # those with Mr. Bubbles' Gender Functions, even go as far as increasing a
  # parameter based on how many team members of a particular gender are in
  # the current party.
  #--------------------------------------------------------------------------
  alias lunatic_param_extension_lpp1 lunatic_param_extension
  def lunatic_param_extension(total, base, param_id, trait)
    target = current_target
    subject = current_subject
    case trait
    #----------------------------------------------------------------------
    # Empower Effect No.1: Low HP/MP/TP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # The lower the battler's HP/MP/TP, the bigger the boost to the param.
    # For every 1% stat is missing from the max, the battler gains a +x%
    # boost to the specified stat.
    # 
    # Recommended notetag:
    #   <custom param: low stat +x%>
    #   <custom param: low stat -x%>
    # 
    # Replace param with one of the following:
    # MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, or ALL
    # 
    # Replace stat with HP, MP, or TP.
    # There will be no effect to the parameter if it matches the stat.
    #----------------------------------------------------------------------
    when /LOW[ ](.*)[ ]([\+\-]\d+)([%％])/i
      case $1.upcase
      when "HP"
        return total if param_id == 0
        current = self.hp.to_f
        maximum = [self.mhp.to_f, 1].max
      when "MP"
        return total if param_id == 1
        current = self.mp.to_f
        maximum = [self.mmp.to_f, 1].max
      when "TP"
        current = self.tp.to_f
        maximum = [self.max_tp.to_f, 1].max
      end
      rate = (1.0 - current / maximum) * $2.to_i
      total += base * rate
      
    #----------------------------------------------------------------------
    # Empower Effect No.2: High HP/MP/TP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # The higher the battler's HP/MP/TP, the bigger the boost to the param.
    # For every 1% stat is filled relative to max, the battler gains a +x%
    # boost to the specified stat.
    # 
    # Recommended notetag:
    #   <custom param: high stat +x%>
    #   <custom param: high stat -x%>
    # 
    # Replace param with one of the following:
    # MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, or ALL
    # 
    # Replace stat with HP, MP, or TP.
    # There will be no effect to the parameter if it matches the stat.
    #----------------------------------------------------------------------
    when /HIGH[ ](.*)[ ]([\+\-]\d+)([%％])/i
      case $1.upcase
      when "HP"
        return total if param_id == 0
        current = self.hp.to_f
        maximum = [self.mhp.to_f, 1].max
      when "MP"
        return total if param_id == 1
        current = self.mp.to_f
        maximum = [self.mmp.to_f, 1].max
      when "TP"
        current = self.tp.to_f
        maximum = [self.max_tp.to_f, 1].max
      end
      rate = (current / maximum) * $2.to_i
      total += base * rate
      
    #----------------------------------------------------------------------
    # Empower Effect No.3: Actor Present
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will increase the battler's stats if actor x is present in
    # battle (meaning that if the actor is in the reserves or hasn't joined
    # this effect will not take effect).
    # 
    # Recommended notetag:
    #   <custom param: present actor x +y%>
    #   <custom param: present actor x -y%>
    # 
    # Replace param with one of the following:
    # MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, or ALL
    # 
    # Replace x with the desired actor's ID.
    # Replace y with the bonus percent applied.
    #----------------------------------------------------------------------
    when /PRESENT ACTOR[ ](\d+)[ ]([\+\-]\d+)([%％])/i
      actor = $game_actors[$1.to_i]
      return total unless $game_party.battle_members.include?(actor)
      rate = $2.to_i * 0.01
      total += base * rate
      
    #----------------------------------------------------------------------
    # Empower Effect No.4: Actor Absent
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will increase the battler's stats if actor x is absent in
    # battle (meaning that if the actor is in the reserves or hasn't joined
    # this effect will take effect).
    # 
    # Recommended notetag:
    #   <custom param: absent actor x +y%>
    #   <custom param: absent actor x -y%>
    # 
    # Replace param with one of the following:
    # MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, or ALL
    # 
    # Replace x with the desired actor's ID.
    # Replace y with the bonus percent applied.
    #----------------------------------------------------------------------
    when /ABSENT ACTOR[ ](\d+)[ ]([\+\-]\d+)([%％])/i
      actor = $game_actors[$1.to_i]
      return total if $game_party.battle_members.include?(actor)
      rate = $2.to_i * 0.01
      total += base * rate
      
    #----------------------------------------------------------------------
    # Empower Effect No.5: Class Present
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will increase the battler's stats if class x is present in
    # battle meaning that if there is an actor with class x in battle, the
    # battler's stats will increase.
    # 
    # Recommended notetag:
    #   <custom param: present class x +y%>
    #   <custom param: present class x -y%>
    # 
    # Replace param with one of the following:
    # MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, or ALL
    # 
    # Replace x with the desired class's ID.
    # Replace y with the bonus percent applied.
    #----------------------------------------------------------------------
    when /PRESENT CLASS[ ](\d+)[ ]([\+\-]\d+)([%％])/i
      class_id = $1.to_i
      success = false
      for member in $game_party.alive_members
        success = true if member.class_id == class_id
      end
      return total unless success
      rate = $2.to_i * 0.01
      total += base * rate
      
    #----------------------------------------------------------------------
    # Empower Effect No.6: Class Absent
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will increase the battler's stats if class x is absent in
    # battle meaning that if there is an actor with class x in battle, the
    # battler's stats will not increase.
    # 
    # Recommended notetag:
    #   <custom param: absent class x +y%>
    #   <custom param: absent class x -y%>
    # 
    # Replace param with one of the following:
    # MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, or ALL
    # 
    # Replace x with the desired class's ID.
    # Replace y with the bonus percent applied.
    #----------------------------------------------------------------------
    when /ABSENT CLASS[ ](\d+)[ ]([\+\-]\d+)([%％])/i
      class_id = $1.to_i
      success = true
      for member in $game_party.alive_members
        success = false if member.class_id == class_id
      end
      return total unless success
      rate = $2.to_i * 0.01
      total += base * rate
      
    #----------------------------------------------------------------------
    # Empower Effect No.7: Enemy Present
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will increase the battler's stats if enemy x is present in
    # battle meaning that if there is an enemy type of x in battle, the
    # battler's stats will increase.
    # 
    # Recommended notetag:
    #   <custom param: present enemy x +y%>
    #   <custom param: present enemy x -y%>
    # 
    # Replace param with one of the following:
    # MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, or ALL
    # 
    # Replace x with the desired enemy's ID.
    # Replace y with the bonus percent applied.
    #----------------------------------------------------------------------
    when /PRESENT ENEMY[ ](\d+)[ ]([\+\-]\d+)([%％])/i
      enemy_id = $1.to_i
      success = false
      for member in $game_troop.alive_members
        success = true if member.enemy_id == enemy_id
      end
      return total unless success
      rate = $2.to_i * 0.01
      total += base * rate
      
    #----------------------------------------------------------------------
    # Empower Effect No.8: Enemy Absent
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This will increase the battler's stats if enemy x is absent in
    # battle meaning that if there is an enemy type of x in battle, the
    # battler's stats will not increase.
    # 
    # Recommended notetag:
    #   <custom param: absent enemy x +y%>
    #   <custom param: absent enemy x -y%>
    # 
    # Replace param with one of the following:
    # MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, or ALL
    # 
    # Replace x with the desired enemy's ID.
    # Replace y with the bonus percent applied.
    #----------------------------------------------------------------------
    when /ABSENT ENEMY[ ](\d+)[ ]([\+\-]\d+)([%％])/i
      enemy_id = $1.to_i
      success = true
      for member in $game_troop.alive_members
        success = false if member.enemy_id == enemy_id
      end
      return total unless success
      rate = $2.to_i * 0.01
      total += base * rate
      
    #----------------------------------------------------------------------
    # Empower Effect No.9: Gender Power
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This function requires Mr. Bubbles' Gender Functions script installed
    # to work. This will increase the battler's parameter by x% for every
    # specified gender in the battler's party.
    # 
    # Recommended notetag:
    #   <custom param: girl power +x%>
    #   <custom param: guy power +x%>
    #   <custom param: sairen power +x%>
    # 
    # Replace param with one of the following:
    # MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, LUK, or ALL
    # 
    # Replace x with the bonus percent applied.
    #----------------------------------------------------------------------
    when /(.*)[ ]POWER[ ]([\+\-]\d+)([%％])/i
      return total unless $imported["BubsGenderFunctions"]
      case $1.upcase
      when "BOY", "MALE", "GUY", "MAN"
        gender = 1
      when "GIRL", "FEMALE", "GAL", "WOMAN"
        gender = 2
      else
        gender = 0
      end
      rate = 0.0
      for member in friends_unit.alive_members
        case gender
        when 1; rate += $2.to_i * 0.01 if member.male?
        when 2; rate += $2.to_i * 0.01 if member.female
        else;   rate += $2.to_i * 0.01 if member.genderless?
        end
      end
      puts rate
      total += base * rate
      
    else
      return lunatic_param_extension_lpp1(total, base, param_id, trait)
    end
    return total
  end
  
end # Game_BattlerBase
end # $imported["YEA-LunaticParameters"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================