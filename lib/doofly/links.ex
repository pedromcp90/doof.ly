defmodule Doofly.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias Doofly.Repo

  alias Doofly.Links.Link

  def get_by_id(id) do
    Repo.get_by(Link, id: id)
  end

  def create(url) do
    hash = random_string(8)

    case create(url, hash) do
      {:ok, link} -> {:ok, link}
      {:error, :already_exists} -> create(url)
      {:error, %Ecto.Changeset{} = error} -> {:error, error}
    end
  end

  def create(url, hash) do
    case get_by_id(hash) do
      %Link{} ->
        {:error, :already_exists}

      nil ->
        attrs = %{id: hash, url: url}

        case create_link(attrs) do
          {:ok, link} -> {:ok, link}
          {:error, error} -> {:error, error}
        end
    end
  end

  def get_url_from_id(id) do
    case get_by_id(id) do
      nil ->
        {:error, :url_not_found}

      link ->
        {:ok, link.url}
    end
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  defp random_string(string_length) do
    :crypto.strong_rand_bytes(string_length)
    |> Base.url_encode64()
    |> binary_part(0, string_length)
  end
end
