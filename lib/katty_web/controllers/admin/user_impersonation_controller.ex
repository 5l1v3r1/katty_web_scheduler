defmodule KattyWeb.Admin.UserImpersonationController do
  use KattyWeb, :controller

  alias Katty.Users

  def create(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    token = Users.generate_user_session_token(user)

    conn
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
    |> put_flash(:info, "Impersonating user")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
