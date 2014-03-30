#==============================================================================
# 
# ▼ Yanfly Engine Ace - Command Autobattle v1.01
# -- Last Updated: 2011.12.26
# -- Level: Normal
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-CommandAutobattle"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.26 - Bug Fixed: Autobattle cancelled after each battle.
# 2011.12.12 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Anyone remember the Autobattle command from RPG Maker 2000? Well, now it's
# back and you can choose to tack it onto the Party Command Window or the Actor
# Command Window. When autobattle is selected, it will let the game determine
# what action to use for the party and/or actors depending on the game's A.I.
# 
# Furthermore, there is an option to have Autobattle continously remain in
# effect if selected from the Party Command Window. When Autobattle is selected
# in the Actor Command Window, it'll cause the game to automatically choose an
# action for that actor instead.
# 
# In addition to this, there exists the functionality of having all battle
# members but the first member autobattle. This feature can be turned off.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# Adjust the settings in the module to your liking.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
#==============================================================================

module YEA
  module AUTOBATTLE
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Party Autobattle Command Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the command settings for Autobattle under the Party Command Window
    # here. If you decide to let Party Autobattle be continuous, it will keep
    # going until the player decides to cancel it with X.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ENABLE_PARTY_AUTOBATTLE = true      # Enables autobattle in Party Window.
    PARTY_COMMAND_NAME  = "Auto"        # Text that appears for Autobattle.
    PARTY_SHOW_SWITCH   = 0             # Switch used to show Autobattle.
    PARTY_ENABLE_SWITCH = 0             # Switch used to enable Autobattle.
    # Note: For both of the switches, if they are set to 0, then the feature
    # will not be used at all. The command will always be shown and/or the
    # command will always be enabled.
    
    # These settings adjust continous autobattle. If enabled, these settings
    # will be applied. Otherwise, they won't be.
    ENABLE_CONTINOUS = true             # If true, autobattle is continous.
    DISABLE_MESSAGE = "Press Cancel to turn off Autobattle."
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Actor Autobattle Command Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the command settings for Autobattle under the Actor Command Window
    # here. Actors do not have continous autobattle. Instead, they just simply
    # choose whatever action the game decides is most suitable for them.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ENABLE_ACTOR_AUTOBATTLE = true      # Enables autobattle in Party Window.
    ACTOR_COMMAND_NAME  = "Auto"        # Text that appears for Autobattle.
    ACTOR_SHOW_SWITCH   = 0             # Switch used to show Autobattle.
    ACTOR_ENABLE_SWITCH = 0             # Switch used to enable Autobattle.
    # Note: For both of the switches, if they are set to 0, then the feature
    # will not be used at all. The command will always be shown and/or the
    # command will always be enabled.
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Secondary Members Autobattle -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # For those who only want to grant command control to the first actor in
    # battle, enable the setting below. All of the battle members who aren't
    # first in line will automatically choose their action for the turn.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ENABLE_SECONDARY_AUTOBATTLE = false
    
  end # AUTOBATTLE
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

#==============================================================================
# ■ BattleManager
#==============================================================================

module BattleManager
  
  #--------------------------------------------------------------------------
  # alias method: process_victory
  #--------------------------------------------------------------------------
  class <<self; alias battlemanager_process_victory_cab process_victory; end
  def self.process_victory
    SceneManager.scene.close_disable_autobattle_window
    return battlemanager_process_victory_cab
  end
  
  #--------------------------------------------------------------------------
  # alias method: process_abort
  #--------------------------------------------------------------------------
  class <<self; alias battlemanager_process_abort_cab process_abort; end
  def self.process_abort
    SceneManager.scene.close_disable_autobattle_window
    return battlemanager_process_abort_cab
  end
  
  #--------------------------------------------------------------------------
  # alias method: process_defeat
  #--------------------------------------------------------------------------
  class <<self; alias battlemanager_process_defeat_cab process_defeat; end
  def self.process_defeat
    SceneManager.scene.close_disable_autobattle_window
    return battlemanager_process_defeat_cab
  end
  
end # BattleManager

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :continous_autobattle
  
end # Game_Temp

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # alias method: auto_battle?
  #--------------------------------------------------------------------------
  alias game_battlerbase_auto_battle_cab auto_battle?
  def auto_battle?
    return true if continuous_autobattle?
    return true if secondary_auto_battle?
    return game_battlerbase_auto_battle_cab
  end
  
  #--------------------------------------------------------------------------
  # new method: continuous_autobattle?
  #--------------------------------------------------------------------------
  def continuous_autobattle?
    return false unless actor?
    return $game_temp.continous_autobattle
  end
  
  #--------------------------------------------------------------------------
  # new method: secondary_auto_battle?
  #--------------------------------------------------------------------------
  def secondary_auto_battle?
    return false unless actor?
    return false if index == 0
    return YEA::AUTOBATTLE::ENABLE_SECONDARY_AUTOBATTLE
  end
  
end # Game_BattlerBase

#==============================================================================
# ■ Game_Unit
#==============================================================================

class Game_Unit
  
  #--------------------------------------------------------------------------
  # alias method: make_actions
  #--------------------------------------------------------------------------
  alias game_unit_make_actions_cab make_actions
  def make_actions
    game_unit_make_actions_cab
    refresh_autobattler_status_window
  end
  
  #--------------------------------------------------------------------------
  # new method: refresh_autobattler_status_window
  #--------------------------------------------------------------------------
  def refresh_autobattler_status_window
    return unless SceneManager.scene_is?(Scene_Battle)
    return unless self.is_a?(Game_Party)
    SceneManager.scene.refresh_autobattler_status_window
  end
  
end # Game_Unit

#==============================================================================
# ■ Window_PartyCommand
#==============================================================================

class Window_PartyCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: make_command_list
  #--------------------------------------------------------------------------
  alias window_partycommand_cab make_command_list
  def make_command_list
    window_partycommand_cab
    return if $imported["YEA-BattleCommandList"]
    add_autobattle_command if YEA::AUTOBATTLE::ENABLE_PARTY_AUTOBATTLE
  end
  
  #--------------------------------------------------------------------------
  # new method: add_autobattle_command
  #--------------------------------------------------------------------------
  def add_autobattle_command
    return unless show_autobattle?
    text = YEA::AUTOBATTLE::PARTY_COMMAND_NAME
    add_command(text, :autobattle, enable_autobattle?)
  end
  
  #--------------------------------------------------------------------------
  # new method: show_autobattle?
  #--------------------------------------------------------------------------
  def show_autobattle?
    return true if YEA::AUTOBATTLE::PARTY_SHOW_SWITCH <= 0
    return $game_switches[YEA::AUTOBATTLE::PARTY_SHOW_SWITCH]
  end
  
  #--------------------------------------------------------------------------
  # new method: enable_autobattle?
  #--------------------------------------------------------------------------
  def enable_autobattle?
    return true if YEA::AUTOBATTLE::PARTY_ENABLE_SWITCH <= 0
    return $game_switches[YEA::AUTOBATTLE::PARTY_ENABLE_SWITCH]
  end
  
end # Window_PartyCommand

#==============================================================================
# ■ Window_ActorCommand
#==============================================================================

class Window_ActorCommand < Window_Command
  
  #--------------------------------------------------------------------------
  # alias method: make_command_list
  #--------------------------------------------------------------------------
  alias window_actorcommand_make_command_list_cab make_command_list
  def make_command_list
    return if @actor.nil?
    unless $imported["YEA-BattleCommandList"]
      add_autobattle_command if YEA::AUTOBATTLE::ENABLE_ACTOR_AUTOBATTLE
    end
    window_actorcommand_make_command_list_cab
  end
  
  #--------------------------------------------------------------------------
  # new method: add_autobattle_command
  #--------------------------------------------------------------------------
  def add_autobattle_command
    return unless show_autobattle?
    text = YEA::AUTOBATTLE::ACTOR_COMMAND_NAME
    add_command(text, :autobattle, enable_autobattle?)
  end
  
  #--------------------------------------------------------------------------
  # new method: show_autobattle?
  #--------------------------------------------------------------------------
  def show_autobattle?
    return true if YEA::AUTOBATTLE::ACTOR_SHOW_SWITCH <= 0
    return $game_switches[YEA::AUTOBATTLE::ACTOR_SHOW_SWITCH]
  end
  
  #--------------------------------------------------------------------------
  # new method: enable_autobattle?
  #--------------------------------------------------------------------------
  def enable_autobattle?
    return true if YEA::AUTOBATTLE::ACTOR_ENABLE_SWITCH <= 0
    return $game_switches[YEA::AUTOBATTLE::ACTOR_ENABLE_SWITCH]
  end
  
end # Window_ActorCommand

#==============================================================================
# ■ Window_DisableAutobattle
#==============================================================================

class Window_DisableAutobattle < Window_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize
    super(64, 0, Graphics.width - 128, fitting_height(1))
    self.y = Graphics.height - fitting_height(1) + 12
    self.opacity = 0
    self.z = 1000
    hide
    refresh
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_background(contents.rect)
    text = YEA::AUTOBATTLE::DISABLE_MESSAGE
    draw_text(contents.rect, text, 1)
  end
  
  #--------------------------------------------------------------------------
  # draw_background
  #--------------------------------------------------------------------------
  def draw_background(rect)
    temp_rect = rect.clone
    temp_rect.width /= 2
    contents.gradient_fill_rect(temp_rect, back_color2, back_color1)
    temp_rect.x = temp_rect.width
    contents.gradient_fill_rect(temp_rect, back_color1, back_color2)
  end
  
  #--------------------------------------------------------------------------
  # back_color1
  #--------------------------------------------------------------------------
  def back_color1; return Color.new(0, 0, 0, 192); end
  
  #--------------------------------------------------------------------------
  # back_color2
  #--------------------------------------------------------------------------
  def back_color2; return Color.new(0, 0, 0, 0); end
  
end # Window_DisableAutobattle

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_battle_create_all_windows_cab create_all_windows
  def create_all_windows
    $game_temp.continous_autobattle = false
    scene_battle_create_all_windows_cab
    create_disable_autobattle_window
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_party_command_window
  #--------------------------------------------------------------------------
  alias create_party_command_window_cab create_party_command_window
  def create_party_command_window
    create_party_command_window_cab
    @party_command_window.set_handler(:autobattle, method(:command_pautobattle))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_pautobattle
  #--------------------------------------------------------------------------
  def command_pautobattle
    for member in $game_party.battle_members
      next unless member.inputable?
      member.make_auto_battle_actions
    end
    $game_temp.continous_autobattle = YEA::AUTOBATTLE::ENABLE_CONTINOUS
    @disable_autobattle_window.show if $game_temp.continous_autobattle
    refresh_autobattler_status_window
    turn_start
  end
  
  #--------------------------------------------------------------------------
  # new method: create_disable_autobattle_window
  #--------------------------------------------------------------------------
  def create_disable_autobattle_window
    @disable_autobattle_window = Window_DisableAutobattle.new
  end
  
  #--------------------------------------------------------------------------
  # alias method: update
  #--------------------------------------------------------------------------
  alias scene_battle_update_cab update
  def update
    scene_battle_update_cab
    update_continous_autobattle_window
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_basic
  #--------------------------------------------------------------------------
  alias scene_battle_update_basic_cab update_basic
  def update_basic
    scene_battle_update_basic_cab
    update_continous_autobattle_window
  end
  
  #--------------------------------------------------------------------------
  # new method: update_continous_autobattle_window
  #--------------------------------------------------------------------------
  def update_continous_autobattle_window
    return unless @disable_autobattle_window.visible
    opacity = $game_message.visible ? 0 : 255
    @disable_autobattle_window.contents_opacity = opacity
    close_disable_autobattle_window if Input.press?(:B)
  end
  
  #--------------------------------------------------------------------------
  # new method: close_disable_autobattle_window
  #--------------------------------------------------------------------------
  def close_disable_autobattle_window
    Sound.play_cancel if Input.press?(:B) && @disable_autobattle_window.visible
    $game_temp.continous_autobattle = false
    @disable_autobattle_window.hide
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_actor_command_window
  #--------------------------------------------------------------------------
  alias create_actor_command_window_cab create_actor_command_window
  def create_actor_command_window
    create_actor_command_window_cab
    @actor_command_window.set_handler(:autobattle, method(:command_aautobattle))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_aautobattle
  #--------------------------------------------------------------------------
  def command_aautobattle
    BattleManager.actor.make_auto_battle_actions
    next_command
  end
  
  #--------------------------------------------------------------------------
  # new method: refresh_autobattler_status_window
  #--------------------------------------------------------------------------
  def refresh_autobattler_status_window
    for member in $game_party.battle_members
      next unless member.auto_battle?
      @status_window.draw_item(member.index)
    end
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================