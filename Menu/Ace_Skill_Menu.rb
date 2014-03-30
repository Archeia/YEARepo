#==============================================================================
# 
# ▼ Yanfly Engine Ace - Ace Skill Menu v1.01
# -- Last Updated: 2012.01.08
# -- Level: Normal, Hard
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-SkillMenu"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.08 - Compatibility Update: Learn Skill Engine
# 2012.01.02 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This is a menu reordering script for the Skill Menu for RPG Maker VX Ace. The
# script lets you add, remove, and rearrange skill menu additions added by
# other scripts. This script will update periodically to provide better updated
# compatibility with those other scripts.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Adjust the module's settings to adjust the skill command window.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module SKILL_MENU
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Command Window Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the command window that appears in the skill command window. Add,
    # remove, or rearrange the commands as you see fit. If you would like to
    # add in custom commands, please refer to the custom hash. Here's a list of
    # what does what:
    # 
    # -------------------------------------------------------------------------
    # :command         Description
    # -------------------------------------------------------------------------
    # :stype_list      Displays all of the actor's usable skill types.
    # 
    # :tp_mode         Requires YEA - TP Manager
    # :learn_skill     Requires YEA - Learn Skill Engine
    # 
    # :grathnode       Requires Kread-EX - Grathnode Install
    # :sslots          Requires YSA - Slots Battle
    # 
    # And that's all of the currently available commands. This list will be
    # updated as more scripts become available.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    COMMANDS =[
      :stype_list,   # Displays all of the actor's usable skill types.
      :learn_skill,  # Requires YEA - Learn Skill Engine
      :tp_mode,      # Requires YEA - TP Manager
      :grathnode,    # Requires Kread-EX - Grathnode Install
      :sslots,       # Requires YSA - Slots Battle.
    # :custom1,      # Custom Skill Command 1
    # :custom2,      # Custom Skill Command 2
    ] # Do not remove this.
    
    #--------------------------------------------------------------------------
    # - Skill Custom Commands -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # For those who use scripts to that may produce unique effects for
    # equipping, use this hash to manage the custom commands for the Skill
    # Command Window. You can disable certain commands or prevent them from
    # appearing by using switches. If you don't wish to bind them to a switch,
    # set the proper switch to 0 for it to have no impact.
    #--------------------------------------------------------------------------
    CUSTOM_SKILL_COMMANDS ={
    # :command => ["Display Name", EnableSwitch, ShowSwitch, Handler Method],
      :grathnode => ["Grathnodes",            0,          0, :command_grath],
      :sslots  => [  "Pick Slots",            0,          0, :command_sslot],
      :custom1 => [ "Custom Name",            0,          0, :command_name1],
      :custom2 => [ "Custom Text",           13,          0, :command_name2],
    } # Do not remove this.
    
  end # SKILL_MENU
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :scene_skill_index
  attr_accessor :scene_skill_oy
  
end # Game_Temp

#==============================================================================
# ■ Window_SkillCommand
#==============================================================================

class Window_SkillCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: make_command_list
  #--------------------------------------------------------------------------
  alias window_skillcommand_make_command_list_asm make_command_list
  def make_command_list
    unless SceneManager.scene_is?(Scene_Skill)
      window_skillcommand_make_command_list_asm
      return
    end
    return unless @actor
    for command in YEA::SKILL_MENU::COMMANDS
      case command
      #--- Imported YEA ---
      when :stype_list
        add_skill_types
      #--- Imported YEA ---
      when :tp_mode
        next unless $imported["YEA-TPManager"]
        add_tp_modes
      when :learn_skill
        next unless $imported["YEA-LearnSkillEngine"]
        add_learn_skill_command
      #--- Imported Other ---
      when :grathnode
        next unless $imported["KRX-GrathnodeInstall"]
        process_custom_command(command)
      when :sslots
        next unless $imported["YSA-SlotBattle"]
        process_custom_command(command)
      #--- Custom Commands ---
      else
        process_custom_command(command)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: add_skill_types
  #--------------------------------------------------------------------------
  def add_skill_types
    @actor.added_skill_types.each do |stype_id|
      name = $data_system.skill_types[stype_id]
      add_command(name, :skill, true, stype_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_command
  #--------------------------------------------------------------------------
  def process_custom_command(command)
    return unless YEA::SKILL_MENU::CUSTOM_SKILL_COMMANDS.include?(command)
    show = YEA::SKILL_MENU::CUSTOM_SKILL_COMMANDS[command][2]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = YEA::SKILL_MENU::CUSTOM_SKILL_COMMANDS[command][0]
    switch = YEA::SKILL_MENU::CUSTOM_SKILL_COMMANDS[command][1]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command, enabled, @actor.added_skill_types[0])
  end
  
  #--------------------------------------------------------------------------
  # new method: process_ok
  #--------------------------------------------------------------------------
  def process_ok
    if SceneManager.scene_is?(Scene_Skill)
      $game_temp.scene_skill_index = index
      $game_temp.scene_skill_oy = self.oy
    end
    super
  end
  
end # Window_SkillCommand

#==============================================================================
# ■ Scene_Skill
#==============================================================================

class Scene_Skill < Scene_ItemBase
  
  #--------------------------------------------------------------------------
  # alias method: create_command_window
  #--------------------------------------------------------------------------
  alias scene_skill_create_command_window_asm create_command_window
  def create_command_window
    scene_skill_create_command_window_asm
    if !$game_temp.scene_skill_index.nil? && SceneManager.scene_is?(Scene_Skill)
      @command_window.select($game_temp.scene_skill_index)
      @command_window.oy = $game_temp.scene_skill_oy
    end
    $game_temp.scene_skill_index = nil
    $game_temp.scene_skill_oy = nil
    process_custom_skill_commands
  end
  
  #--------------------------------------------------------------------------
  # new method: process_custom_skill_commands
  #--------------------------------------------------------------------------
  def process_custom_skill_commands
    for command in YEA::SKILL_MENU::COMMANDS
      next unless YEA::SKILL_MENU::CUSTOM_SKILL_COMMANDS.include?(command)
      called_method = YEA::SKILL_MENU::CUSTOM_SKILL_COMMANDS[command][3]
      @command_window.set_handler(command, method(called_method))
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: command_grath
  #--------------------------------------------------------------------------
  def command_grath
    SceneManager.call(Scene_Grathnode)
  end
  
  #--------------------------------------------------------------------------
  # new method: command_sslot
  #--------------------------------------------------------------------------
  def command_sslot
    SceneManager.call(Scene_PickSlots)
  end
  
  #--------------------------------------------------------------------------
  # new method: command_name1
  #--------------------------------------------------------------------------
  def command_name1
    # Do nothing.
  end
  
  #--------------------------------------------------------------------------
  # new method: command_name2
  #--------------------------------------------------------------------------
  def command_name2
    # Do nothing.
  end
  
end # Scene_Skill

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================