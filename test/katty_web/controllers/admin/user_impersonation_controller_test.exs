defmodule KattyWeb.Admin.UserImpersonationControllerTest do
  use KattyWeb.ConnCase, async: true

  import Katty.UsersFixtures

  setup :register_and_log_in_admin

  describe "user impersonation" do
    test "sets current_user and redirects", %{conn: conn} do
      user = user_fixture()

      conn =
        post(conn, Routes.admin_user_impersonation_path(conn, :create, user.id), %{})

      assert redirected_to(conn) == Routes.page_path(conn, :index)

      conn = get(conn,  Routes.admin_dashboard_index_path(conn, :index))
      assert html_response(conn, 200) =~ "Impersonating"
    end
  end
end
