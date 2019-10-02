defmodule ANV.Schema do

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @timestamps_opts  [type: :utc_datetime]

      # Junction tables don't need  a primary key, but those
      # can override this locally
      @primary_key      {:id, :binary_id, autogenerate: true}

      # Only needed for schemas with `belongs_to/3`
      @foreign_key_type :binary_id
    end
  end

end
