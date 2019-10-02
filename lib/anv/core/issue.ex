defmodule ANV.Core.Issue do

  @moduledoc """
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
    Publication    \
  , Article        \
  }

  @table_name R.table_name(__MODULE__).string

  schema @table_name do

    field :name, :string
    field :issue_date, :date
    field :valid_until, :date

    belongs_to(
      R.table_name(Publication).atom,
      Publication
    )

    has_many(
      R.table_name(Article).atom,
      Article
    )

    timestamps()
  end
end
