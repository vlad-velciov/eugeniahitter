module CreateOn

  require_relative '../createon/bullet'

  class Player
    attr_accessor :standing, :walkL, :walkR, :jump, :x, :y, :vy, :health, :controls, :winner_text

    def initialize(x, y, dir, vy, window, name, image_path, controls)


      @winner_text = Image.from_text(window,
                                    name + " won!!!!",
                                    Gosu::default_font_name,
                                     150,
                                     10,
                                     1440,
                                    :center)
      @window = window
      @controls = controls
      @x = x
      @y = y
      @health = 100
      @dir = dir
      @vy = vy
      @standing, @walkL, @walkR, @jump = *Image.load_tiles(@window, image_path, 100, 160, false)
      @state = @standing
    end

    def update_position
      accelerate_vertically

      move_x = 0
      move_x -= 5 if @window.button_down? @controls[:left]
      move_x += 5 if @window.button_down? @controls[:right]

      change_state(move_x)
      move_horizontally(move_x)
      move_vertically
    end

    def can_fire?
      (milliseconds % 5 == 0)
    end

    def shoot
      @window.bullets << Bullet.new(@window, @dir, @x, @y, my_adversary)
    end

    def my_adversary
      return @window.player1 if @controls[:left] == KbA
      @window.player2 if @controls[:left] == KbLeft
    end

    # Select image depending on action
    def change_state(move_x)
      if move_x == 0
        @state = @standing
      else
        @state = (milliseconds / 175 % 2 == 0) ? @walkL : @walkR
      end

      if @vy < 0
        @state = @jump
      end
    end

    # Directional walking, horizontal movement
    def move_horizontally(move_x)
      if move_x > 0
        @dir = :right
        move_x.times { @x += 1 }
      end
      if move_x < 0
        @dir = :left
        (-move_x).times { @x -= 1 }
      end
    end

    # Acceleration/gravity
    # By adding 1 each frame, and (ideally) adding vy to y, the player's
    # jumping curve will be the parabole we want it to be.
    def move_vertically
      @vy += 1

      # Vertical movement
      if @vy > 0 && @y <  500 # TODO set externally
        @vy.times { @y += 1 }
      end
      if @vy < 0
        (-@vy).times { @y -= 1 }
      end
    end

    def draw
      if @dir == :left
        offs_x = -25
        factor = 1.0
      else
        offs_x = 25
        factor = -1.0
      end
      @health.draw
      @state.draw(@x + offs_x, @y - 49, 0, factor, 1.0)
    end

    def accelerate_vertically
      @vy = -20 if @window.button_down? @controls[:up]
    end

    def dance
      move_to_center
      state_array = [@walkL, @walkR, @jump, @standing]
      @state = state_array.shuffle.first if milliseconds % 4 == 0
    end

    def move_to_center
      @x = 600
      @y = 500
    end
  end
end