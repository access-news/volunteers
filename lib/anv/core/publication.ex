defmodule ANV.Core.Publication do

  use Ecto.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    PublicationType,
    PublicationTypeJunction,
    PublicationFrequency,
    PublicationFrequencyJunction,
    Topic,
    PublicationTopicJunction,
    # Article,
    # Issue
  }

  @table_name R.table_name(__MODULE__).string
  @primary_key {:id, :binary_id, autogenerate: true}

  schema @table_name do

    field :name, :string

    many_to_many(
      R.table_name(PublicationType).atom,
      PublicationType,
      join_through: PublicationTypeJunction
    )

    many_to_many(
      R.table_name(PublicationFrequency).atom,
      PublicationFrequency,
      join_through: PublicationFrequencyJunction
    )

    # NOTE 2019-09-25_1100 volume|issue|edition
    # https://www.differencebetween.com/difference-between-edition-and-vs-issue/
    # https://en.wikipedia.org/wiki/Periodical_literature
    # has_many :issues, Issue

    # TODO 2019-09-25_1046 topics for articles only
    # Derive the topics of a particular newspaper from the
    # topics of its articles.
    #
    # many_to_many(
    #   Topic.table_atom(),
    #   Topic,
    #   join_through: PublicationTopicJunction
    # )

    # Articles will belong to issues
    # has_many :articles, Article

    timestamps()
  end
end
