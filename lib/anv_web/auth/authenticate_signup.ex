defmodule ANVWeb.Auth.AuthenticateSignup do

  import Plug.Conn

  def init(opts), do: opts

  # TODO:
  # 1. extract token from query string and check for validity
  # 2. if not valid or none present, redirect to main page with warning

  def call(conn, _opts) do

#     # Is there a user ID present in the session?
#     user_id = get_session(conn, :user_id)

#     # Does the present user  ID have a corresponding entry
#     # in the backend?
#     user = user_id && ANV.Accounts.get_user(user_id)

#     assign(conn, :current_user, user)
  end
end
