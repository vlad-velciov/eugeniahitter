module CreateOn

  class Floor
    attr_accessor :x, :y, :width, :height, :color

    def initialize(window, x, y, width, height, color)
      @x = x
      @y = y
      @width = width
      @height = height
      @color = color
      @window = window
    end

    def draw
      #draw_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z = 0, mode = :default)
      # points are in clockwise order
      @window.draw_quad @x, @y, @color, @x + @width, @y, @color, @x + @width, @y + @height, @color, @x, @y + @height, @color
    end
  end
end

