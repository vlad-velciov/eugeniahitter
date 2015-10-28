#!/usr/bin/env ruby -w
require 'rubygems'
require 'gosu'
include Gosu
require_relative 'createon/floor'
require_relative 'createon/player'
require_relative 'createon/bullet'
require_relative 'createon/game_over_screen'
require_relative 'createon/health'

class Game < Window
  attr_accessor :bullets, :player1, :player2
  FLOOR_OFFSET = 600

  def initialize
    super(1240, 800, false)
    self.caption = "Eugenia Hitter"
    @playing_winning_song = false

    @game_started = false
    @start_screen = Image.new(self, "media/start_screen.png")
    init_players
    @bullets = []
    @floor = CreateOn::Floor.new(self, 0, FLOOR_OFFSET, 1240, 480, Color::WHITE)
    @winning_song = Song.new(self, "media/winning_song.wav")
  end

  def show_init_screen
    @start_screen.draw(450, 200, 0, 1.0, 1.0) unless @game_started
  end

  def init_players
    @player1 = CreateOn::Player.new(900, 0, :left, 0, self, 'Player 1', "media/sprites.png", left: KbLeft, right: KbRight, up: KbUp, shoot: KbRightShift)
    @player2 = CreateOn::Player.new(300, 0, :right, 0, self, 'Player 2', "media/sprites2.png", left: KbA, right: KbD, up: KbW, shoot: KbSpace)

    @player1.health = CreateOn::Health.new(1190, 0, self, -1)
    @player2.health = CreateOn::Health.new(0, 0, self, 1)
  end

  def update
    if game_won?
      @winner.dance
      play_song
    else
      @player1.update_position
      @player2.update_position

      update_bullets_states
    end
  end

  def play_song
    @winning_song.play(false) unless @playing_winning_song
    @playing_winning_song = true
  end

  def game_won?
    @winner = @player1  if @player2.health.depleted?
    @winner = @player2 if @player1.health.depleted?

    @player1.health.depleted? || @player2.health.depleted?
  end

  def update_bullets_states
    @bullets.each do |bullet|
      bullet.update_state
    end
  end

  def draw_bullets
    @bullets.each do |bullet|
        bullet.draw
    end
  end

  def draw
    unless @game_started
      show_init_screen
      return
    end
    if !game_won?
      @floor.draw
      @player1.draw
      @player2.draw
      draw_bullets
    else
      @floor.draw
      @winner.draw
      @winner.winner_text.draw(-100, 100, 0, 1.0, 1.0)
    end
  end

  def show_game_won
    CreateOn::GameOverScreen.new(self).draw(300,100)
  end

  def button_down(id)
    @game_started = true
    @player1.shoot if id == @player1.controls[:shoot]
    @player2.shoot if id == @player2.controls[:shoot]

    end_game(id) if game_won? # TODO not exiting right
    close if id == KbEscape
  end

  def end_game(id)
    close if id == KbEscape
    reset if id == KbF1
  end

  def reset
    @playing_winning_song = false
    @bullets = []
    self.init_players
  end
end

Game.new.show
