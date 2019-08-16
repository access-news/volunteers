defmodule ANV.Repo.Migrations.CreateAds do
  use Ecto.Migration

  def change do

    create table("ads") do
      add :store_name, :string, null: false
      add :valid_from, :date
      add :valid_to,   :date
      add :sections,   :map

      # {
      #   {
      #     "content_type" : "image/jpeg",
      #     "section"      : "1",
      #     "path"         : "/images/ads/uuid1.png",
      #     "reserved"     : boolean
      #   },
      #   {
      #     "content_type" : "image/png",
      #     "section"      : "2",
      #     "path"         : "/images/ads/uuid2.png",
      #     "reserved"     : boolean
      #   },
      #   # ...
      # }

      timestamps()
    end

    create unique_index(:ads, [:store_name])
  end
end
