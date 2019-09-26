defmodule ANV.Repo.Aid do

  alias ANV.Accounts
  alias ANV.Core
  alias ANV.Repo.Migrations

  [ access_news_roles:    Accounts.AccessNewsRole   \
  , credentials:          Accounts.Credential       \
  , data_sources:         Accounts.DataSource       \
  , phone_numbers:        Accounts.PhoneNumber      \
  , users:                Accounts.Users            \
  , users_roles_junction: Accounts.UserRoleJunction \
  , articles:                          Core.Article                      \
  , publications:                      Core.Publication                  \
  , publication_frequencies:           Core.PublicationFrequency         \
  , publications_frequencies_junction: Core.PublicationFrequencyJunction \
  , publication_type:                  Core.PublicationType              \
  , publications_types_junction:       Core.PublicationTypeJunction      \
  ]
  |> Enum.each(
    fn({name, mod}) ->
      def table_name(unquote(mod)) do
      %{
        string: unquote(name) |> to_string(),
        atom:   unquote(name)
      }
      end
    end)

  # TODO 2019-09-25_0927 make all unique indices explicit
  def mk_idx(table_name, fields) when is_list(fields) do
    27
  end

  # TODO 2019-09-25_0933 generate table name functions
  #
  # INPUT:
  # [publications: ANV.Core.Publication,
  #  access_news_roles: ANV.Accounts.AccessNewsRole,
  #   ...
  # ]
  #
  # OUTPUT:
  # def atom_name(ANV.Core.Publication), do: :publications
  # def str_name(ANV.Core.Publication),  do: "publications"
  #
  # NOTE
  # `many_to_many`  also   uses  the  table   names  (at
  # least  in  my   convention)  and  currently  calling
  # `table_atom/0` from the respective modules, but with
  # the new convention it  would also work with aliases,
  # no need of fully qualified module names.
  #
  #   ```elixir
  #   defmodule T do
  #     def lofa(A.B.C), do: 27
  #     def lofa(D.E.F), do: 7
  #   end

  #   defmodule A.B.C do
  #     @miez T.lofa(__MODULE__)
  #     def miez(), do: @miez
  #   end

  #   iex(39)> A.B.C.miez
  #   27
  #   iex(40)> alias A.B.C, as: C
  #   A.B.C
  #   iex(41)> C |> to_string()
  #   "Elixir.A.B.C"
  #   iex(42)> C
  #   A.B.C
  #   iex(43)> T.lofa(C)
  #   27
  #   ```
end
