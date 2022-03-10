defmodule Doofly.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :id, :integer, rimary_key: true, auto_increment: true
      add :hash, :string, size: 45
      add :url, :text, null: false

      timestamps()
    end
  end
end
