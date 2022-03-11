defmodule DooflyWeb.CustomUrlLive do
  use Phoenix.LiveView, layout: {DooflyWeb.LayoutView, "links.html"}

  alias Doofly.Links

  def mount(_params, _session, socket) do
    {:ok, assign(socket, url: nil, error: nil)}
  end

  def render(assigns) do
    ~H"""
    <form phx-submit="generate-custom-url">
      <input class="InputStyle" placeholder="Paste here the link you want to shorten" name="original-url" stype="text" autocomplete="off">
      <input class="InputStyle" placeholder="Paste here the custom slug for your url" name="custom-slug" stype="text" autocomplete="off">
      <input class="btn btn-light btn-submit" type="submit" value="Short URL"/>
    </form>
    <%= if @url do %>
      <div type="" id="text-result" class="btn-result"><%= @url %></div>
    <% end %>
    <%= if @error do %>
      <div class="alert alert-danger" role="alert">
        <%= @error %>
      </div>
    <% end %>
    """
  end

  def handle_event(
        "generate-custom-url",
        %{"original-url" => original_url, "custom-slug" => custom_slug},
        socket
      ) do
    link =
      case Links.create(original_url, Slug.slugify(custom_slug)) do
        {:ok, short_url} ->
          %{full_link: Links.get_full_link(short_url), error: false}

        {:error, _} ->
          %{full_link: nil, error: "The requested url isn't valid"}
      end

    {
      :noreply,
      assign(
        socket,
        url: link.full_link,
        error: link.error
      )
    }
  end
end
