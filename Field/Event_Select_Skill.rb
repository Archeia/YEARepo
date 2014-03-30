#==============================================================================
# 
# ▼ Yanfly Engine Ace - Event Select Skill v1.00
# -- Last Updated: 2011.12.12
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-EventSelectSkill"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.12 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script produces a window similar to that of the Select Item Window, but
# instead, it returns the skill's ID to a designated variable. It functions off
# of a script call so read the instructions carefully.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Script Calls - These commands are used with script calls.
# -----------------------------------------------------------------------------
# 
# event_select_skill(variable_id, actor_id)
# event_select_skill(variable_id, actor_id, stype_id)
# This calls forth the skill select window. The variable_id is the variable
# that will receive the skill's ID. The actor_id is where the skill list will
# pull the skills from. If you use the call with the stype_id, it will only
# pull skills from that skill type. Skills are only selectable based on whether
# or not the actor is able to use them.
# 
# event_select_skill_enable_all(variable_id, actor_id)
# event_select_skill_enable_all(variable_id, actor_id, stype_id)
# This will call forth the same skill select window with the same settings.
# However, this time, all of the skills are selectable regardless of whether or
# not the actor can use them.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # new method: event_select_skill
  #--------------------------------------------------------------------------
  def event_select_skill(variable_id, actor_id, stype = 0)
    return unless SceneManager.scene_is?(Scene_Map)
    SceneManager.scene.select_skill(variable_id, actor_id, stype, false)
  end
  
  #--------------------------------------------------------------------------
  # new method: event_select_skill_enable_all
  #--------------------------------------------------------------------------
  def event_select_skill_enable_all(variable_id, actor_id, stype = 0)
    return unless SceneManager.scene_is?(Scene_Map)
    SceneManager.scene.select_skill(variable_id, actor_id, stype, true)
  end
  
end # Game_Interpreter

#==============================================================================
# ■ Window_SkillSelectEvent
#==============================================================================

class Window_SkillSelectEvent < Window_SkillList
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, Graphics.height - 120, Graphics.width, 120)
    deactivate
    self.openness = 0
  end
  
  #--------------------------------------------------------------------------
  # setup
  #--------------------------------------------------------------------------
  def setup(actor_id, stype_id, enable_all)
    @actor = $game_actors[actor_id]
    @stype_id = stype_id
    @enable_all = enable_all
    refresh
    select(0)
    open
    activate
  end
  
  #--------------------------------------------------------------------------
  # include?
  #--------------------------------------------------------------------------
  def include?(item)
    return false if item.nil?
    return true if @stype_id == 0
    return super(item)
  end
  
  #--------------------------------------------------------------------------
  # enable?
  #--------------------------------------------------------------------------
  def enable?(item)
    return true if @enable_all
    return super(item)
  end
  
end # Window_SkillSelectEvent

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_map_create_all_windows_ess create_all_windows
  def create_all_windows
    scene_map_create_all_windows_ess
    create_select_skill_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_select_skill_window
  #--------------------------------------------------------------------------
  def create_select_skill_window
    @select_skill_window = Window_SkillSelectEvent.new
    @select_skill_window.set_handler(:ok, method(:on_skill_select_ok))
    @select_skill_window.set_handler(:cancel, method(:on_skill_select_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: select_skill
  #--------------------------------------------------------------------------
  def select_skill(variable_id, actor_id, stype, enable_all)
    @select_skill_variable = variable_id
    set_select_skill_info(actor_id, stype, enable_all)
    update_select_skill_window
    close_select_skill_window
  end
  
  #--------------------------------------------------------------------------
  # new method: set_select_skill_info
  #--------------------------------------------------------------------------
  def set_select_skill_info(actor_id, stype, enable_all)
    @select_skill_window.y = Graphics.height - @select_skill_window.height
    @select_skill_window.setup(actor_id, stype, enable_all)
  end
  
  #--------------------------------------------------------------------------
  # new method: update_select_skill_window
  #--------------------------------------------------------------------------
  def update_select_skill_window
    loop do
      update_basic
      $game_map.update(false)
      $game_player.update
      $game_timer.update
      @spriteset.update
      break unless @select_skill_window.active
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: close_select_skill_window
  #--------------------------------------------------------------------------
  def close_select_skill_window
    @select_skill_window.close
  end
  
  #--------------------------------------------------------------------------
  # new method: update_select_skill_window
  #--------------------------------------------------------------------------
  def on_skill_select_ok
    $game_variables[@select_skill_variable] = @select_skill_window.item.id
  end
  
  #--------------------------------------------------------------------------
  # new method: update_select_skill_window
  #--------------------------------------------------------------------------
  def on_skill_select_cancel
    $game_variables[@select_skill_variable] = 0
  end
  
end # Scene_Map

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================