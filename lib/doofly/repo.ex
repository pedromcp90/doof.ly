defmodule Doofly.Repo do
  use Ecto.Repo,
    otp_app: :doofly,
    adapter: Ecto.Adapters.Postgres
end
