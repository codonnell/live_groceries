defmodule LiveGroceries.Repo do
  use Ecto.Repo,
    otp_app: :live_groceries,
    adapter: Ecto.Adapters.Postgres
end
