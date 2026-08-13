defmodule Blueprint.Components.Controls.FilterRow do
  @moduledoc """
  Filter bar: left group of pill buttons + optional right group
  (usually a `.bp-filter-select`). Renders the outer chrome; caller
  fills the slots.
  """

  use Phoenix.Component

  slot(:left, required: true, doc: "pill group on the left (usually category filters)")
  slot(:right, doc: "optional right group (usually a status <select>)")

  def filter_row(assigns) do
    ~H"""
    <div class="bp-filter-row">
      {render_slot(@left)}
      <div :if={@right != []} class="bp-filter-group bp-filter-group-right">
        {render_slot(@right)}
      </div>
    </div>
    """
  end
end
