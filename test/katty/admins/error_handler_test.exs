defmodule Katty.Admins.ErrorHandlerTest do
  use KattyWeb.ConnCase, async: true

  alias Katty.Admins.ErrorHandler

  test "returns http status 401 to the conn" do
    conn =
      build_conn()
      |> ErrorHandler.auth_error({"Unauthorized", nil}, [])

    assert conn.status == 401
    assert conn.resp_body =~ "Unauthorized"
  end
end
