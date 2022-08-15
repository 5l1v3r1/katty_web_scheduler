defmodule KattyWeb.Live.UserAuth do
  @moduledoc """
  Assigns current_user on the liveview socket
  """

  import Phoenix.LiveView
  alias Katty.Users

  def on_mount(:default, _params, %{"user_token" => token} = session, socket) when is_binary(token) do
    case Users.get_user_by_session_token(token) do
      %{} = user ->
        account = get_current_account(user, session)

        {
          :cont,
          socket
          |> assign(:current_user, user)
          |> assign(:current_account, account)
        }
      _ ->
        {:halt, redirect(socket, to: "/sign_in")}
    end
  end

  def on_mount(:default, _params, _session, socket) do
    {:halt, redirect(socket, to: "/sign_in")}
  end

  defp get_current_account(user, _session) do
    case user do
      nil -> nil
      _ -> Users.with_personal_account(user).personal_account
    end
  end
end
