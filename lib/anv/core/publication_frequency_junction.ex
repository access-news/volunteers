defmodule ANV.Core.PublicationFrequencyJunction do

  # TODO 2019-09-25_0806 create junction modules via templates
  #
  # Some   (all?)   of   the  junction   modules   (such
  # as  PublicationFrequencyJunction,  UserRoleJunction,
  # PublicationTypeJunction,   PublicationTopicJunction,
  # etc.)  are so  similar  that only  the module  names
  # change.
  #
  # The same goes for junction migrations.
  #
  # Also      applies      to     the      "enumeration"
  # end     of     a    `many_to_many`     relationship,
  # such   as   PublicationFrequency,   PublicationType,
  # AccessNewsRole, etc.
  #
  # Just noticed that `belongs_to`s args are conversions
  # of each other too: snake_case <-> CamelCase

  use Ecto.Schema
  import Ecto.Changeset

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Publication,
    PublicationFrequency
  }

  @table_name R.table_name(__MODULE__).string
  @primary_key      false
  @foreign_key_type :binary_id

  schema @table_name do

    belongs_to :publication, Publication
    belongs_to :publication_frequency, PublicationFrequency

    timestamps()
  end

  # see TODO 2019-09-25_0954
end
