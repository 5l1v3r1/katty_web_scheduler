defmodule KattyWeb.Live.Admin.LiveHelpers do
  @moduledoc """
  A collection of helpers and components for the admin live pages
  """
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  def pagination_assigns(socket) do
    assigns =
      socket.assigns
      |> Map.take([:distance, :page_number, :page_size, :total_entries, :total_pages])
      |> assigns_to_attributes()

    assign(socket, :pagination_assigns, assigns)
  end

  def human_date(datetime), do: human_date(datetime, "%x")
  def human_date(nil, _), do: nil
  def human_date(datetime, format), do: Calendar.strftime datetime, format

  def admin_page_heading(assigns) do
    ~H"""
    <div class="mb-8">
      <h1 class="font-sans text-3xl text-base-content text-opacity-80 leading-10 md:text-3xl">
        <%= @title %>
      </h1>

      <div class="flex items-center justify-between">
        <nav class="mt-4 text-sm breadcrumbs">
          <ul>
            <%= for link <- @link do %>
            <li>
              <%= render_slot(link) %>
            </li>
            <% end %>
          </ul>
        </nav>
        <div>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  def admin_card(assigns) do
    ~H"""
    <div class="border shadow-lg card bg-base-100 border-base-300">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def admin_modal(assigns) do
    ~H"""
    """
  end
end
