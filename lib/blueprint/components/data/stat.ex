defmodule Blueprint.Components.Data.Stat do
  @moduledoc "Single stat row (`stat_row/1`) + DL list of stat rows (`stat_rows/1`)."

  use Phoenix.Component

  attr(:label, :string, required: true)
  attr(:value, :string, required: true)
  attr(:class, :string, default: nil)

  def stat_row(assigns) do
    ~H"""
    <div class="bp-stat-row">
      <span class="bp-stat-label">{@label}</span>
      <span class={"bp-stat-value #{@class}"}>{@value}</span>
    </div>
    """
  end

  attr(:rows, :list, required: true)

  def stat_rows(assigns) do
    ~H"""
    <dl class="bp-stat-list">
      <div :for={row <- @rows} class="bp-stat-row">
        <dt class="bp-stat-label">{row.label}</dt>
        <dd class={"bp-stat-value #{row[:class]}"}>{row.value}</dd>
      </div>
    </dl>
    """
  end
end
