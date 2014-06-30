class Window_VictoryLevelUp < Window_Base
  def draw_former_stats(actor)
    dw = contents.width / 2 - 12
    dy = 0
    change_color(normal_color)
    draw_text(0, dy, dw, line_height, actor.level.group, 2)
    for i in 0...8
      dy += line_height
      draw_text(0, dy, dw, line_height, actor.param_base(i).group, 2)
    end
  end
  def draw_newer_stats(actor, temp_actor)
    dx = contents.width / 2 + 12
    dw = contents.width - dx
    dy = 0
    change_color(param_change_color(actor.level - temp_actor.level))
    draw_text(dx, dy, dw, line_height, actor.level.group, 0)
    for i in 0...8
      dy += line_height
      change_color(param_change_color(actor.param_base(i) - temp_actor.param_base(i)))
      draw_text(dx, dy, dw, line_height, actor.param_base(i).group, 0)
    end
  end
end