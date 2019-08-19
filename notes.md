# Notes

## 2019-08-13_0954 Justifying the `ANV.Readables.Schemas.Ad` schema

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

## 2019-08-16_1142 On the ImageMagick `Task`s

The   task   itself   is  to   converts   an   image
to   reduced   quality    (and   file   sized)   JPG
to   a  predefined   output   directory  (see   also
https://stackoverflow.com/questions/2257322   ),  to
reduce loading  time. (Still too big  though and not
very adaptive.)

Initially started  using `Task.start/1`  because the
conversion took  too long  and basically  the upload
process  would time  out,  discarding the  remaining
unprocessed  files  (and  commands).  `Task.start/1`
starts unlinked  processes to  do the  conversion (a
side  effect),  so that  seemed  to  help, but  this
entire  thing turned  out  to  me a  `live_reloader`
issue  (maybe  because  images have  been  moved  to
`priv/static/images/`?).

Anyway, it helps speeding things up.

### Why moving it from `Ads` to `AdsController`?

`Ads` is  part of  the `Readables` context  in `ANV`
(backend), and  `AdsController` belongs  to `ANVWeb`
(frontend).  Moved  it  because  load  times  are  a
concern for the frontend,  and the ImageMagick tasks
are an optimization for this.

## 2019-08-17_0756 Why the media context?

Originally,  this  was  created when  following  the
examples  in Programming  Phoenix  1.4. Access  News
only has recordings at the moment, as it was a phone
service initially, but there may be other content in
the  future  (such  as Braille,  videos  with  audio
description, etc.).

## 2019-08-17_1835 On moving to UUIDs and exposing primary keys

### Moving to UUIDs

All users  present are coming from  other databases,
hence only  those IDs are stored  (`source_id`), and
only  their  most  essential  information.  Have  no
control  over those  databases  though, therefore  I
would like these users to have a fairly unique ID as
well.

### Exposing primary keys

There are a lot of reasons not to (security, SEO, etc.; see below),

+ https://softwareengineering.stackexchange.com/questions/218306/why-not-expose-a-primary-key/
+ https://stackoverflow.com/questions/32207121/restful-vs-seo-urls
+ https://stackoverflow.com/questions/11451061/using-database-primary-key-in-html-id

and not planning to, but maybe it isn't always a concern.

#### Pages under authorization constraints

Pages, that are only available when users are signed
in, shouldn't be  indexed (like Stackoverflow pages,
that are  public to people without  logins as well).
Another, albeit  weak, argument is that  the content
would change fairly often (exception: Old Time Radio
Theater).

#### Public pages

Shouldn't expose IDs. Period.

#### Bottom line

Will  try   not  to  expose  them,   especially  for
recordings,  and   hopefully  can  find   a  natural
alternative.  (Article title?  They  are subject  to
change. - Although, aren't  redirects there just for
that reason?

TODO: Figure out redirects.
