defmodule KattyWeb.LiveHelpers do
  @moduledoc """
  A collection of helpers
  """
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.team_index_path(@socket, :index)}>
        <.live_component
          module={KattyWeb.TeamLive.FormComponent}
          id={@team.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.team_index_path(@socket, :index)}
          team: @team
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div class="fixed top-0 left-0 z-50 w-full h-screen outline-none" id="modal" role="dialog"
      data-init-modal={open_modal()} phx-remove={close_modal()}>
      <div class="absolute inset-0 z-40 bg-gray-900 opacity-75"></div>
      <div class="w-full h-full overflow-x-scroll">
        <div
          phx-click-away={JS.dispatch("click", to: "#close")}
          phx-window-keydown={JS.dispatch("click", to: "#close")}
          phx-key="escape"
          id="modal-content"
          class="relative z-50 w-auto max-w-lg px-4 mx-auto my-8 shadow-lg poiner-events-none sm:px-0 fade-in-scale">
          <div class="relative flex flex-col w-full border rounded-lg pointer-events-auto text-base-content bg-base-100 border-base-200">
            <div class="flex items-start justify-between p-4 border-b rounded-t border-base-200">
              <h5 class="mb-0 text-lg leading-normal"><%= if assigns[:modal_title], do: render_slot @modal_title %></h5>
              <%= if @return_to do %>
                <%= live_patch "✖",
                  to: @return_to,
                  id: "close",
                  class: "btn btn-link btn-sm",
                  phx_click: close_modal()
                %>
              <% else %>
                <a id="close" href="#" class="btn btn-link btn-sm" phx-click={close_modal()}>✖</a>
              <% end %>
            </div>
            <div class="relative flex-auto p-4 ">
              <%= render_slot(@inner_block, assigns) %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp open_modal(js \\ %JS{}) do
    js
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.transition("fade-in", to: "#modal")
    |> JS.transition("modal-content-in", to: "#modal-content")
  end

  defp close_modal(js \\ %JS{}) do
    js
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
