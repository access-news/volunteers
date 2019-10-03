defmodule ANV.Core.Article do

  @moduledoc """

  Articles => Recordings
  ======================

  The general idea is that articles (title, text, etc)
  are listed on the site, volunteers choose from them,
  and submit their recordings based on them.

  TODO: the articles have to get there somehow.

        Probably scraping  would be the  best, but
        publisher websites  are chaos,  and rarely
        are  HTML  tags  used  in  a  semantically
        correct way.

        So  in the  beginning,  volunteers do  the
        scraping, except  for sites that  are easy
        to  do programmatically  (and those  would
        need quality check still).

  Ads
  ===

  + An issue  corresponds to  a weekly flyer  (hence the
    `:valid_until` field).

  + The  edition is  a geographically  different version
    (but usually they are all the same).

  + An article corresponds to  a specific section in the
    flyer.
  """

  use ANV.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Issue                \
  , Topic                \
  , ArticleTopicJunction \
  }

  @table_name R.table_name(__MODULE__).string

  schema @table_name do

    field :title, :string

    # field :publication_date, :date
    # field :article_text, :string
    # has_many :authors

    belongs_to(
      R.table_name(Issue).atom,
      Issue
    )

    many_to_many(
      R.table_name(Topic).atom,
      Topic,
      join_through: ArticleTopicJunction
    )

    timestamps()
  end
end
