defmodule KattyWeb.Plugs.RequireCurrentAdmin do
  @moduledoc """
  This plug is mounted for the admin pages and is responsible for making sure
  there is a current admin or redirect the user to the admin login page.
  """
  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn, only: [halt: 1]

  alias KattyWeb.Router.Helpers, as: Routes
  alias Katty.Admins.Admin

  def init(options), do: options

  def call(conn, _opts) do
    case conn.assigns[:current_admin] do
      %Admin{} ->
        conn
      _ ->
        conn
        |> redirect(to: Routes.admin_session_path(conn, :new))
        |> halt()
    end
  end
end
