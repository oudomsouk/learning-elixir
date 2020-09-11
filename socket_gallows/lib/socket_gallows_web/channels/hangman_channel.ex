defmodule SocketGallowsWeb.HangmanChannel do

  use Phoenix.Channel

  require Logger

  def join("hangman:game", _, socket) do
    game = Hangman.new_game()
    socket = assign(socket, :game, game)
    { :ok, socket }
  end

  @spec handle_in(String.t(), any, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_in("tally", _, socket) do
    game = socket.assigns.game
    tally = Hangman.tally(game)
    push(socket, "tally", %{
      game_state: tally.game_state,
      letters: tally.letters,
      turns_left: tally.turns_left,
    })
    { :noreply, socket }
  end

  def handle_in(msg, _, _socket), do: Logger.error("Unkown message: #{msg}")

end
