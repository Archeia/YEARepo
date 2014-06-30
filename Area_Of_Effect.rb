#==============================================================================
# 
# Å• Yanfly Engine Ace - Area of Effect v1.02
# -- Last Updated: 2012.07.23
# -- Level: Hard
# -- Requires: YEA - Target Manager v1.02
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["YEA-AreaofEffect"] = true

#==============================================================================
# Å• Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2012.07.23 - Bug Fixed: AoE picking targets.
# 2012.01.13 - Bug Fixed: AoE removing targets.
# 2012.01.04 - Started Script and Finished.
# 
#==============================================================================
# Å• Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Sometimes, targeting one foe isn't enough and targeting all foes is too much.
# The right mix in between would be area of effects to target only a certain
# area of foes. This script enables area of effect targeting to come in the
# forms of circular areas, column areas, row areas, and even the whole map. For
# those who worry about how enemies may get hit, this script also includes the
# ability to adjust an enemy's hitbox allowing them to be targeted properly
# with area of effect skills and items.
# 
#==============================================================================
# Å• Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open up your script editor and copy/paste this script
# to an open slot below Å• Materials/'fçﬁ but above Å• Main. Remember to save.
# 
# -----------------------------------------------------------------------------
# Skill Notetags - These notetags go in the skills notebox in the database.
# -----------------------------------------------------------------------------
# <aoe radius: x>
# Sets the radius of a circular Area of Effect to x. This effect is required to
# mark a skill or item as having an Area of Effect.
# 
# <aoe image: string>
# Changes the image used for the circular Area of Effect marker to "string". If
# this tag is not used, the Area of Effect will use the DEFAULT_CIRCLE image.
# 
# <aoe blend: x>
# Changes the blend effect of the image to 0 - Normal, 1 - Additive, or
# 2 - Subtractive. If this tag is not used, the area of effect blend type will
# use the CIRCULAR_BLEND effect.
# 
# <aoe height: x%>
# Changes the height of the Area of Effect range to x%. If this tag is not
# used, the Area of Effect height will be the DEFAULT_HEIGHT percentage.
# 
# <aoe column: x>
# This will cause the skill or item to have an Area of Effect with a width of x
# pixels wide. This effect is required to mark a skill or item as having a
# rectangular Area of Effect. Use this or <aoe row: x> or <aoe map>.
# 
# <aoe row: x>
# This will cause the skill or item to have an Area of Effect with a height of
# x pixels tall. This effect is required to mark a skill or item as having a
# rectangular Area of Effect. Use this or <aoe column: x> or <aoe map>.
# 
# <aoe map>
# This will cause the skill or item to have an Area of Effect that spans the
# entire screen. This effect is required to mark a skill or item as having a
# rectangular Area of Effect. Use this or <aoe row: x> or <aoe column: x>.
# 
# <rect image: string>
# Changes the image used for the rectangular Area of Effect marker to "string".
# If this tag is not used, the Area of Effect will use the DEFAULT_SQUARE image.
# 
# <rect blend: x>
# Changes the blend effect of the image to 0 - Normal, 1 - Additive, or
# 2 - Subtractive. If this tag is not used, the area of effect blend type will
# use the SQUARISH_BLEND effect.
# 
# -----------------------------------------------------------------------------
# Item Notetags - These notetags go in the items notebox in the database.
# -----------------------------------------------------------------------------
# <aoe radius: x>
# Sets the radius of a circular Area of Effect to x. This effect is required to
# mark a skill or item as having an Area of Effect.
# 
# <aoe image: string>
# Changes the image used for the circular Area of Effect marker to "string". If
# this tag is not used, the Area of Effect will use the DEFAULT_CIRCLE image.
# 
# <aoe blend: x>
# Changes the blend effect of the image to 0 - Normal, 1 - Additive, or
# 2 - Subtractive. If this tag is not used, the area of effect blend type will
# use the CIRCULAR_BLEND effect.
# 
# <aoe height: x%>
# Changes the height of the Area of Effect range to x%. If this tag is not
# used, the Area of Effect height will be the DEFAULT_HEIGHT percentage.
# 
# <aoe column: x>
# This will cause the skill or item to have an Area of Effect with a width of x
# pixels wide. This effect is required to mark a skill or item as having a
# rectangular Area of Effect. Use this or <aoe row: x> or <aoe map>.
# 
# <aoe row: x>
# This will cause the skill or item to have an Area of Effect with a height of
# x pixels tall. This effect is required to mark a skill or item as having a
# rectangular Area of Effect. Use this or <aoe column: x> or <aoe map>.
# 
# <aoe map>
# This will cause the skill or item to have an Area of Effect that spans the
# entire screen. This effect is required to mark a skill or item as having a
# rectangular Area of Effect. Use this or <aoe row: x> or <aoe column: x>.
# 
# <rect image: string>
# Changes the image used for the rectangular Area of Effect marker to "string".
# If this tag is not used, the Area of Effect will use the DEFAULT_SQUARE image.
# 
# <rect blend: x>
# Changes the blend effect of the image to 0 - Normal, 1 - Additive, or
# 2 - Subtractive. If this tag is not used, the area of effect blend type will
# use the SQUARISH_BLEND effect.
# 
# -----------------------------------------------------------------------------
# Enemy Notetags - These notetags go in the enemies notebox in the database.
# -----------------------------------------------------------------------------
# <hitbox width: x>
# Changes the hitbox for the enemy to x pixels wide. The wider an enemy, the
# more likely it is to be hit by an Area of Effect.
# 
# <hitbox height: x>
# Changes the hitbox for the enemy to x pixels tall. The taller an enemy, the
# more likely it is to be hit by an Area of Effect.
# 
# <offset x: -x>
# <offset x: +x>
# Changes the positioning of an enemy's horizontal origin by x amount. By
# default, all enemies have a horizontal origin set at the center.
# 
# <offset y: -x>
# <offset y: +x>
# Changes the positioning of an enemy's vertical origin by y amount. By
# default, all enemies have a horizontal origin set at their feet.
# 
#==============================================================================
# Å• Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script is made strictly for RPG Maker VX Ace. It is highly unlikely that
# it will run with RPG Maker VX without adjusting.
# 
# This script requires Yanfly Engine Ace - Target Manager v1.02+ to work. Place
# this script under Yanfly Engine Ace - Target Manager in the script list.
# 
#==============================================================================

module YEA
  module AOE
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Circular AoE Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The following sets the default settings used for AoE visual effects.
    # There must be an image within your game's Graphics\Pictures\ folder
    # matching the default filename below.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_CIRCLE = "AoE_CircleFull"    # Default circular AoE Image.
    CIRCULAR_BLEND = 1     # 0 - Normal; 1 - Additive; 2 - Subtractive
    
    # This is how much smaller (or larger) the selection height is in
    # comparison to the default width of selection area. The offset is how
    # much higher the circle should be than normal.
    DEFAULT_HEIGHT = 0.33
    
    # This is the default offset coordinate offsets for enemies on screen.
    # Made to center the circles properly.
    DEFAULT_ENEMY_OFFSET_X =  0
    DEFAULT_ENEMY_OFFSET_Y = -8
    
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # - Rectangular AoE Settings -
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    # The following sets the default settings used for AoE visual effects.
    # There must be an image within your game's Graphics\Pictures\ folder
    # matching the default filename below.
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    DEFAULT_SQUARE = "AoE_SquareFull"    # Default square AoE Image.
    SQUARISH_BLEND = 1     # 0 - Normal; 1 - Additive; 2 - Subtractive
    
  end # AOE
end # YEA

#==============================================================================
# Å• Editting anything past this point may potentially result in causing
# computer damage, incontinence, explosion of user's head, coma, death, and/or
# halitosis so edit at your own risk.
#==============================================================================

module YEA
  module REGEXP
  module USABLEITEM
    
    AOE_IMAGE  = /<(?:AOE_IMAGE|aoe image):[ ](.*)>/i
    AOE_BLEND  = /<(?:AOE_BLEND|aoe blend):[ ](\d+)>/i
    AOE_HEIGHT = /<(?:AOE_HEIGHT|aoe height):[ ](\d+)([%Å"])>/i
    AOE_RADIUS = /<(?:AOE_RADIUS|aoe radius):[ ](\d+)>/i
    
    RECT_IMAGE = /<(?:RECT_IMAGE|rect image):[ ](.*)>/i
    RECT_BLEND = /<(?:RECT_BLEND|rect blend):[ ](\d+)>/i
    RECT_COL   = /<(?:AOE_COLUMN|aoe column):[ ](\d+)>/i
    RECT_ROW   = /<(?:AOE_ROW|aoe row):[ ](\d+)>/i
    RECT_MAP   = /<(?:AOE_MAP|aoe map)>/i
    
  end # USABLEITEM
  module ENEMY
    
    OFFSET_X = /<(?:OFFSET_X|offset x):[ ]([\+\-]\d+)>/i
    OFFSET_Y = /<(?:OFFSET_Y|offset y):[ ]([\+\-]\d+)>/i
    HITBOX_W = /<(?:HITBOX_WIDTH|hitbox width):[ ](\d+)>/i
    HITBOX_H = /<(?:HITBOX_HEIGHT|hitbox height):[ ](\d+)>/i
    
  end # ENEMY
  end # REGEXP
end # YEA


#==============================================================================
# Å° DataManager
#==============================================================================

module DataManager
  
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_aoe load_database; end
  def self.load_database
    load_database_aoe
    load_notetags_aoe
  end
  
  #--------------------------------------------------------------------------
  # new method: load_notetags_aoe
  #--------------------------------------------------------------------------
  def self.load_notetags_aoe
    groups = [$data_skills, $data_items, $data_enemies]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_aoe
      end
    end
  end
  
end # DataManager

#==============================================================================
# Å° RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :aoe_image
  attr_accessor :aoe_blend
  attr_accessor :aoe_height
  attr_accessor :aoe_radius
  attr_accessor :rect_image
  attr_accessor :rect_blend
  attr_accessor :rect_value
  attr_accessor :rect_type
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_aoe
  #--------------------------------------------------------------------------
  def load_notetags_aoe
    @aoe_image = YEA::AOE::DEFAULT_CIRCLE
    @aoe_blend = YEA::AOE::CIRCULAR_BLEND
    @aoe_height = YEA::AOE::DEFAULT_HEIGHT
    @aoe_radius = 0
    @rect_image = YEA::AOE::DEFAULT_SQUARE
    @rect_blend = YEA::AOE::SQUARISH_BLEND
    @rect_value = 0
    @rect_type = 0
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::USABLEITEM::AOE_IMAGE
        @aoe_image = $1.to_s
      when YEA::REGEXP::USABLEITEM::AOE_BLEND
        @aoe_blend = [[$1.to_i, 0].max, 2].min
      when YEA::REGEXP::USABLEITEM::AOE_HEIGHT
        @aoe_height = [$1.to_i * 0.01, 0.1].max
      when YEA::REGEXP::USABLEITEM::AOE_RADIUS
        @aoe_radius = [$1.to_i, 3].max
      #---
      when YEA::REGEXP::USABLEITEM::RECT_IMAGE
        @rect_image = $1.to_s
      when YEA::REGEXP::USABLEITEM::RECT_BLEND
        @rect_blend = $1.to_i
      when YEA::REGEXP::USABLEITEM::RECT_COL
        @rect_type = 1
        @rect_value = [$1.to_i, 3].max
      when YEA::REGEXP::USABLEITEM::RECT_ROW
        @rect_type = 2
        @rect_value = [$1.to_i, 3].max
      when YEA::REGEXP::USABLEITEM::RECT_MAP
        @rect_type = 3
      #---
      end
    } # self.note.split
    #---
  end
  
end # class RPG::UsableItem

#==============================================================================
# Å° RPG::Enemy
#==============================================================================

class RPG::Enemy < RPG::BaseItem
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :offset_x
  attr_accessor :offset_y
  attr_accessor :hitbox_w
  attr_accessor :hitbox_h
  
  #--------------------------------------------------------------------------
  # common cache: load_notetags_aoe
  #--------------------------------------------------------------------------
  def load_notetags_aoe
    @offset_x = YEA::AOE::DEFAULT_ENEMY_OFFSET_X
    @offset_y = YEA::AOE::DEFAULT_ENEMY_OFFSET_Y
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when YEA::REGEXP::ENEMY::OFFSET_X
        @offset_x = $1.to_i
      when YEA::REGEXP::ENEMY::OFFSET_Y
        @offset_y = $1.to_i
      when YEA::REGEXP::ENEMY::HITBOX_W
        @hitbox_w = [$1.to_i, 1].max
      when YEA::REGEXP::ENEMY::HITBOX_H
        @hitbox_h = [$1.to_i, 1].max
      #---
      end
    } # self.note.split
    #---
  end
  
end # RPG::Enemy

#==============================================================================
# Å° Sprite_AoE_Circle
#==============================================================================

class Sprite_AoE_Circle < Sprite_Base
  
  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    create_bitmap
    @glow_rate = -8
  end
  
  #--------------------------------------------------------------------------
  # dispose
  #--------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose unless self.bitmap.nil?
    super
  end
  
  #--------------------------------------------------------------------------
  # create_bitmap
  #--------------------------------------------------------------------------
  def create_bitmap(item = nil)
    return if @item == item
    @item = item
    return if @item.nil?
    return if no_aoe?
    #---
    self.bitmap = Cache.picture(@item.aoe_image)
    self.blend_type = @item.aoe_blend
    diameter = @item.aoe_radius * 2 + 1
    self.zoom_x = diameter * 1.125 / self.width
    self.zoom_y = self.zoom_x * @item.aoe_height
    self.ox = self.width / 2
    self.oy = self.height / 2
    self.z = 2
    self.visible = update_visible
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    return unless SceneManager.scene_is?(Scene_Battle)
    set_current_item
    self.visible = update_visible
    update_position
    update_glow
  end
  
  #--------------------------------------------------------------------------
  # set_current_item
  #--------------------------------------------------------------------------
  def set_current_item
    return if SceneManager.scene.enemy_window.nil?
    if SceneManager.scene.enemy_window.visible
      create_bitmap(BattleManager.actor.input.item)
    elsif SceneManager.scene.actor_window.visible
      create_bitmap(BattleManager.actor.input.item)
    end
  end
  
  #--------------------------------------------------------------------------
  # no_aoe?
  #--------------------------------------------------------------------------
  def no_aoe?
    return @item.aoe_radius <= 0
  end
  
  #--------------------------------------------------------------------------
  # update_visible
  #--------------------------------------------------------------------------
  def update_visible
    return false if @item.nil?
    return false if no_aoe?
    return false if SceneManager.scene.enemy_window.nil?
    return true if SceneManager.scene.enemy_window.visible
    return true if SceneManager.scene.actor_window.visible
    return false
  end
  
  #--------------------------------------------------------------------------
  # update_position
  #--------------------------------------------------------------------------
  def update_position
    return if @item.nil?
    return if no_aoe?
    self.x = target_x
    self.y = target_y
  end
  
  #--------------------------------------------------------------------------
  # target_x
  #--------------------------------------------------------------------------
  def target_x
    n = 0
    if SceneManager.scene.enemy_window.visible
      n = SceneManager.scene.enemy_window.enemy.screen_x
      n += SceneManager.scene.enemy_window.enemy.hitbox_x_offset
    elsif SceneManager.scene.actor_window.visible
      actor = $game_party.battle_members[SceneManager.scene.actor_window.index]
      n = actor.screen_x
      n += actor.hitbox_x_offset
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # target_y
  #--------------------------------------------------------------------------
  def target_y
    n = 0
    if SceneManager.scene.enemy_window.visible
      n = SceneManager.scene.enemy_window.enemy.screen_y
      n += SceneManager.scene.enemy_window.enemy.hitbox_y_offset
    elsif SceneManager.scene.actor_window.visible
      actor = $game_party.battle_members[SceneManager.scene.actor_window.index]
      n = actor.screen_y
      n += actor.hitbox_y_offset
    end
    return n
  end
  
  #--------------------------------------------------------------------------
  # update_glow
  #--------------------------------------------------------------------------
  def update_glow
    return unless self.visible
    self.opacity += @glow_rate
    @glow_rate *= -1 if self.opacity <= 0 || self.opacity >= 255
  end
  
end # Sprite_AoE_Circle

#==============================================================================
# Å° Sprite_AoE_Square
#==============================================================================

class Sprite_AoE_Square < Sprite_AoE_Circle
  
  #--------------------------------------------------------------------------
  # create_bitmap
  #--------------------------------------------------------------------------
  def create_bitmap(item = nil)
    return if @item == item
    @item = item
    return if @item.nil?
    return if no_aoe?
    #---
    self.bitmap = Cache.picture(@item.rect_image)
    self.blend_type = @item.rect_blend
    case @item.rect_type
    when 1 # Column
      self.zoom_x = @item.rect_value.to_f / self.width
      self.zoom_y = Graphics.height.to_f / self.height
    when 2 # Row
      self.zoom_x = Graphics.width.to_f / self.width
      self.zoom_y = @item.rect_value.to_f / self.height
    else # Map
      self.zoom_x = Graphics.width.to_f / self.width
      self.zoom_y = Graphics.height.to_f / self.height
    end
    self.ox = self.width / 2
    self.oy = self.height / 2
    self.z = 1
    self.visible = update_visible
  end
  
  #--------------------------------------------------------------------------
  # no_aoe?
  #--------------------------------------------------------------------------
  def no_aoe?
    return @item.rect_type <= 0
  end
  
  #--------------------------------------------------------------------------
  # target_x
  #--------------------------------------------------------------------------
  def target_x
    return Graphics.width / 2 if [2, 3].include?(@item.rect_type)
    return super
  end
  
  #--------------------------------------------------------------------------
  # target_y
  #--------------------------------------------------------------------------
  def target_y
    return Graphics.height / 2 if [1, 3].include?(@item.rect_type)
    return super
  end
  
end # Sprite_AoE_Square

#==============================================================================
# Å° Spriteset_Battle
#==============================================================================

class Spriteset_Battle
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :actor_sprites
  attr_accessor :enemy_sprites
  
  #--------------------------------------------------------------------------
  # alias method: initialize
  #--------------------------------------------------------------------------
  alias spriteset_battle_initialize_aoe initialize
  def initialize
    spriteset_battle_initialize_aoe
    create_aoe_sprites
  end
  
  #--------------------------------------------------------------------------
  # new method: create_aoe_sprites
  #--------------------------------------------------------------------------
  def create_aoe_sprites
    @aoe_circle_sprite = Sprite_AoE_Circle.new(@viewport1)
    @aoe_square_sprite = Sprite_AoE_Square.new(@viewport1)
  end
  
  #--------------------------------------------------------------------------
  # alias method: dispose
  #--------------------------------------------------------------------------
  alias spriteset_battle_dispose_aoe dispose
  def dispose
    dispose_aoe_sprites
    spriteset_battle_dispose_aoe
  end
  
  #--------------------------------------------------------------------------
  # new method: dispose_aoe_sprites
  #--------------------------------------------------------------------------
  def dispose_aoe_sprites
    @aoe_circle_sprite.dispose unless @aoe_circle_sprite.nil?
    @aoe_square_sprite.dispose unless @aoe_square_sprite.nil?
  end
  
  #--------------------------------------------------------------------------
  # alias method: update
  #--------------------------------------------------------------------------
  alias spriteset_battle_update_aoe update
  def update
    spriteset_battle_update_aoe
    update_aoe_sprites
  end
  
  #--------------------------------------------------------------------------
  # new method: update_aoe_sprites
  #--------------------------------------------------------------------------
  def update_aoe_sprites
    @aoe_circle_sprite.update unless @aoe_circle_sprite.nil?
    @aoe_square_sprite.update unless @aoe_square_sprite.nil?
  end
  
end # Spriteset_Battle

#==============================================================================
# Å° Game_Action
#==============================================================================

class Game_Action
  
  #--------------------------------------------------------------------------
  # new method: aoe_targets
  #--------------------------------------------------------------------------
  def aoe_targets(targets)
    result = aoe_circle_targets
    result |= aoe_square_targets
    for member in result
      next if targets.include?(member)
      targets.push(member)
    end
    return targets
  end
  
  #--------------------------------------------------------------------------
  # new method: aoe_circle_targets
  #--------------------------------------------------------------------------
  def aoe_circle_targets
    targets = []
    return targets if item.nil? or item.aoe_radius <= 0
    group = item.for_friend? ? friends_unit : opponents_unit
    main = opponents_unit.smooth_target(@target_index)
    for target in group.alive_members
      targets.push(target) if inside_aoe_circle?(main, target)
    end
    return targets
  end
  
  #--------------------------------------------------------------------------
  # new method: inside_aoe_circle?
  #--------------------------------------------------------------------------
  def inside_aoe_circle?(main, target)
    radius = item.aoe_radius + 1
    height = item.aoe_height
    main_x = main.screen_x + main.hitbox_x_offset
    main_y = main.screen_y + main.hitbox_y_offset
    target_x = target.screen_x
    target_y = target.screen_y
    if main_x > target.screen_x
      target_x = [target.hitbox.x + target.hitbox.width, main_x].min
    elsif main_x < target.screen_x
      target_x = [target.hitbox.x, main_x].max
    end
    if main_y > target.screen_y
      target_y = [target.hitbox.y + target.hitbox.height, main_y].min
    elsif main_y < target.screen_y
      target_y = [target.hitbox.y, main_y].max
    end
    x =  (target_x - main_x) * Math.cos(0) + (target_y - main_y) * Math.sin(0)
    y = -(target_x - main_x) * Math.sin(0) + (target_y - main_y) * Math.cos(0)
    a = radius * 1.125; b = radius * (height + 0.01)
    return (x**2 / a**2) + (y**2 / b**2) <= 1
  end
  
  #--------------------------------------------------------------------------
  # new method: aoe_square_targets
  #--------------------------------------------------------------------------
  def aoe_square_targets
    targets = []
    return targets if item.nil? or item.rect_type <= 0
    group = item.for_friend? ? friends_unit : opponents_unit
    main = opponents_unit.smooth_target(@target_index)
    for target in group.alive_members
      targets.push(target) if inside_aoe_square?(main, target)
    end
    puts targets.size
    return targets
  end
  
  #--------------------------------------------------------------------------
  # new method: inside_aoe_square?
  #--------------------------------------------------------------------------
  def inside_aoe_square?(main, target)
    main_x = main.screen_x + main.hitbox_x_offset
    main_y = main.screen_y + main.hitbox_y_offset
    target_x = target.screen_x
    target_y = target.screen_y
    if main_x > target.screen_x
      target_x = [target.hitbox.x + target.hitbox.width, main_x].min
    elsif main_x < target.screen_x
      target_x = [target.hitbox.x, main_x].max
    end
    if main_y > target.screen_y
      target_y = [target.hitbox.y + target.hitbox.height, main_y].min
    elsif main_y < target.screen_y
      target_y = [target.hitbox.y, main_y].max
    end
    case item.rect_type
    when 1 # Column
      y1 = 0; y2 = Graphics.height
      x1 = main_x - item.rect_value / 2
      x2 = main_x + item.rect_value / 2
    when 2 # Row
      x1 = 0; x2 = Graphics.width
      y1 = main_y - item.rect_value / 2
      y2 = main_y + item.rect_value / 2
    else # Map
      x1 = 0; x2 = Graphics.width
      y1 = 0; y2 = Graphics.height
    end
    in_x = ((x1..x2) === target_x)
    in_y = ((y1..y2) === target_y)
    return (in_x && in_y)
  end
  
end # Game_Action

#==============================================================================
# Å° Game_Battler
#==============================================================================

class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # new method: hitbox
  #--------------------------------------------------------------------------
  def hitbox
    rect = Rect.new(0, 0, 32, 32)
    rect.x = screen_x - hitbox_width/2 + hitbox_x_offset
    rect.y = screen_y - hitbox_height + hitbox_y_offset
    rect.width = hitbox_width
    rect.height = hitbox_height
    return rect
  end
  
  #--------------------------------------------------------------------------
  # new method: hitbox_x_offset
  #--------------------------------------------------------------------------
  def hitbox_x_offset
    return 0
  end
  
  #--------------------------------------------------------------------------
  # new method: hitbox_y_offset
  #--------------------------------------------------------------------------
  def hitbox_y_offset
    return 0
  end
  
  #--------------------------------------------------------------------------
  # new method: hitbox_width
  #--------------------------------------------------------------------------
  def hitbox_width
    return sprite.width
  end
  
  #--------------------------------------------------------------------------
  # new method: hitbox_height
  #--------------------------------------------------------------------------
  def hitbox_height
    return sprite.height
  end
  
end # Game_Battler

#==============================================================================
# Å° Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # anti-crash method: screen_x
  #--------------------------------------------------------------------------
  unless method_defined?(:screen_x)
  def screen_x
    dw = Graphics.width / $game_party.max_battle_members
    return index * dw + dw / 2
  end 
  end # method_defined?(:screen_x)
  
  #--------------------------------------------------------------------------
  # anti-crash method: screen_y
  #--------------------------------------------------------------------------
  unless method_defined?(:screen_y)
  def screen_y
    return Graphics.height - 120
  end 
  end # method_defined?(:screen_x)
  
  #--------------------------------------------------------------------------
  # new method: sprite
  #--------------------------------------------------------------------------
  unless method_defined?(:sprite)
  def sprite
    index = $game_party.battle_members.index(self)
    return SceneManager.scene.spriteset.actor_sprites[index]
  end
  end # method_defined?(:sprite)
  
  #--------------------------------------------------------------------------
  # new method: hitbox_y_offset
  #--------------------------------------------------------------------------
  def hitbox_y_offset
    return -4
  end
  
end # Game_Actor

#==============================================================================
# Å° Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # new method: sprite
  #--------------------------------------------------------------------------
  def sprite
    return SceneManager.scene.spriteset.enemy_sprites.reverse[self.index]
  end
  
  #--------------------------------------------------------------------------
  # new method: hitbox_x_offset
  #--------------------------------------------------------------------------
  def hitbox_x_offset
    return enemy.offset_x unless enemy.offset_x.nil?
    return super
  end
  
  #--------------------------------------------------------------------------
  # new method: hitbox_y_offset
  #--------------------------------------------------------------------------
  def hitbox_y_offset
    return enemy.offset_y unless enemy.offset_y.nil?
    return super
  end
  
  #--------------------------------------------------------------------------
  # new method: hitbox_width
  #--------------------------------------------------------------------------
  def hitbox_width
    return enemy.hitbox_w unless enemy.hitbox_w.nil?
    return super
  end
  
  #--------------------------------------------------------------------------
  # new method: hitbox_height
  #--------------------------------------------------------------------------
  def hitbox_height
    return enemy.hitbox_h unless enemy.hitbox_h.nil?
    return super
  end
  
end # Game_Enemy

#==============================================================================
# Å° Window_BattleEnemy
#==============================================================================

class Window_BattleEnemy < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias method: update
  #--------------------------------------------------------------------------
  alias window_battlenemy_update_aoe update
  if $imported["YEA-BattleEngine"]
  def update
    window_battlenemy_update_aoe
    return unless active
    return if BattleManager.actor.input.item.nil?
    for enemy in $game_troop.alive_members
      next unless hightlight_aoe?(enemy)
      enemy.sprite_effect_type = :whiten
    end
  end
  end # $imported["YEA-BattleEngine"]
  
  #--------------------------------------------------------------------------
  # new method: hightlight_aoe?
  #--------------------------------------------------------------------------
  def hightlight_aoe?(enemy)
    target = @data[index]
    if BattleManager.actor.input.item.aoe_radius > 0
      return true if BattleManager.actor.input.inside_aoe_circle?(target, enemy)
    end
    if BattleManager.actor.input.item.rect_type > 0
      return true if BattleManager.actor.input.inside_aoe_square?(target, enemy)
    end
    return false
  end
  
end # Window_BattleEnemy

#==============================================================================
# Å° Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :enemy_window
  attr_accessor :actor_window
  attr_accessor :spriteset
  
end # Scene_Battle

#==============================================================================
# 
# Å• End of File
# 
#==============================================================================