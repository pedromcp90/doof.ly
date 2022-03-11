defmodule Doofly.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias Doofly.Repo

  alias Doofly.Links.Link

  def get_by_hash(hash) do
    Repo.get_by(Link, hash: hash)
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
    url = check_url_protocol(url)

    case get_by_hash(hash) do
      %Link{} ->
        {:error, :already_exists}

      nil ->
        attrs = %{hash: hash, url: url}

        case create_link(attrs) do
          {:ok, link} -> {:ok, link.hash}
          {:error, error} -> {:error, error}
        end
    end
  end

  def get_full_link(hash) do
    DooflyWeb.Endpoint.url() <> "/" <> hash
  end

  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  def update_visits_for_link(link) do
    update_link(link, %{visits: link.visits + 1})
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

  def check_url_protocol(url) do
    regex = ~r/^https?:\/\//

    case Regex.match?(regex, url) do
      true -> url
      false -> "http://#{url}"
    end
  end
end
