defmodule ANV.Readables do
  @moduledoc """
  The Readables context.
  """

  alias ANV.Readables.Ads
  alias ANV.Readables.Ads.Ad
  alias ANV.Repo

  def change_ad_submission(ad \\ %Ad{}, params)
  def change_ad_submission(%Ad{} = ad, params) do
    Ad.ads_changeset(ad, params)
  end

  def list_ads() do
    Repo.all(Ad)
  end

  def get_ad(id) do
    Repo.get(Ad, id)
  end

  def get_ad!(id) do
    Repo.get(Ad, id)
  end

  def get_ad_by(params) do
    Repo.get_by(Ad, params)
  end

  # NOTE 2019-08-13_1001

  # If  only the  `store_id` and  `store_name` keys  are
  # provided then only a new store entry is added.
  def add_store(new_ad) do
    new_ad
    |> change_ad_submission()
    |> Repo.insert()
  end

  def update_ads(ad_submission) do
    # Ads.delete_previous_images(store_id)
    # Repo.update(new_ad)
  end
end
