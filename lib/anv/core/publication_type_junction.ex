defmodule ANV.Core.PublicationTypeJunction do

  use ANV.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Publication,
    PublicationType
  }

  @table_name R.table_name(__MODULE__).string
  @primary_key false

  schema @table_name do

    belongs_to :publication,      Publication
    belongs_to :publication_type, PublicationType

    timestamps()
  end

  # see TODO 2019-09-25_0954
end
