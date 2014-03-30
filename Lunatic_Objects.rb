#==============================================================================
# 
# ▼ Yanfly Engine Ace - Lunatic Objects v1.02
# -- Last Updated: 2011.12.27
# -- Level: Lunatic
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-LunaticObjects"] = true

#==============================================================================
# ▼ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2011.12.27 - Added "Prepare" step.
#            - Moved Common Lunatic Object Effects to occur at the end of the
#              effects list per type.
# 2011.12.15 - REGEXP Fix.
# 2011.12.14 - Started Script and Finished.
# 
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Lunatic mode effects have always been a core part of Yanfly Engine scripts.
# They exist to provide more effects for those who want more power and control
# for their items, skills, status effects, etc., but the users must be able to
# add them in themselves. 
# 
# This script provides the base setup for skill and item lunatic effects.
# These lunatic object effects will give leeway to occur at certain times
# during a skill or item's usage, which include before the object is used,
# while (during) the object is used, and after the object is used.
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

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # ● Welcome to Lunatic Mode
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Lunatic Object Effects allows skills and items allow users with scripting
  # knowledge to add in their own unique effects without need to edit the
  # base script. These effects occur at three different intervals and are
  # marked by three different tags.
  # 
  #     <before effect: string>
  #     <prepare effect: string>
  #     <during effect: string>
  #     <after effect: string>
  # 
  # Before effects occur before the skill cost or item consumption occurs,
  # but after the spell initiates. These are generally used for skill or item
  # preparations.
  # 
  # Prepare effects occur as units are being targeted but before any HP damage
  # is dealt. Note that if a skill targets a unit multiple times, the prepare
  # effects will also run multiple times.
  # 
  # During effects occur as units are being targeted and after HP damage
  # occurs but before moving onto the next target if done in a group. Note
  # that if a skill targets a unit multiple times, the during effects will
  # also run multiple times.
  # 
  # After effects occur after the targets have all been hit. In general, this
  # will occur right before the skill or item's common event runs (if one was
  # scheduled to run). These are generally used for clean up purposes.
  # 
  # If multiple tags of the same type are used in the same skill/item's
  # notebox, then the effects will occur in that order. Replace "string" in
  # the tags with the appropriate flag for the method below to search for.
  # Note that unlike the previous versions, these are all upcase.
  # 
  # Should you choose to use multiple lunatic effects for a single skill or
  # item, you may use these notetags in place of the ones shown above.
  # 
  #     <before effect>          <prepare effect>
  #      string                   string
  #      string                   string
  #     </before effect>         </prepare effect>
  # 
  #     <during effect>          <after effect>
  #      string                   string
  #      string                   string
  #     </during effect>         </after effect>
  # 
  # All of the string information in between those two notetags will be
  # stored the same way as the notetags shown before those. There is no
  # difference between using either.
  #--------------------------------------------------------------------------
  def lunatic_object_effect(type, item, user, target)
    return if item.nil?
    case type
    when :before;  effects = item.before_effects
    when :prepare; effects = item.prepare_effects
    when :during;  effects = item.during_effects
    when :after;   effects = item.after_effects
    else; return
    end
    line_number = @log_window.line_number
    for effect in effects
      case effect.upcase
      #----------------------------------------------------------------------
      # Common Effect: Before
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs before every single skill or item
      # consumption even if you place it into the notebox or not. There is
      # no need to modify this unless you see fit. In a before effect, the
      # target is the user.
      #----------------------------------------------------------------------
      when /COMMON BEFORE/i
        # No common before effects added.
        
      #----------------------------------------------------------------------
      # Common Effect: During
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs during each targeting instance for
      # every single skill or item even if you place it into the notebox or
      # not. The prepare phase occurs before the action has takes place but
      # after the target has been selected. There is no need to modify this 
      # unless you see fit. In a prepare effect, the target is the battler
      # being attacked.
      #----------------------------------------------------------------------
      when /COMMON PREPARE/i
        # No common during effects added.
        
      #----------------------------------------------------------------------
      # Common Effect: During
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs during each targeting instance for
      # every single skill or item even if you place it into the notebox or
      # not. The during phase occurs after the action has taken place but
      # before the next target is selected. There is no need to modify this 
      # unless you see fit. In a during effect, the target is the battler
      # being attacked.
      #----------------------------------------------------------------------
      when /COMMON DURING/i
        # No common during effects added.
        
      #----------------------------------------------------------------------
      # Common Effect: After
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # This is a common effect that runs with every single skill or item
      # after targeting is over, but before common events begin even if you
      # place it into the notebox or not. There is no need to modify this
      # unless you see fit. In an after effect, the target is the user.
      #----------------------------------------------------------------------
      when /COMMON AFTER/i
        # No common after effects added.
        
      #----------------------------------------------------------------------
      # Stop editting past this point.
      #----------------------------------------------------------------------
      else
        lunatic_object_extension(effect, item, user, target, line_number)
      end # effect.upcase
    end # for effect in effects
  end # lunatic_object_effect
  
end # Scene_Battle

#==============================================================================
# ▼ Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module USABLEITEM
    
    BEFORE_EFFECT_STR = /<(?:BEFORE_EFFECT|before effect):[ ](.*)>/i
    BEFORE_EFFECT_ON  = /<(?:BEFORE_EFFECT|before effect)>/i
    BEFORE_EFFECT_OFF = /<\/(?:BEFORE_EFFECT|before effect)>/i
    
    PREPARE_EFFECT_STR = /<(?:PREPARE_EFFECT|prepare effect):[ ](.*)>/i
    PREPARE_EFFECT_ON  = /<(?:PREPARE_EFFECT|prepare effect)>/i
    PREPARE_EFFECT_OFF = /<\/(?:PREPARE_EFFECT|prepare effect)>/i
    
    DURING_EFFECT_STR = /<(?:DURING_EFFECT|during effect):[ ](.*)>/i
    DURING_EFFECT_ON  = /<(?:DURING_EFFECT|during effect)>/i
    DURING_EFFECT_OFF = /<\/(?:DURING_EFFECT|during effect)>/i
    
    AFTER_EFFECT_STR  = /<(?:AFTER_EFFECT|after effect):[ ](.*)>/i
    AFTER_EFFECT_ON   = /<(?:AFTER_EFFECT|after effect)>/i
    AFTER_EFFECT_OFF  = /<\/(?:AFTER_EFFECT|after effect)>/i
    
  end # USABLEITEM
  end # REGEXP
end # YEA

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_lobj load_database; end
  def self.load_database
    load_database_lobj
    load_notetags_lobj
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_lobj
  #--------------------------------------------------------------------------
  def self.load_notetags_lobj
    groups = [$data_items, $data_skills]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_lobj
      end
    end
  end
  
end # DataManager

#==============================================================================
# ■ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :before_effects
  attr_accessor :prepare_effects
  attr_accessor :during_effects
  attr_accessor :after_effects
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_lobj
  #--------------------------------------------------------------------------
  def load_notetags_lobj
    @before_effects = []
    @prepare_effects = []
    @during_effects = []
    @after_effects  = []
    @before_effects_on = false
    @during_effects_on = false
    @after_effects_on  = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::BEFORE_EFFECT_STR
        @before_effects.push($1.to_s)
      when YEA::REGEXP::USABLEITEM::PREPARE_EFFECT_STR
        @prepare_effects.push($1.to_s)
      when YEA::REGEXP::USABLEITEM::DURING_EFFECT_STR
        @during_effects.push($1.to_s)
      when YEA::REGEXP::USABLEITEM::AFTER_EFFECT_STR
        @after_effects.push($1.to_s)
      #---
      when YEA::REGEXP::USABLEITEM::BEFORE_EFFECT_ON
        @before_effects_on = true
      when YEA::REGEXP::USABLEITEM::BEFORE_EFFECT_OFF
        @before_effects_on = false
      when YEA::REGEXP::USABLEITEM::PREPARE_EFFECT_ON
        @prepare_effects_on = true
      when YEA::REGEXP::USABLEITEM::PREPARE_EFFECT_OFF
        @prepare_effects_on = false
      when YEA::REGEXP::USABLEITEM::DURING_EFFECT_ON
        @during_effects_on = true
      when YEA::REGEXP::USABLEITEM::DURING_EFFECT_OFF
        @during_effects_on = false
      when YEA::REGEXP::USABLEITEM::AFTER_EFFECT_ON
        @after_effects_on = true
      when YEA::REGEXP::USABLEITEM::AFTER_EFFECT_OFF
        @after_effects_on = false
      #---
      else
        @before_effects.push(line.to_s) if @before_effects_on
        @prepare_effects.push(line.to_s) if @prepare_effects_on
        @during_effects.push(line.to_s) if @during_effects_on
        @after_effects.push(line.to_s)  if @after_effects_on
      end
    } # self.note.split
    #---
    @before_effects.push("COMMON BEFORE")
    @prepare_effects.push("COMMON PREPARE")
    @during_effects.push("COMMON DURING")
    @after_effects.push("COMMON AFTER")
  end
  
end # RPG::UsableItem

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :lunatic_item
  attr_accessor :targets
  
end # Game_Temp

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: use_item
  #--------------------------------------------------------------------------
  unless $imported["YEA-BattleEngine"]
  alias scene_battle_use_item_lobj use_item
  def use_item
    item = @subject.current_action.item
    lunatic_object_effect(:before, item, @subject, @subject)
    scene_battle_use_item_lobj
    lunatic_object_effect(:after, item, @subject, @subject)
  end
  
  #--------------------------------------------------------------------------
  # alias method: apply_item_effects
  #--------------------------------------------------------------------------
  alias scene_battle_apply_item_effects_lobj apply_item_effects
  def apply_item_effects(target, item)
    lunatic_object_effect(:prepare, item, @subject, target)
    scene_battle_apply_item_effects_lobj(target, item)
    lunatic_object_effect(:during, item, @subject, target)
  end
  end # $imported["YEA-BattleEngine"]
  
  #--------------------------------------------------------------------------
  # new method: status_redraw_target
  #--------------------------------------------------------------------------
  def status_redraw_target(target)
    return unless target.actor?
    @status_window.draw_item($game_party.battle_members.index(target))
  end
  
  #--------------------------------------------------------------------------
  # new method: lunatic_object_extension
  #--------------------------------------------------------------------------
  def lunatic_object_extension(effect, item, user, target, line_number)
    # Reserved for future Add-ons.
  end
  
end # Scene_Battle

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================