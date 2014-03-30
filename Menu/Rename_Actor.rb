#==============================================================================
# 
# ▼ Yanfly Engine Ace - Status Menu Add-On: Rename Actor v1.01
# -- Last Updated: 2012.01.16
# -- Level: Normal
# -- Requires: YEA - Ace Status Menu v1.01+
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-RenameActor"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.01.16 - Bug fixed: Retitle are now working.
# 2011.12.26 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows your player to be able to rename characters straight from
# the Status Menu if Ace Status Menu is installed. You are able to allow and
# disallow specific actors from being able to be renamed as well as allow even
# an actor's title to be retitled.
# 
#==============================================================================
# ▼ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials/素材 but above ▼ Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Actor Notetags - These notetags go in the actors notebox in the database.
# -----------------------------------------------------------------------------
# <rename allow>
# <rename disallow>
# This tag will allow/disallow renaming of the specific actor. Whatever default
# setting you set for actors can be counteracted by one of these two tags.
# 
# <retitle allow>
# <retitle disallow>
# This tag will allow/disallow retitling the specific actor. Whatever default
# setting you set for actors can be counteracted by one of these two tags.
# 
#==============================================================================
# ▼ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Ace Status Menu v1.01+ and the
# script must be placed under Ace Status Menu in the script listing.
# 
#==============================================================================

module YEA
  module RENAME
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Rename Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # Adjust the settings here for renaming actors, including whether or not
    # actors are renamable by default, what the rename max characters are,
    # whether or not the player can change titles by default, and how many max
    # characters can be used for title renaming.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_RENAME_ALLOW  = true   # Allow renaming by default?
    RENAME_CHARACTER_SIZE = 16     # Maximum characters allowed for renaming.
    
    DEFAULT_RETITLE_ALLOW = true   # Allow retitling by default?
    RETITLE_MAX_CHARACTER = 20     # Maximum characters allowed for retitling.
    
  end # RENAME
end # YEA

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

if $imported["YEA-StatusMenu"]
  
module YEA
  module REGEXP
  module ACTOR
    
    RENAME_ALLOW     = /<(?:RENAME_ALLOW|rename allow)>/i
    RENAME_DISALLOW  = /<(?:RENAME_DISALLOW|rename disallow)>/i
    
    RETITLE_ALLOW    = /<(?:RETITLE_ALLOW|retitle allow)>/i
    RETITLE_DISALLOW = /<(?:RETITLE_DISALLOW|retitle disallow)>/i
    
  end # ACTOR
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_rna load_database; end
  def self.load_database
    load_database_rna
    load_notetags_rna
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_rna
  #--------------------------------------------------------------------------
  def self.load_notetags_rna
    for actor in $data_actors
      next if actor.nil?
      actor.load_notetags_rna
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::Actor
#==============================================================================

class RPG::Actor < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :rename_allow
  attr_accessor :retitle_allow
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_rna
  #--------------------------------------------------------------------------
  def load_notetags_rna
    @rename_allow = YEA::RENAME::DEFAULT_RENAME_ALLOW
    @retitle_allow = YEA::RENAME::DEFAULT_RETITLE_ALLOW
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ACTOR::RENAME_ALLOW
        @rename_allow = true
      when YEA::REGEXP::ACTOR::RENAME_DISALLOW
        @rename_allow = false
      when YEA::REGEXP::ACTOR::RETITLE_ALLOW
        @retitle_allow = true
      when YEA::REGEXP::ACTOR::RETITLE_DISALLOW
        @retitle_allow = false
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::BaseItem

#==============================================================================
# ■ SceneManager
#==============================================================================

module SceneManager
  
  #--------------------------------------------------------------------------
  # new method: self.force_recall
  #--------------------------------------------------------------------------
  def self.force_recall(scene_class)
    @scene = scene_class
  end
  
end # SceneManager

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: rename_allow?
  #--------------------------------------------------------------------------
  def rename_allow?
    return actor.rename_allow
  end
  #--------------------------------------------------------------------------
  # new method: retitle_allow?
  #--------------------------------------------------------------------------
  def retitle_allow?
    return actor.retitle_allow
  end
  
end # Game_Actor

#==============================================================================
# ■ Window_NameEdit
#==============================================================================

class Window_NameEdit < Window_Base
  
  #--------------------------------------------------------------------------
  # alias method: item_rect
  #--------------------------------------------------------------------------
  alias window_nameedit_item_rect_rna item_rect
  def item_rect(index)
    if index >= @max_char
      return Rect.new(left-4, 36, char_width * @max_char + 8, line_height)
    else
      return window_nameedit_item_rect_rna(index)
    end
  end
  
end # Window_NameEdit

#==============================================================================
# ■ Window_TitleEdit
#==============================================================================

class Window_TitleEdit < Window_NameEdit
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(actor, max_char)
    super(actor, max_char)
    @default_name = @name = actor.nickname[0, @max_char]
    @index = @name.size
    refresh
  end
  
  #--------------------------------------------------------------------------
  # refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_actor_face(@actor, 0, 0)
    draw_actor_name(@actor, left, item_rect(0).y - line_height)
    @max_char.times {|i| draw_underline(i) }
    @name.size.times {|i| draw_char(i) }
    cursor_rect.set(item_rect(@index))
  end
  
end # Window_TitleEdit

#==============================================================================
# ■ Scene_Status
#==============================================================================

class Scene_Status < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # alias method: create_command_window
  #--------------------------------------------------------------------------
  alias scene_status_create_command_window_rna create_command_window
  def create_command_window
    scene_status_create_command_window_rna
    @command_window.set_handler(:rename, method(:command_rename))
    @command_window.set_handler(:retitle, method(:command_retitle))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_rename
  #--------------------------------------------------------------------------
  def command_rename
    Graphics.freeze
    @viewport.visible = false
    #---
    character_max = YEA::RENAME::RENAME_CHARACTER_SIZE
    SceneManager.call(Scene_Name)
    SceneManager.scene.prepare(@actor.id, character_max)
    SceneManager.scene.main
    SceneManager.force_recall(self)
    #---
    @viewport.visible = true
    @command_window.refresh
    @status_window.refresh
    @item_window.refresh
    perform_transition
    @command_window.activate
  end
  
  #--------------------------------------------------------------------------
  # new method: command_retitle
  #--------------------------------------------------------------------------
  def command_retitle
    Graphics.freeze
    @viewport.visible = false
    #---
    character_max = YEA::RENAME::RETITLE_MAX_CHARACTER
    SceneManager.call(Scene_Retitle)
    SceneManager.scene.prepare(@actor.id, character_max)
    SceneManager.scene.main
    SceneManager.force_recall(self)
    #---
    @viewport.visible = true
    @command_window.refresh
    @status_window.refresh
    @item_window.refresh
    perform_transition
    @command_window.activate
  end
  
end # Scene_Status

#==============================================================================
# ■ Scene_Retitle
#==============================================================================

class Scene_Retitle < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # prepare
  #--------------------------------------------------------------------------
  def prepare(actor_id, max_char)
    @actor_id = actor_id
    @max_char = max_char
  end
  
  #--------------------------------------------------------------------------
  # start
  #--------------------------------------------------------------------------
  def start
    super
    @actor = $game_actors[@actor_id]
    @edit_window = Window_TitleEdit.new(@actor, @max_char)
    @input_window = Window_NameInput.new(@edit_window)
    @input_window.set_handler(:ok, method(:on_input_ok))
  end
  
  #--------------------------------------------------------------------------
  # on_input_ok
  #--------------------------------------------------------------------------
  def on_input_ok
    @actor.nickname = @edit_window.name
    return_scene
  end
  
end # Scene_Retitle

end # $imported["YEA-StatusMenu"]

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================