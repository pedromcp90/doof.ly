defmodule Doofly.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Doofly.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{})
      |> Doofly.Links.create_link()

    link
  end
end
