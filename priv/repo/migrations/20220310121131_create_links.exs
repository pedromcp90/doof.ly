defmodule Doofly.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :hash, :string, size: 45
      add :url, :text, null: false
      add :visits, :integer, null: false, default: 0

      timestamps()
    end
  end
end
