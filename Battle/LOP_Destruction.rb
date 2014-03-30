#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Objects Package - Destruction
# -- Last Updated: 2011.12.27
# -- Level: Lunatic
# -- Requires: YEA - Lunatic Objects v1.00+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LOP-Destruction"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.27 - Tag changes for "Debuff" and "Buff".
# 2011.12.14 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a script for Lunatic Objects Package Effects with destruction themed
# effects. These effects include things such as suicide effects, emptying MP,
# emptying TP, and more.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Install this script under YEA - Lunatic Objects. Then, proceed to use the
# proper before, during, or after effects notetags to apply the proper LOP
# Destruction item desired. Look within the script for more instructions on how
# to use each effect.
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
  # ● Lunatic Objects Package Effects - Destruction
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # These effects are centered around the theme of self destruction. These
  # effects will cause the user harm even if the user is targeting someone
  # other than the user itself.
  #--------------------------------------------------------------------------
  alias lunatic_object_extension_lop1 lunatic_object_extension
  def lunatic_object_extension(effect, item, user, target, line_number)
    case effect.upcase
    #----------------------------------------------------------------------
    # Destruction Effect No.1: Suicide
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with after effect. This causes the user to suicide (and
    # bring the user's HP down to 0) and adds a message saying that the
    # user has died.
    # 
    # Recommended notetag:
    #   <after effect: suicide>
    #----------------------------------------------------------------------
    when /SUICIDE/i
      user.hp = 0
      user.perform_collapse_effect
      status_redraw_target(target)
      text = sprintf("%s dies!", user.name)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
    
    #----------------------------------------------------------------------
    # Destruction Effect No.2: Empty MP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with after effect. This causes the user's MP to hit zero
    # after performing the skill.
    # 
    # Recommended notetag:
    #   <after effect: empty mp>
    #----------------------------------------------------------------------
    when /EMPTY MP/i
      user.mp = 0
      text = sprintf("%s's MP empties out!", user.name)
      status_redraw_target(target)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
    
    #----------------------------------------------------------------------
    # Destruction Effect No.3: Empty TP
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Best used with after effect. This causes the user's TP to hit zero
    # after performing the skill.
    # 
    # Recommended notetag:
    #   <after effect: empty tp>
    #----------------------------------------------------------------------
    when /EMPTY TP/i
      user.tp = 0
      text = sprintf("%s's TP runs out!", user.name)
      status_redraw_target(target)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
    
    #----------------------------------------------------------------------
    # Destruction Effect No.4: Add State
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This can be used as either a before effect or after effect. This will
    # inflict the user with a status effect at the particular interval
    # during the usage of that skill such as poisoning oneself.
    # 
    # Recommended notetag:
    #   <before effect: add state x>
    #   <after effect: add state x>
    #----------------------------------------------------------------------
    when /ADD STATE[ ](\d+)/i
      state_id = $1.to_i
      target.add_state(state_id)
      return unless target.state?(state_id)
      status_redraw_target(target)
      state = $data_states[state_id]
      state_msg = target.actor? ? state.message1 : state.message2
      return if state_msg.empty?
      text = target.name + state_msg
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
    
    #----------------------------------------------------------------------
    # Destruction Effect No.5: Remove State
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This can be used as either a before effect or after effect. This will
    # remove a state from the user at the particular interval during the
    # usage of that skill such as removing an elemental protection shield.
    # 
    # Recommended notetag:
    #   <before effect: remove state x>
    #   <after effect: remove state x>
    #----------------------------------------------------------------------
    when /REMOVE STATE[ ](\d+)/i
      state_id = $1.to_i
      return unless target.state?(state_id)
      target.remove_state(state_id)
      status_redraw_target(target)
      state = $data_states[state_id]
      state_msg = state.message4
      return if state_msg.empty?
      text = target.name + state_msg
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
    
    #----------------------------------------------------------------------
    # Destruction Effect No.6: Debuff Stat
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This can be used as either a before effect or after effect. This will
    # cause the user's stat to drop during that interval in time.
    # 
    # Recommended notetag:
    #   <before effect: add debuff stat>
    #   <after effect: add debuff stat>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    #----------------------------------------------------------------------
    when /ADD DEBUFF[ ](.*)/i
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
      target.add_debuff(param_id, 3)
      status_redraw_target(target)
      text = sprintf("%s's %s drops!", user.name, $1.upcase)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
    
    #----------------------------------------------------------------------
    # Destruction Effect No.7: Buff Stat
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This can be used as either a before effect or after effect. This will
    # cause the user's stat to rise during that interval in time.
    # 
    # Recommended notetag:
    #   <before effect: add buff stat>
    #   <after effect: add buff stat>
    # 
    # Replace "stat" with MAXHP, MAXMP, ATK, DEF, MAT, MDF, AGI, or LUK.
    #----------------------------------------------------------------------
    when /ADD BUFF[ ](.*)/i
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
      target.add_buff(param_id, 3)
      status_redraw_target(target)
      text = sprintf("%s's %s rises!", user.name, $1.upcase)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
    
    #----------------------------------------------------------------------
    # Destruction Effect No.8: Clear States
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This can be used as either a before effect or after effect. This will
    # cause the user's states to clear completely.
    # 
    # Recommended notetag:
    #   <before effect: clear states>
    #   <after effect: clear states>
    #----------------------------------------------------------------------
    when /CLEAR STATES/i
      target.clear_states
      status_redraw_target(target)
      text = sprintf("%s removes all status effects!", user.name)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
    
    #----------------------------------------------------------------------
    # Destruction Effect No.9: Clear Buffs
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # This can be used as either a before effect or after effect. This will
    # cause the user's buffs to clear completely.
    # 
    # Recommended notetag:
    #   <before effect: clear buffs>
    #   <after effect: clear buffs>
    #----------------------------------------------------------------------
    when /CLEAR BUFFS/i
      target.clear_buffs
      status_redraw_target(target)
      text = sprintf("%s loses all buffs!", user.name)
      @log_window.add_text(text)
      3.times do @log_window.wait end
      @log_window.back_one
      
    #----------------------------------------------------------------------
    # Stop editting past this point.
    #----------------------------------------------------------------------
    else
      lunatic_object_extension_lop1(effect, item, user, target, line_number)
    end
  end # lunatic_object_extension
  
end # Scene_Battle
end # $imported["YEA-LunaticObjects"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================