defmodule SafePet24Web.PageController do
  use SafePet24Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
