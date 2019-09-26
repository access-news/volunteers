# TODO 2019-08-18_1040 How to add initial user in prod?

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
alias ANV.Repo.Aid, as: R
alias ANV.Accounts.{
  User,
  AccessNewsRole
}

for role <- AccessNewsRole.roles() do
  %AccessNewsRole{}
  |> AccessNewsRole.changeset(%{ role: role })
  # Removed bang  (!) because it  would fail when  it is
  # already added.
  |> ANV.Repo.insert()
end

admin_role = ANV.Repo.get_by(AccessNewsRole, role: "admin")

%User{}
|> User.changeset(%{username: "admin", credential: %{ password: "admin", password_length: 5}})
|> Ecto.Changeset.put_assoc(R.table_name(AccessNewsRole).atom, [admin_role])
  # Removed bang  (!) because it  would fail when  it is
  # already added.
|> ANV.Repo.insert()

# mix do ecto.drop, ecto.create, ecto.migrate, run priv/repo/seeds.exs
# see `mix.exs`

# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
