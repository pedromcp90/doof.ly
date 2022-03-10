defmodule Doofly.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "links" do
    field :url, :string
    field :hash, :string
    field :visits, :integer

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :hash, :visits])
    |> validate_required([:url, :hash])
    |> validate_url(:url)
  end

  def validate_url(changeset, field, options \\ %{}) do
    validate_change(changeset, field, fn :url, url ->
      uri = URI.parse(url)

      if uri.scheme == nil do
        [{field, options[:message] || "Please enter valid url!"}]
      else
        []
      end
    end)
  end
end
