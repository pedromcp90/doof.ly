defmodule DooflyWeb.ApiController do
  use DooflyWeb, :controller

  alias Doofly.Links

  def create(conn, params) do
    %{"url" => url} = params

    case Links.create(url) do
      {:ok, link} -> json(conn, %{status: "success", link: Links.get_full_link(link)})
      {:error, error} -> json(conn, %{status: "error", message: error})
    end
  end
end