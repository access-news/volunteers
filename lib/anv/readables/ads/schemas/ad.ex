defmodule ANV.Readables.Ads.Ad do
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

    # TODO: add  validation to check that  `valid_to` does
    #       not come before `valid_from`
    #
    # Consider  where this  check  should be:  if this  is
    # false, then do not  start copying and reducing files
    # in `ads.ex`!

    req_fields = [
      :store_name,
    ]

    fields =
      req_fields
      ++ [:valid_from, :valid_to]

    ads
    |> cast(attrs, fields)
    |> validate_required(req_fields)
    |> unique_constraint(:store_name)

    |> cast_embed(
         :sections,
         with: &sections_changeset/2
       )
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
