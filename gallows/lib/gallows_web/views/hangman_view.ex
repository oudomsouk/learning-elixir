defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view

  import Gallows.Views.Gelpers.GameStateHelper

  def game_over?(%{ game_state: game_state }) do
    game_state in [ :won, :lost ]
  end

  def new_game_button(conn) do
    button("New Game", to: Routes.hangman_path(conn, :create_game))
  end

  def format_letters(letters) do
    letters
    |> Enum.join(" ")
  end

end
