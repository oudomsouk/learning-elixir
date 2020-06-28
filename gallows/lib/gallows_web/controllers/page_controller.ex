defmodule GallowsWeb.PageController do
  use GallowsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", produce: "apple", count: 1)
  end
end
