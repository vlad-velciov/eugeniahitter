module CreateOn

  class Bullet

    def initialize(window, direction, x, y, adversary)
      @x = x
      @y = y
      @direction = direction
      @adversary = adversary
      @active = true

      @fire_sound = Song.new(window, "media/fire_bullet.wav")
      @fire_sound.play(false)
      @window = window
      @image = Image.new(@window, "media/eugenia_3.png")
    end

    def update_state
      @x -= 15 if @direction == :left
      @x += 15 if @direction == :right
      handle_hit if hit_player?
    end

    def handle_hit
      if @active
        @adversary.health.decrease
        Song.new(@window, "media/hit.wav").play(false)
        hide_bullet
      end

      @active = false
    end

    def hide_bullet
      @y = -1000
    end

    def draw
      factor = 1.0 if @direction == :left
      factor = -1.0 if @direction == :right

      @image.draw(@x + 15*factor, @y, 0, factor, 1.0)
    end

    def hit_player?
        (@adversary.x - @x).abs < 20 && (@adversary.y - @y).abs < 50
    end
  end

end
