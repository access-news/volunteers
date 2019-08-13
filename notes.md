# Notes

## 2019-08-13_0954 Justifying the `ANV.Readables.Ads.Ad` schema

The  schema  should  probably be  separated  at  the
line below  so that  future updates  don't overwrite
previous content,  but these  are periodic  ads that
where  there  is no  point  to  preserve them.  TODO
2019-08-13_0951 also  proves this point:  if someone
still  reserves  the  images  to be  read  when  the
validity runs out, it should simply be reset.

```elixir
schema "ads" do
  field :store_id,   :string
  field :store_name, :string
  # --------------------------------------------------
  field :valid_from, :date
  field :valid_to,   :date

  embeds_many :sections, Sections do
    field :section_id,   :integer
    field :path,         :string
    field :reserved,     :boolean
    field :content_type, :string  # i.e., MIME type
  end

  timestamps()
end
```

# 2019-08-13_1001 Backend (context) vs frontend

The backend  should only provide functions  that are
composable to easily provide for any solution.

For example, the frontend will only show an "Add new
ads" form, that  will create a new  store entry with
ad  images.  One  could  create a  function  on  the
backend  to see  whether  this is  a new  submission
or  an  update (one  needs  `INSERT`,  the other  an
`UPDATE`), but by separating  the store creation and
update makes it more composable.

So  on  the  frontend,  an  update  will  only  call
`update_ads/1`, but if new  store ads are added than
`add_store/1` with `update_ads/1`.
