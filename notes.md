# Notes

### 2019-08-05_0553 Committing `MIX_HOME` (i.e., `.nix-shell/.mix`)

Whenever  the Nix  script (in  `shell.nix`) executed
`mix  local.hex`, ca.  8 out  of 10  times it  would
consume  all memory,  the  system would  crawl to  a
halt, and there needed to be a hard reset. This only
seems  to  happen  when installing  Hex  (even  from
its  Github repo,  see  `shell.nix`).  Once Hex  was
up,  Phoenix  install  went smooth  (another  "local
global"), and Rebar as well (yet another).

### 2019-07-31_1133 Backend "upload"

+ `./_ads/form/`

  Temporary  storage of  the existing  store sections,
  each  store   folder  with  a   `meta.json`  holding
  metadata that  would be taken from  a frontend input
  (such as the full name of the store chains).

+ `./_ads/input`

  Emulates an HTML form submission.

#### Current workflow

1. Copy   store   ad   images   to   their   respective
   `./_ads/form` folder, or create a new directory with
   `meta.json` for a new chain.

2. Copy needed folder to `./_ads/input`.

> Step  1.  could  be skipped,  but  reminding  myself
> that only  `./_ads/form` is in source  control. (The
> `meta.json` files in the dirs to be precise.)

3. `ANV.Articles.list()`

   Generate a map from `./_ads/input`'s contents, which
   structure is very close to `ads.json`'s.

   Sample output:

   ```elixir
   %{
     "food-source" => %{
       "paths" => ["_ads/input/food-source/1.png",
        "_ads/input/food-source/2.png"],
       "store" => "Food Source"
     },
     # ...
   }

   From `ads.json`:

   ```json
   {
     "food-source": {
       "paths": {
         "1": "/images/ads/38847be3-c44e-4d63-82cb-3aabb822b537.png",
         "2": "/images/ads/ceb69f02-9362-4047-908b-ab5c87de9204.png"
       },
       "store": "Food Source"
     }
   }
   ```

4. `|> ANV.Articles.submit_ads()`

   Updates `ads.json` from step 3's output, and submits
   a channel  update to  the frontend. The  update only
   difference from `ads.json` in a "status" attribute:

   ```elixir
   %{
     "food-source" => %{
       "paths" => %{
         "1" => "/images/ads/38847be3-c44e-4d63-82cb-3aabb822b537.png",
         "2" => "/images/ads/ceb69f02-9362-4047-908b-ab5c87de9204.png"
       },
       "status" => "update", # or "new"
       "store" => "Food Source"
     },
     # ...
   }
   ```

### 2019-07-30_0824 Switch to JSON API or LiveView?

Trying the  following workflow to deal  with pushing
updates in the backend:

1.  `/ads`  routes  allow  updating ads  (image  uploads
    with  metadata),  loading   existing  sections  from
    `ads.json`.

2.  Backend "compresses" images  for quicker page loads,
    saves   files   to  `priv/static/images/`,   updates
    `ads.json`.

3.  Changed  and new  store sections  are pushed  to the
    front end to be updated.

As  a corollary,  the  initial  pageloads (main  and
`/ads`) could be generated  from `ads.json` in `eex`
templates, but as the data is already in a JSON, why
not just make a JSON API instead?

LiveView would also work, but I would like to retain
the flexibility to use another frontend framework in
the future. With that said, probably going to create
a git branch to try it out.

> NOTE
>
> When    going   with    the    JSON   API,    **CSRF
> protection  has  to  be  implemented  again  in  the
> frontend**. `Phoenix.HTML.Form`s  take care  of that
> automatically,  and  forms  in `/ads`  shouldn't  be
> public (or the API itself). LiveView and traditional
> `eex` templates  have the benefit of  taking care of
> this in the background.

*To make things simple, administration is done from
backend for  now, and frontend will  be kept public,
until users management added.*

### 2019-07-21_1232

The notion is to reload when any content changes on the backend. Server Sent Events would have been more lightweight, but used Phoenix channels (i.e., websockets) as it would have to be set up anyway at one point.
The ads are currently images in `./assets/static/images` (and as a corollary, `./priv/static/images`), and a channel message ("load_ads") will be broadcasted manually to reload pages.

```elixir
%Phoenix.Socket{
  pubsub_server: ANV.PubSub,
  topic:  "ads:changed",
  joined: true
}
|> Phoenix.Channel.broadcast("load_ads", %{})
```

> TODO: Only reload sections where content has changed.
>
> At the moment, the  entire webpage is reloaded, even
> if only the Safeway ads have been updated.

> TODO: How to automate page reloading?
>
> Look  into Webpack,  it  is surely  able to  monitor
> changes in `./assets`.
>
> On the  other hand, it  would probably be  better to
> move  on to  serving these  from a  CDN in  the long
> haul.

> TODO: How  to query  the ETS  table where  the channel
>       subscriptions are stored?
>
> Got it easy here, because only needed to send a broadcast, where the socket can be constructed above by hand (shouldn't even need a socket), instead of needing to save specific socket after join.
>
> The way to do the latter would be:
>
> ```elixir
> def join("ads:changed", payload, socket) do
>
>   send(self, :after_join)
>
>   {:ok, socket}
> end
>
> def handle_info(:after_join, socket) do
>
>   # Do whatever with `socket`, which will have
>   # `joined: true` at this point.
>
>   {:noreply, socket}
> end
> ```

#### `Phoenix.Channel.(broadcast/3|push/3)`

Broadcasts only  need `:pubsub_server`  and `:topic`
from  the `Phoenix.Socket`  struct, and  pushes need
`:transport_pid`  and `:topic`.  The latter  answers
how are  sockets (clients?) identified.  (TODO: look
up the spec and dispel this confusion.)

A sample socket:

```elixir
%Phoenix.Socket{
  assigns: %{},
  channel: ANVWeb.ArticlesChannel,
  channel_pid: #PID<0.453.0>,
  endpoint: ANVWeb.Endpoint,
  handler: ANVWeb.UserSocket,
  id: nil,
  join_ref: "5",
  joined: false,
  private: %{log_handle_in: :debug, log_join: :info},
  pubsub_server: ANV.PubSub,
  ref: nil,
  serializer: Phoenix.Socket.V2.JSONSerializer,
  topic: "ads:changed",
  transport: :websocket,
  transport_pid: #PID<0.449.0>
}
```

`broadcast/3`  checks whether  `:joined` is  `true`;
seems superfluous, but it isn't (see [PR #3501](https://github.com/phoenixframework/phoenix/pull/3501)).

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

## 20190828_1438 `User`'s `source_id`

A  particular user  can  have multiple  `source_id`s
associated with  them. For example, a  volunteer may
be  in SLATE  (by being  a client),  hence having  a
SLATE ID,  and also  in resource development  DB (by
being a client), hence the `res_dev_id`.

It is also possible that  they will have no internal
ID.  For example,  they  are  subscribers who  never
received any services, or  even heard of Society For
The Blind.

## 20190828_1639  `Credential`

Had the same issue as the one described in this [SO question](https://stackoverflow.com/questions/45856232/code-duplication-in-elixir-and-ecto): entities that share the same core.

Initially,  I went  the  route of  having a  generic
`User` schema with a  `Roles` embed, but when trying
to add  the specific parts (volunteers,  admins, and
subscribers), I couldn't figure out a composition to
work with  Ecto efficiently, and it  started to feel
like OO (i.e.,  inherit a `User` expand  on it). For
example,  a `Subscriber`  would  also  have a  phone
number  in a  different table  (because querying  it
from the  FreeSWITCH appwith  Lua seemed  easier) so
the  generic  User part  would've  had  to be  saved
to  the  `users`  table,  and the  phone  number  to
another.  Could've  done`embedded_schema`, but  then
`Repo.insert/2` would've needed to be figured out.

Anyway,  I  was  overthinking it:  have  credentials
as   a  separate   logical  entity,   and  different
user  groups  will  refer  to  its  entries  1-to-1.
This  also   makes  it   easier  to   abstract  away
different  types  of  credentials  later.  That  is,
using  username and  password  right  now (could  be
`Credential.UsernameAndPassword`) and just add more.

Also,  bla bla  bla. Whatever  I come  up with  will
change in 5 seconds.

## 2019-08-31_0513 `null: false` on referencing rows

From the [PostgreSQL docs on constraints](https://www.postgresql.org/docs/current/ddl-constraints.html):

> If you  don’t want  referencing rows  to be  able to
> avoid satisfying the foreign key constraint, declare
> the referencing column(s) as NOT NULL.

In  other words,  one cannot  create a  `credential`
record  for  example,  if  there  is  no  associated
`user`, so no dangling pointers.
