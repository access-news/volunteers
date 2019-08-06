defmodule ANVWeb.Auth.AssignCurrentUser do

  import Plug.Conn

  # No need to check whether user is admin or volunteer,
  # because  if there  is  a user  in  the session  then
  # `Accounts.get_user/1` will retrieve  it wrapped in a
  # struct (i.e., either  an `ANV.Accounts.Volunteer` or
  # an `ANV.Accounts.Admin` one).

  def init(opts), do: opts

  # TODO Clever and short, but make it explicit.
  def call(conn, _opts) do

    # Is there a user ID present in the session?
    user_id = get_session(conn, :user_id)

    # Does the present user  ID have a corresponding entry
    # in the backend?
    user = user_id && ANV.Accounts.get_user(user_id)

    assign(conn, :current_user, user)
  end
end
