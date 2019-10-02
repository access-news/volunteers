defmodule ANV.Core.Publication do

  use ANV.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    PublicationType          \
  , PublicationTypeJunction  \
  , Topic                    \
  , PublicationTopicJunction \
  , Issue                    \
  }

  @table_name R.table_name(__MODULE__).string

  schema @table_name do

    field :name, :string

    many_to_many(
      R.table_name(PublicationType).atom,
      PublicationType,
      join_through: PublicationTypeJunction
    )

    # NOTE 2019-09-25_1100 volume|issue|edition
    # https://www.differencebetween.com/difference-between-edition-and-vs-issue/
    # https://en.wikipedia.org/wiki/Periodical_literature
    has_many(
      R.table_name(Issue).atom,
      Issue
    )

    # NOTE 2019-09-25_1046 topics for articles only
    # Derive the topics of a particular newspaper from the
    # topics of its articles.
    #
    # many_to_many(
    #   Topic.table_atom(),
    #   Topic,
    #   join_through: PublicationTopicJunction
    # )

    timestamps()
  end
end
