defmodule Blueprint.Components.Containers.Panel do
  @moduledoc """
  Card container with title bar + optional LIVE badge or meta text +
  header-action slot. Companion helpers: `panel_body/1` (padded inner
  container) and `panel_scroll/1` (scrolling flex column).
  """

  use Phoenix.Component

  attr(:title, :string, required: true)

  attr(:title_id, :string,
    default: nil,
    doc: "id on the h2 — enables aria-labelledby wiring from modals"
  )

  attr(:meta, :string, default: nil)
  attr(:live_badge, :boolean, default: false)
  attr(:class, :string, default: "")
  slot(:inner_block, required: true)
  slot(:header_action, doc: "Optional slot for action links in the panel header")

  def panel(assigns) do
    ~H"""
    <div class={"bp-box #{@class}"}>
      <div class="bp-panel-header">
        <h2 id={@title_id} class="bp-panel-title">{@title}</h2>
        <span :if={@live_badge} class="bp-badge-live"><span class="bp-pulse-dot"></span> LIVE</span>
        <span :if={@meta && !@live_badge} class="bp-panel-meta">{@meta}</span>
        {render_slot(@header_action)}
      </div>
      {render_slot(@inner_block)}
    </div>
    """
  end

  slot(:inner_block, required: true)

  def panel_body(assigns) do
    ~H"""
    <div class="bp-panel-body">
      {render_slot(@inner_block)}
    </div>
    """
  end

  slot(:inner_block, required: true)

  def panel_scroll(assigns) do
    ~H"""
    <div class="bp-panel-scroll">
      {render_slot(@inner_block)}
    </div>
    """
  end
end
