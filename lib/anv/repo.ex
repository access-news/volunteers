defmodule ANV.Repo do
  use Ecto.Repo,
    otp_app: :anv,
    adapter: Ecto.Adapters.Postgres
end
