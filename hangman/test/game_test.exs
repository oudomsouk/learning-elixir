defmodule GameTest do
  use ExUnit.Case
  doctest Hangman

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new_game letters are lowercase" do
    game = Game.new_game()

    assert game.letters |> Enum.join |> String.match?(~r/[a-z]/)
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [ :won, :lost ] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert { ^game, _ } = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do
    game = Game.new_game()
    {  game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurence of letter is not already used" do
    game = Game.new_game()
    {  game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {  game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("win")
    {  game, _tally } = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a won game" do
    game = Game.new_game("win")
    {  game, _tally } = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    {  game, _tally } = Game.make_move(game, "i")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    {  game, _tally } = Game.make_move(game, "n")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    {  game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    game = Game.new_game("wibble")
    {  game, _tally } = Game.make_move(game, "a")
    assert game.turns_left == 6
    assert game.game_state == :bad_guess
    {  game, _tally } = Game.make_move(game, "d")
    assert game.turns_left == 5
    assert game.game_state == :bad_guess
    {  game, _tally } = Game.make_move(game, "c")
    assert game.turns_left == 4
    assert game.game_state == :bad_guess
    {  game, _tally } = Game.make_move(game, "x")
    assert game.turns_left == 3
    assert game.game_state == :bad_guess
    {  game, _tally } = Game.make_move(game, "p")
    assert game.turns_left == 2
    assert game.game_state == :bad_guess
    {  game, _tally } = Game.make_move(game, "f")
    assert game.turns_left == 1
    assert game.game_state == :bad_guess
    {  game, _tally } = Game.make_move(game, "g")
    assert game.game_state == :lost
  end

  test "won game is recognized" do
    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"e", :won}
    ]

    game = Game.new_game("wibble")

    Enum.reduce(moves, game, fn ({guess, state}, new_game) ->
      { new_game, _tally } = Game.make_move(new_game, guess)
      assert new_game.game_state == state
      new_game
    end)
  end
end
