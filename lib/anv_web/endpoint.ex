defmodule ANVWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :anv

  socket "/socket", ANVWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :anv,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  # if code_reloading? do
  #   socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
  #   plug Phoenix.LiveReloader
  #   plug Phoenix.CodeReloader
  # end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [
      :urlencoded,
      {:multipart, length: 100_000_000},
      :json
    ],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head


  # TODO Make this more secure as cookies are not encrypted
  #      by default (see generated note below). Also, 
  #      [Plug.Session.COOKIE](https://hexdocs.pm/plug/Plug.Session.COOKIE.html)
  #      documentation  mentions Plug.Crypto,  but that  plug
  #      doesn't  specify algo  (or  anything  else for  that
  #      matter). Maybe it should be  rolled by hand based on
  #      `comeonin`.

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_anv_key",
    signing_salt: "4YkQXI8Q"

  plug ANVWeb.Router
end
