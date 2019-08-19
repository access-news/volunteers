defmodule ANV.Readables do
  @moduledoc """
  The Readables context.
  """

  alias ANV.Readables.Ads
  alias ANV.Readables.Schemas.Ad
  alias ANV.Repo

  def list_ads() do
    Repo.all(Ad)
  end

  def get_ad(id) do
    Repo.get(Ad, id)
  end

  def get_ad!(id) do
    Repo.get!(Ad, id)
  end

  def get_ad_by(params) do
    Repo.get_by(Ad, params)
  end

  def delete_ad!(id) do
    id
    |> get_ad!()
    |> Ads.delete_section_images()
    |> Repo.delete!()
  end

  def delete_all() do
    list_ads()
    |> Enum.each(&Ads.delete_section_images/1)

    Repo.delete_all(Ad)
  end

  def reset_ad(ad) do
    update_ad(
      ad,
      %{
        valid_from: nil,
        valid_to:   nil,
        sections:   []
      }
    )
  end

  def reset_all() do
    list_ads()
    |> Enum.each(&reset_ad/1)
  end

  # NOTE 2019-08-13_1001

  def change_ad_submission(ad \\ %Ad{}, params)
  def change_ad_submission(%Ad{} = ad, params) do
    Ad.ads_changeset(ad, params)
  end

  # Only   a  new   store  entry   is  added,   if  only
  # `store_name` is specified.
  def add_store(new_ad) do
    new_ad
    |> change_ad_submission()
    |> Repo.insert()
  end

  def update_ad(id, update) do
    id
    |> get_ad!()
    |> Ads.delete_section_images()
    |> Ecto.Changeset.change(update)
    |> Repo.update()
  end
end
