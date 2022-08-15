defmodule Katty.Pagination do
  @moduledoc """
  The Pagination module.
  """

  import Ecto.Query, warn: false

  alias Katty.Repo

  @pagination [page_size: 10]
  @pagination_distance 5

  @doc """
  Paginate the list of records using Scrivener.

  ## Examples

  iex> paginate_records(%{})
  %{entries: [%Account{}], ...}
  """
  def paginate_records(query, params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    case do_paginate(query, params) do
      %Scrivener.Page{} = page ->
        {:ok,
         %{
           entries: page.entries,
           page_number: page.page_number,
           page_size: page.page_size,
           total_pages: page.total_pages,
           total_entries: page.total_entries,
           distance: @pagination_distance,
           sort_field: sort_field,
           sort_direction: sort_direction
         }}

      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  defp do_paginate(query, params) do
    # Because some records has the field account_id
    Repo.put_skip_account_id(true)

    records =
      query
      |> order_by(^sort(params))
      |> paginate(Repo, params, @pagination)

    # Because some records has the field account_id
    Repo.put_skip_account_id(false)

    records
  end

  # Determines how the query for an index action should be sorted.
  #
  # Relies on the `"sort_field"` and `"sort_direction"` parameters to be passed.
  # By default, it sorts by `:id` in ascending order.
  #
  # ## Examples
  #
  #     iex> sort(%{"sort_field" => "name", "sort_direction" => "desc"})
  #     {:desc, :name}
  #
  #     iex> sort(%{})
  #     {:asc, :id}
  #
  # In a query pipeline, use in conjunction with `Ecto.Query.order_by/3`:
  #
  #     order_by(query, ^sort(params))
  #
  defp sort(%{"sort_field" => field, "sort_direction" => direction})
       when direction in ["asc", "desc"] do
    {String.to_atom(direction), String.to_existing_atom(field)}
  end

  defp sort(_other) do
    {:asc, :inserted_at}
  end

  # Paginates a given `Ecto.Queryable` using Scrivener.
  #
  # ## Parameters
  #
  # - `query`: An `Ecto.Queryable` to paginate.
  # - `repo`: Your Repo module.
  # - `params`: Parameters from your `conn`. For example `%{"page" => 1}`.
  # - `settings`: A list of settings for Scrivener, including `:page_size`.
  #
  # ## Examples
  #
  #     paginate(query, Repo, params, [page_size: 15])
  #     # => %Scrivener.Page{...}
  #
  defp paginate(query, repo, params, settings) do
    Scrivener.paginate(query, Scrivener.Config.new(repo, settings, params))
  end
end
