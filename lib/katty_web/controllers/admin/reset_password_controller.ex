defmodule KattyWeb.Admin.ResetPasswordController do
  use KattyWeb, :controller

  alias Katty.{Admins, Admins.AdminNotifier, Mailer, Admins.Guardian}

  plug KattyWeb.Plugs.RedirectAdmin

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"admin" => %{"email" => email}}) do
    if admin = Admins.get_admin_by_email(email) do
      token = Phoenix.Token.sign(KattyWeb.Endpoint, "admin_auth", admin.id)
      url = Routes.admin_reset_password_url(conn, :show, token)

      AdminNotifier.admin_login_link(%{email: email, url: url})
      |> Mailer.deliver()
    end

    conn
    |> put_flash(
      :info,
      "If your email is in our system, you will receive instructions to reset your password shortly."
    )
    |> redirect(to: Routes.admin_reset_password_path(conn, :new))
  end

  def show(conn, %{"token" => token}) do
    case Phoenix.Token.verify(KattyWeb.Endpoint, "admin_auth", token, max_age: 600) do
      {:ok, id} ->
        admin = Admins.get_admin!(id)

        conn
        |> put_flash(:info, "Welcome back!")
        |> Guardian.Plug.sign_in(admin)
        |> redirect(to: Routes.admin_dashboard_index_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "The link you clicked is no longer valid")
        |> redirect(to: Routes.admin_reset_password_path(conn, :new))
    end
  end
end
