#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Objects Package - Give & Take
# -- Last Updated: 2011.12.27
# -- Level: Lunatic
# -- Requires: YEA - Lunatic Objects v1.02+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LOP-Give&Take"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.27 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic Objects Package Effects with give & take themed
# effects. With this script, the user and target will transfer states, buffs,
# and debuffs from one another.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic Objects. Then, proceed to use the
# proper before, prepare, during, or after effects notetags to apply the proper
# LOP Give & Take item desired. Look within the script for more instructions on
# how to use each effect.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires YEA - Lunatic Objects v1.00+ to work. It must be placed
# under YEA - Lunatic Objects v1.00+ in the script listing.
# 
#==============================================================================

if $imported["YEA-LunaticObjects"]
class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Lunatic Objects Package Effects - Give & Take
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These effects are centered around the theme of giving and taking from a
  # target, be it an enemy or an ally. The user and target transfers states,
  # buffs, and debuffs to and from each other depending on the effect.
  #--------------------------------------------------------------------------
  alias lunatic_object_extension_lop2 lunatic_object_extension
  def lunatic_object_extension(effect, item, user, target, line_number)
    case effect.upcase
    #----------------------------------------------------------------------
    # Give & Take Effect No.1: Give State
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the user is inflicted with state x, it will transfer the state
    # over to the target. However, if the user is not inflicted with the
    # specific state, no transfers will occur.
    # 
    # Recommended notetag:
    #   <prepare effect: give state x>
    #   <prepare effect: give state x, x>
    #      - or -
    #   <during effect: give state x>
    #   <during effect: give state x, x>
    #----------------------------------------------------------------------
    when /GIVE STATE[ ]*(\d+(?:\s*,\s*\d+)*)/i
      array = []
      $1.scan(/\d+/).each { |num| array.push(num.to_i) if num.to_i > 0 }
      for i in array
        break if user == target
        next unless user.state?(i)
        user.remove_state(i)
        target.add_state(i)
      end
      
    #----------------------------------------------------------------------
    # Give & Take Effect No.2: Take State
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the target is inflicted with state x, it will transfer the state
    # over to the user. However, if the target is not inflicted with the
    # specific state, no transfers will occur.
    # 
    # Recommended notetag:
    #   <prepare effect: take state x>
    #   <prepare effect: take state x, x>
    #      - or -
    #   <during effect: take state x>
    #   <during effect: take state x, x>
    #----------------------------------------------------------------------
    when /TAKE STATE[ ]*(\d+(?:\s*,\s*\d+)*)/i
      array = []
      $1.scan(/\d+/).each { |num| array.push(num.to_i) if num.to_i > 0 }
      for i in array
        break if user == target
        next unless target.state?(i)
        target.remove_state(i)
        user.add_state(i)
      end
      
    #----------------------------------------------------------------------
    # Give & Take Effect No.3: Give Buff
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the user has stat x buffed, it will transfer the buff over to the
    # target. However, if the user does not have stat x buffed, no effects
    # will occur.
    # 
    # Recommended notetag:
    #   <prepare effect: give buff stat>
    #      - or -
    #   <during effect: give buff stat>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    #----------------------------------------------------------------------
    when /GIVE BUFF[ ](.*)/i
      return if user == target
      case $1.upcase
      when "MAXHP"; param_id = 0
      when "MAXMP"; param_id = 1
      when "ATK";   param_id = 2
      when "DEF";   param_id = 3
      when "MAT";   param_id = 4
      when "MDF";   param_id = 5
      when "AGI";   param_id = 6
      when "LUK";   param_id = 7
      else; return
      end
      return unless user.buff?(param_id)
      user.add_debuff(param_id, 3)
      target.add_buff(param_id, 3)
      
    #----------------------------------------------------------------------
    # Give & Take Effect No.4: Take Buff
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the target has stat x buffed, it will transfer the buff over to
    # the user. However, if the target does not have stat x buffed, no
    # effects will occur.
    # 
    # Recommended notetag:
    #   <prepare effect: take buff stat>
    #      - or -
    #   <during effect: take buff stat>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    #----------------------------------------------------------------------
    when /TAKE BUFF[ ](.*)/i
      return if user == target
      case $1.upcase
      when "MAXHP"; param_id = 0
      when "MAXMP"; param_id = 1
      when "ATK";   param_id = 2
      when "DEF";   param_id = 3
      when "MAT";   param_id = 4
      when "MDF";   param_id = 5
      when "AGI";   param_id = 6
      when "LUK";   param_id = 7
      else; return
      end
      return unless target.buff?(param_id)
      target.add_debuff(param_id, 3)
      user.add_buff(param_id, 3)
      
    #----------------------------------------------------------------------
    # Give & Take Effect No.5: Give Debuff
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the user has stat x debuffed, it will transfer the buff over to
    # the target. However, if the user does not have stat x debuffed, no
    # effects will occur.
    # 
    # Recommended notetag:
    #   <prepare effect: give debuff stat>
    #      - or -
    #   <during effect: give debuff stat>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    #----------------------------------------------------------------------
    when /GIVE DEBUFF[ ](.*)/i
      return if user == target
      case $1.upcase
      when "MAXHP"; param_id = 0
      when "MAXMP"; param_id = 1
      when "ATK";   param_id = 2
      when "DEF";   param_id = 3
      when "MAT";   param_id = 4
      when "MDF";   param_id = 5
      when "AGI";   param_id = 6
      when "LUK";   param_id = 7
      else; return
      end
      return unless user.debuff?(param_id)
      user.add_buff(param_id, 3)
      target.add_debuff(param_id, 3)
      
    #----------------------------------------------------------------------
    # Give & Take Effect No.6: Take Debuff
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # If the target has stat x debuffed, it will transfer the buff over to
    # the user. However, if the target does not have stat x debuffed, no
    # effects will occur.
    # 
    # Recommended notetag:
    #   <prepare effect: take buff stat>
    #      - or -
    #   <during effect: take buff stat>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    #----------------------------------------------------------------------
    when /TAKE BUFF[ ](.*)/i
      return if user == target
      case $1.upcase
      when "MAXHP"; param_id = 0
      when "MAXMP"; param_id = 1
      when "ATK";   param_id = 2
      when "DEF";   param_id = 3
      when "MAT";   param_id = 4
      when "MDF";   param_id = 5
      when "AGI";   param_id = 6
      when "LUK";   param_id = 7
      else; return
      end
      return unless target.debuff?(param_id)
      target.add_buff(param_id, 3)
      user.add_debuff(param_id, 3)
      
    #----------------------------------------------------------------------
    # Stop editting past this point.
    #----------------------------------------------------------------------
    else
      lunatic_object_extension_lop2(effect, item, user, target, line_number)
    end
  end # lunatic_object_extension
  
end # Scene_Battle
end # $imported["YEA-LunaticObjects"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================