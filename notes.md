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

## 2019-08-13_1001 Backend (context) vs frontend

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

## 2019-08-14_1556 date_tuples, dates_map, etc.

Needed  because  the  form   for  adding  new  store
(`ads/new.html.eex`) returns a

```elixir
%{"day" => "14", "month" => "08", "year" => "2019"}
```

map,  so that  needs  to be  converted  to a  `Date`
struct,  but  first,  it  needs  to  converted  into
a  format that  is  accepted by  `datetime_select/?`
(which is  passed from the changeset  that is passed
as an assign from the controller).

## 2019-08-15_0645 ditch eex and changesets validation

(See also 2019-08-14_1556 above.)

I couldn't  get `datetime_select/3` accept  any date
related types despite
[what the docs say](https://hexdocs.pm/phoenix_html/2.13.3/Phoenix.HTML.Form.html#datetime_select/3-supported-date-values).
`Date` and  `DateTime` both have the  required keys,
but they still keep failing, and therefore I have to
jump through  all the hoops to  translate all Elixir
`Date`s to tuples.

This  also becomes  very misleading  when trying  to
supply a changeset of  a failed form submission (see
`AdsController.create/2`), because  it seems  like I
am trying  to update  the record with  the obviously
wrong data  (tuples instead of a  `Date` struct). Of
course, this  changeset is discarded as  soon as the
form is re-created, I associate changesets with data
persistence.

So switch to  a frontend framework (will  need to do
it anyways).