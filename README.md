# Access News - Volunteers

## Project start instructions

If you have Nix installed or using NixOS:

1. Clone project and `cd` into it

2. `git clone https://github.com/NixOS/nixpkgs.git ~/clones/nixpkgs`

3. Issue `nix-shell`

4. Start  Phoenix endpoint with `mix  phx.server` or
   `iex -S mix phx.server`

Otherwise:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Logs

### 2019-08-05_0553 Committing `MIX_HOME` (i.e., `.nix-shell/.mix`)

Whenever  the Nix  script (in  `shell.nix`) executed
`mix  local.hex`, ca.  8 out  of 10  times it  would
consume  all memory,  the  system would  crawl to  a
halt, and there needed to be a hard reset. This only
seems  to  happen  when installing  Hex  (even  from
its  Github repo,  see  `shell.nix`).  Once Hex  was
up,  Phoenix  install  went smooth  (another  "local
global"), and Rebar as well (yet another).

#### The changes made to `shell.nix` as a corollary

1.  Only  stop  PostgreSQL  in the  cleanup  phase  (see
    `trap`),  and don't  delete the  entire `.nix-shell`
    directory.

2. Comment  out  the  `if`  section  to  check  whether
   `MIX_HOME`  exists  to   install  Hex  and  Phoenix,
   because it is in source control.

3. Move `mix deps.get` and `mix ecto.setup` in the main
   script  to be  always called,  because `./deps`  and
   `.nix-shell/db` is not in source control.

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

