#==============================================================================
# 
# ▼ Yanfly Engine Ace - Combat Log Display v1.02
# -- Last Updated: 2012.01.24
# -- Level: Easy
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-CombatLogDisplay"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.24 - Bug Fixed: Confirm window crash with Battle Command List.
# 2012.01.16 - Prevented subsequent line inserts.
# 2011.12.10 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Sometimes text appears way too fast in the battle system or sometimes players
# may miss what kind of information was delivered on-screen. For times like
# that, being able to access the combat log would be important. The combat log
# records all of the text that appears in the battle log window at the top.
# The player can access the combat log display any time during action selection
# phase. Sometimes, players can even review over the combat log to try and
# figure out any kinds of patterns enemies may even have.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module COMBAT_LOG
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Combat Log Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the settings here to modify how the combat log works for your
    # game. You can change the command name and extra text that gets fitted
    # into the combat log over time. If you don't want specific text to appear,
    # just set the text to "" and nothing will show.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMAND_NAME      = "CombatLog"    # Command list name.
    LINE_COLOUR       = 0              # Line colour for separators.
    LINE_COLOUR_ALPHA = 48             # Opacity of the line colour.
    TEXT_BATTLE_START = "\\c[4]Battle Start!"           # Battle start text.
    TEXT_TURN_NUMBER  = "\\c[4]Turn Number: \\c[6]%d"   # Turn number text.
    
  end # COMBAT_LOG
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Window_BattleLog
#==============================================================================

class Window_BattleLog < Window_Selectable
  
  #--------------------------------------------------------------------------
  # new method: combatlog_window=
  #--------------------------------------------------------------------------
  def combatlog_window=(window)
    @combatlog_window = window
  end
  
  #--------------------------------------------------------------------------
  # new method: combatlog
  #--------------------------------------------------------------------------
  def combatlog(text)
    return if @combatlog_window.nil?
    return if text == ""
    @combatlog_window.add_line(text)
  end
  
  #--------------------------------------------------------------------------
  # alias method: add_text
  #--------------------------------------------------------------------------
  alias window_battlelog_add_text_cld add_text
  def add_text(text)
    combatlog(text)
    window_battlelog_add_text_cld(text)
  end
  
  #--------------------------------------------------------------------------
  # alias method: replace_text
  #--------------------------------------------------------------------------
  alias window_battlelog_replace_text_cld replace_text
  def replace_text(text)
    combatlog(text)
    window_battlelog_replace_text_cld(text)
  end
  
  #--------------------------------------------------------------------------
  # Start Ace Battle Engine Compatibility
  #--------------------------------------------------------------------------
  if $imported["YEA-BattleEngine"]
  
  #--------------------------------------------------------------------------
  # alias method: display_current_state
  #--------------------------------------------------------------------------
  alias window_battlelog_display_current_state_cld display_current_state
  def display_current_state(subject)
    window_battlelog_display_current_state_cld(subject)
    return if YEA::BATTLE::MSG_CURRENT_STATE
    return if subject.most_important_state_text.empty?
    combatlog(subject.name + subject.most_important_state_text)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_use_item
  #--------------------------------------------------------------------------
  alias window_battlelog_display_use_item_cld display_use_item
  def display_use_item(subject, item)
    window_battlelog_display_use_item_cld(subject, item)
    return if YEA::BATTLE::MSG_CURRENT_ACTION
    if item.is_a?(RPG::Skill)
      combatlog(subject.name + item.message1)
      unless item.message2.empty?
        combatlog(item.message2)
      end
    else
      combatlog(sprintf(Vocab::UseItem, subject.name, item.name))
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_counter
  #--------------------------------------------------------------------------
  alias window_battlelog_display_counter_cld display_counter
  def display_counter(target, item)
    window_battlelog_display_counter_cld(target, item)
    return if YEA::BATTLE::MSG_COUNTERATTACK
    combatlog(sprintf(Vocab::CounterAttack, target.name))
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_reflection
  #--------------------------------------------------------------------------
  alias window_battlelog_display_reflection_cld display_reflection
  def display_reflection(target, item)
    window_battlelog_display_reflection_cld(target, item)
    return if YEA::BATTLE::MSG_REFLECT_MAGIC
    combatlog(sprintf(Vocab::MagicReflection, target.name))
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_substitute
  #--------------------------------------------------------------------------
  alias window_battlelog_display_substitute_cld display_substitute
  def display_substitute(substitute, target)
    window_battlelog_display_substitute_cld(substitute, target)
    return if YEA::BATTLE::MSG_SUBSTITUTE_HIT
    combatlog(sprintf(Vocab::Substitute, substitute.name, target.name))
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_failure
  #--------------------------------------------------------------------------
  alias window_battlelog_display_failure_cld display_failure
  def display_failure(target, item)
    window_battlelog_display_failure_cld(target, item)
    return if YEA::BATTLE::MSG_FAILURE_HIT
    if target.result.hit? && !target.result.success
      combatlog(sprintf(Vocab::ActionFailure, target.name))
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_critical
  #--------------------------------------------------------------------------
  alias window_battlelog_display_critical_cld display_critical
  def display_critical(target, item)
    window_battlelog_display_critical_cld(target, item)
    return if YEA::BATTLE::MSG_CRITICAL_HIT
    if target.result.critical
      text = target.actor? ? Vocab::CriticalToActor : Vocab::CriticalToEnemy
      combatlog(text)
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_miss
  #--------------------------------------------------------------------------
  alias window_battlelog_display_miss_cld display_miss
  def display_miss(target, item)
    window_battlelog_display_miss_cld(target, item)
    return if YEA::BATTLE::MSG_HIT_MISSED
    if !item || item.physical?
      fmt = target.actor? ? Vocab::ActorNoHit : Vocab::EnemyNoHit
    else
      fmt = Vocab::ActionFailure
    end
    combatlog(sprintf(fmt, target.name))
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_evasion
  #--------------------------------------------------------------------------
  alias window_battlelog_display_evasion_cld display_evasion
  def display_evasion(target, item)
    window_battlelog_display_evasion_cld(target, item)
    return if YEA::BATTLE::MSG_EVASION
    if !item || item.physical?
      fmt = Vocab::Evasion
    else
      fmt = Vocab::MagicEvasion
    end
    combatlog(sprintf(fmt, target.name))
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_hp_damage
  #--------------------------------------------------------------------------
  alias window_battlelog_display_hp_damage_cld display_hp_damage
  def display_hp_damage(target, item)
    window_battlelog_display_hp_damage_cld(target, item)
    return if YEA::BATTLE::MSG_HP_DAMAGE
    return if target.result.hp_damage == 0 && item && !item.damage.to_hp?
    combatlog(target.result.hp_damage_text)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_mp_damage
  #--------------------------------------------------------------------------
  alias window_battlelog_display_mp_damage_cld display_mp_damage
  def display_mp_damage(target, item)
    window_battlelog_display_mp_damage_cld(target, item)
    return if YEA::BATTLE::MSG_MP_DAMAGE
    combatlog(target.result.mp_damage_text)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_tp_damage
  #--------------------------------------------------------------------------
  alias window_battlelog_display_tp_damage_cld display_tp_damage
  def display_tp_damage(target, item)
    window_battlelog_display_tp_damage_cld(target, item)
    return if YEA::BATTLE::MSG_TP_DAMAGE
    combatlog(target.result.tp_damage_text)
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_added_states
  #--------------------------------------------------------------------------
  alias window_battlelog_display_added_states_cld display_added_states
  def display_added_states(target)
    window_battlelog_display_added_states_cld(target)
    return if YEA::BATTLE::MSG_ADDED_STATES
    target.result.added_state_objects.each do |state|
      state_msg = target.actor? ? state.message1 : state.message2
      next if state_msg.empty?
      combatlog(target.name + state_msg)
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_removed_states
  #--------------------------------------------------------------------------
  alias window_battlelog_display_removed_states_cld display_removed_states
  def display_removed_states(target)
    window_battlelog_display_removed_states_cld(target)
    return if YEA::BATTLE::MSG_REMOVED_STATES
    target.result.removed_state_objects.each do |state|
      next if state.message4.empty?
      combatlog(target.name + state.message4)
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: display_buffs
  #--------------------------------------------------------------------------
  alias window_battlelog_display_buffs_cld display_buffs
  def display_buffs(target, buffs, fmt)
    window_battlelog_display_buffs_cld(target, buffs, fmt)
    return if YEA::BATTLE::MSG_CHANGED_BUFFS
    buffs.each do |param_id|
      combatlog(sprintf(fmt, target.name, Vocab::param(param_id)))
    end
  end
  
  #--------------------------------------------------------------------------
  # End Ace Battle Engine Compatibility
  #--------------------------------------------------------------------------
  end # $imported["YEA-BattleEngine"]
  
end # Window_BattleLog

#==============================================================================
# ■ Window_CombatLog
#==============================================================================

class Window_CombatLog < Window_Selectable
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    @data = []
    super(0, 0, Graphics.width, Graphics.height-120)
    deactivate
    hide
  end
  
  #--------------------------------------------------------------------------
  # add_line
  #--------------------------------------------------------------------------
  def add_line(text)
    return if text == "-" && @data[@data.size - 1] == "-"
    @data.push(text)
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    draw_all_items
  end
  
  #--------------------------------------------------------------------------
  # item_max
  #--------------------------------------------------------------------------
  def item_max; return @data.size; end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    text = @data[index]
    return if text.nil?
    rect = item_rect_for_text(index)
    if text == "-"
      draw_horz_line(rect.y)
    else
      draw_text_ex(rect.x, rect.y, text)
    end
  end
  
  #--------------------------------------------------------------------------
  # draw_horz_line
  #--------------------------------------------------------------------------
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(4, line_y, contents_width-8, 2, line_colour)
  end
  
  #--------------------------------------------------------------------------
  # line_colour
  #--------------------------------------------------------------------------
  def line_colour
    colour = text_color(YEA::COMBAT_LOG::LINE_COLOUR)
    colour.alpha = YEA::COMBAT_LOG::LINE_COLOUR_ALPHA
    return colour
  end
  
  #--------------------------------------------------------------------------
  # show
  #--------------------------------------------------------------------------
  def show
    super
    refresh
    activate
    select([item_max-1, 0].max)
  end
  
  #--------------------------------------------------------------------------
  # hide
  #--------------------------------------------------------------------------
  def hide
    deactivate
    super
  end
  
end # Window_CombatLog

#==============================================================================
# ■ Window_PartyCommand
#==============================================================================

class Window_PartyCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: make_command_list
  #--------------------------------------------------------------------------
  alias window_partycommand_make_command_list_cld make_command_list
  def make_command_list
    window_partycommand_make_command_list_cld
    return if $imported["YEA-BattleCommandList"]
    add_command(YEA::COMBAT_LOG::COMMAND_NAME, :combatlog)
  end
  
end # Window_PartyCommand

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_log_window
  #--------------------------------------------------------------------------
  alias scene_battle_create_log_window_cld create_log_window
  def create_log_window
    scene_battle_create_log_window_cld
    create_combatlog_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_combatlog_window
  #--------------------------------------------------------------------------
  def create_combatlog_window
    @combatlog_window = Window_CombatLog.new
    @log_window.combatlog_window = @combatlog_window
    @combatlog_window.set_handler(:cancel, method(:close_combatlog))
    @combatlog_window.add_line("-")
    @combatlog_window.add_line(YEA::COMBAT_LOG::TEXT_BATTLE_START)
    @combatlog_window.add_line("-")
  end
  
  #--------------------------------------------------------------------------
  # new method: open_combatlog
  #--------------------------------------------------------------------------
  def open_combatlog
    @combatlog_window.show
  end
  
  #--------------------------------------------------------------------------
  # new method: close_combatlog
  #--------------------------------------------------------------------------
  def close_combatlog
    @combatlog_window.hide
    if $imported["YEA-BattleCommandList"]
      if !@confirm_command_window.nil? && @confirm_command_window.visible
        @confirm_command_window.activate
      else
        @party_command_window.activate
      end
    else
      @party_command_window.activate
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_party_command_window
  #--------------------------------------------------------------------------
  alias create_party_command_window_cld create_party_command_window
  def create_party_command_window
    create_party_command_window_cld
    @party_command_window.set_handler(:combatlog, method(:open_combatlog))
  end
  
  #--------------------------------------------------------------------------
  # alias method: turn_start
  #--------------------------------------------------------------------------
  alias scene_battle_turn_start_cld turn_start
  def turn_start
    scene_battle_turn_start_cld
    @combatlog_window.add_line("-")
    text = sprintf(YEA::COMBAT_LOG::TEXT_TURN_NUMBER, $game_troop.turn_count)
    @combatlog_window.add_line(text)
    @combatlog_window.add_line("-")
  end
  
  #--------------------------------------------------------------------------
  # alias method: execute_action
  #--------------------------------------------------------------------------
  alias scene_battle_execute_action_cld execute_action
  def execute_action
    @combatlog_window.add_line("-")
    scene_battle_execute_action_cld
    @combatlog_window.add_line("-")
  end
  
  #--------------------------------------------------------------------------
  # alias method: turn_end
  #--------------------------------------------------------------------------
  alias scene_battle_turn_end_cld turn_end
  def turn_end
    scene_battle_turn_end_cld
    @combatlog_window.add_line("-")
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================