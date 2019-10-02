defmodule ANV.Repo.Migrations.CreateIssues do

  use Ecto.Migration

  alias ANV.Repo.Aid, as: R
  alias ANV.Core.{
    Issue       \
  , Publication \
  }

  @table_name R.table_name(Issue).atom

  def change do

    create table(@table_name, primary_key: false) do

      add :id, :uuid, primary_key: true
      add :name,         :string, null: false # ---*
      add :published_at, :date,   null: false #    |
      add :valid_until,  :date                #    |
                                              #    |
      add(                                    #    |
        :publication_id,                      #    |
        references(                           #    |
          R.table_name(Publication).atom,     #    |
          on_delete: :delete_all,             #    |
          type:      :uuid                    #    |
        ),                                    #    |
        null: false # NOTE 2019-08-31_0513    #    |
      )                                       #    |
                                              #    |
      timestamps()                            #    |
    end                                       #   /
                                              #  /
    # NOTE 2019-09-27_0809 NULLs and multi-column unique constraints
    #
    # The notion is that if there are issues with the same
    # release date (e.g., Entertainment Weekly) then those
    # issue  should  be  disambiguated  with  a  name.  So
    # technically  `name` is  not required,  but adding  a
    # unique constraint on both  column requires it to be,
    # because ["_even in the presence of a unique constraint
    # it is possible to store duplicate rows that contain a
    # null value in at least one of the constrained columns
    # _"](https://www.postgresql.org/docs/11/ddl-constraints.html#DDL-CONSTRAINTS-UNIQUE-CONSTRAINTS].
    create unique_index(@table_name, [:name, :published_at])
  end
end
