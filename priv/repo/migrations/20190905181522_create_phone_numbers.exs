defmodule ANV.Repo.Migrations.CreatePhoneNumbers do
  use Ecto.Migration

  def change do

    create table(:phone_numbers, primary_key: false) do

      add :id, :uuid, primary_key: true

      # TODO?
      # https://dba.stackexchange.com/questions/164796/how-do-i-store-phone-numbers-in-postgresql
      add :phone_number, :string

      add(
        :user_id,
        references(
          :users,
          on_delete: :delete_all,
          type:      :uuid
        ),
        null: false # NOTE 2019-08-31_0513
      )

      timestamps()
    end

    create unique_index(:phone_numbers, [:phone_number])

    # https://stackoverflow.com/questions/24403085
    # https://elixirforum.com/t/how-to-debug-ecto-migration-constraints
    create constraint(
      :phone_numbers,
      :phone_number_must_be_a_ten_digit_string,
      check: "\"phone_number\" ~ '^\\d{10}$'"
    )
  end
end
