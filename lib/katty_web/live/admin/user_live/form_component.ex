defmodule KattyWeb.Admin.UserLive.FormComponent do
  @moduledoc """
  The admin users form component
  """
  use KattyWeb, :live_component

  alias Katty.Users

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Users.change_user_registration(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    user_params = Map.merge(user_params, autogenereated_password())

    changeset =
      socket.assigns.user
      |> Users.change_user_registration(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    user_params = Map.merge(user_params, autogenereated_password())

    case Users.register_user(user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp autogenereated_password() do
    password = :crypto.strong_rand_bytes(10) |> Base.encode64()
    %{"password" => password, "password_confirmation" => password}
  end
end
