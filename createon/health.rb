module CreateOn

  class Health

    def initialize(x, y, window, factor)
      @factor = factor
      @x = x
      @y = y
      @images = []
      5.times {@images << Image.new(window, "media/ruby_health.png")}
    end

    def decrease
      @images.pop
    end

    def draw
      offset = 50 * @factor
      currentX= @x
      @images.each do |image|
        image.draw(currentX, @y, 0, 1.0, 1.0)
        currentX += offset
      end
    end

    def depleted?
      @images.count == 0
    end
  end
end
