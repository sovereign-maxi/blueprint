defmodule Blueprint.Components.Layout.SubNav do
  @moduledoc """
  Sub-nav strip: optional health bar (left), inner slot (dropdown +
  identity), stats (right). Rendered under the header on every page.
  """

  use Phoenix.Component

  attr(:stats, :list, required: true)
  attr(:health_bar, :map, default: nil)
  attr(:class, :string, default: nil)
  slot(:inner_block)

  def sub_nav(assigns) do
    ~H"""
    <nav class={["bp-sub-nav", @class]} aria-label="Status" aria-live="polite">
      <.health_bar :if={@health_bar} {Map.take(@health_bar, [:fill_pct, :title])} />
      {render_slot(@inner_block)}
      <span :for={stat <- @stats} class={["bp-nav-stat", stat[:wrapper_class]]}>
        {stat.label} <span class={stat[:class]}>{stat.value}</span>
      </span>
    </nav>
    """
  end

  attr(:fill_pct, :integer, default: 0)
  attr(:title, :string, default: "")

  def health_bar(assigns) do
    filled = round(assigns.fill_pct / 10)
    assigns = assign(assigns, :filled, filled)

    ~H"""
    <div
      class="bp-health-bar"
      title={@title}
      role="meter"
      aria-label={@title}
      aria-valuemin="0"
      aria-valuemax="100"
      aria-valuenow={@fill_pct}
    >
      <div :for={i <- 1..10} class={"bp-health-seg #{if i <= @filled, do: "filled"}"} aria-hidden="true"></div>
    </div>
    """
  end
end
