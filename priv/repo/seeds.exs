# TODO 2019-08-18_1040 How to add initial user in prod?

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
alias ANV.Accounts.User

%User{}
|> User.registration_changeset(
     %{
       username: "admin",
       password: "admin",
       roles: [
         %{
           role: "admin",
           source_id: "initial_for_testing"
         }
       ]
     },
     passwd_min_length: 5
   )
# Removed bang  (!) because it  would fail when  it is
# already added.
|> ANV.Repo.insert()

#     ANV.Repo.insert!(%ANV.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
