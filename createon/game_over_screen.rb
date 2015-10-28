module CreateOn

  class GameOverScreen

    def initialize(window)
      @window = window
      @title = Image.new(
          @window, "media/game_over.png")
    end

    def draw(x, y)
      @title.draw(x, y,0)
    end

    def update ; end
  end
end
