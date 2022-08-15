defmodule KattyWeb.MemberLive.RoleFormComponent do
  @moduledoc """
  This component is used for setting role on a membership from a select list
  """
  use KattyWeb, :live_component

  alias Katty.Accounts

  @impl true
  def update(%{membership: membership} = assigns, socket) do
    changeset = Accounts.change_membership(membership)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"membership" => membership_params}, socket) do
    case Accounts.update_membership(socket.assigns.membership, membership_params) do
      {:ok, _member} ->
        {:noreply,
         socket
         |> put_flash(:info, "Member updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        let={f}
        for={@changeset}
        id="member-form-#{@membership.id}"
        phx-target={@myself}
        phx-change="save">
        <%= select f, :role, [:owner, :member], class: "select select-bordered" %>
      </.form>
    </div>
    """
  end
end