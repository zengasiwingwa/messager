defmodule Messager.Repo do
  use Ecto.Repo,
    otp_app: :messager,
    adapter: Ecto.Adapters.Postgres
end
