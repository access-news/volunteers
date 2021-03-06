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
  , articles:                    Core.Article                      \
  , topics:                      Core.Topic                        \
  , articles_topics_junction:    Core.ArticleTopicJunction         \
  , issues:                      Core.Issue                        \
  , publications:                Core.Publication                  \
  , publication_type:            Core.PublicationType              \
  , publications_types_junction: Core.PublicationTypeJunction      \
  , recordings:                  Core.Recording                    \
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
end
