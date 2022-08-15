defmodule KattyWeb.Plugs.RedirectAdmin do
  @moduledoc """
  This plug ensures a logged in admin cant access the admin login page
  """
  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn, only: [halt: 1]

  alias KattyWeb.Router.Helpers, as: Routes
  alias Katty.Admins.Guardian

  def init(options), do: options

  def call(conn, _opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
      |> redirect(to: Routes.admin_dashboard_index_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
