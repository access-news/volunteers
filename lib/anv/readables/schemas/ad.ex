defmodule ANV.Readables.Schemas.Ad do
  use Ecto.Schema
  import Ecto.Changeset

  # NOTE 2019-08-13_0954 schema justification

  schema "ads" do
    field :store_name, :string
    field :valid_from, :date
    field :valid_to,   :date

    embeds_many :sections, Sections,
      on_replace: :delete
    do
      field :section_id,   :integer
      field :path,         :string
      field :reserved,     :boolean
      field :content_type, :string  # i.e., MIME type
    end

    timestamps()
  end

  # TODO:
  # cleanup  public functions  (i.e., make  private that
  # are not directly needed)

  def ads_changeset(ads, attrs) do

    dates = [:valid_from, :valid_to]

    req_fields = [
      :store_name,
    ]

    fields = req_fields ++ dates

    ads
    |> cast(attrs, fields)
    |> validate_required(req_fields)
    |> unique_constraint(:store_name)
    |> validate_from_before_to()

    |> cast_embed(
         :sections,
         with: &sections_changeset/2
       )
  end

  defp validate_from_before_to(
    %Ecto.Changeset{ changes: changes } = changeset
  )
    when changes == %{}
  do
    changeset
  end

  # https://stackoverflow.com/questions/36961176
  defp validate_from_before_to(changeset) do

    from = get_field(changeset, :valid_from)
    to   = get_field(changeset, :valid_to)

    if Date.compare(from, to) == :gt do
      add_error(
        changeset,
        :valid_from,
        "must be earlier than end date"
      )
    else
      changeset
    end
  end

  def sections_changeset(sections, attrs) do

    fields = [
      :section_id,
      :path,
      :reserved,
      :content_type
    ]

    sections
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
