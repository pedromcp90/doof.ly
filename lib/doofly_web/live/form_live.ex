defmodule DooflyWeb.FormLive do
  use Phoenix.LiveView, layout: {DooflyWeb.LayoutView, "links.html"}

  alias Doofly.Links

  def mount(_params, _session, socket) do
    {:ok, assign(socket, url: nil )}
  end

  def render(assigns) do
    ~H"""
    <form phx-submit="generate-url">
      <input class="InputStyle" placeholder="Paste here the link you want to shorten" phx-value-url="" name="original-url" stype="text">
      <input type="submit" value="Short URL"/>
    </form>
    <h1><%= @url %></h1>
    """
  end

  def handle_event("generate-url", %{"original-url" => original_url}, socket) do

    {:ok, short_url} = Links.create(original_url)
    full_link = Links.get_full_link(short_url)
    {
    :noreply,
    assign(
    socket,
    url: full_link)}
    end
end
