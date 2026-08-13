defmodule Blueprint.Components.Layout.PageShell do
  @moduledoc """
  The universal page chrome: header + sub-nav + `<main>` + footer.
  Every public product page wraps its content in one of these.

  The header, sub-nav and footer stay product-facing via slots — the
  caller supplies `logo_text`, `tagline`, the nav dropdown items,
  the stats list, and the health pips. That keeps product identity
  (wordmark, sector chips) local while the shell shape itself is
  shared.

  `page_variant` picks the inner content wrapper: `:wide` (full width),
  `:narrow` (centred 28rem — login / welcome), or `:fill` (viewport-
  fill for single-panel data pages).
  """

  use Phoenix.Component

  import Blueprint.Components.Layout.Header
  import Blueprint.Components.Layout.SubNav
  import Blueprint.Components.Layout.Footer

  attr(:logo_text, :string, required: true)
  attr(:logo_href, :string, default: "/")
  attr(:tagline, :string, required: true)
  attr(:page_variant, :atom, default: :wide, values: [:wide, :narrow, :fill])
  attr(:current_handle, :string, default: nil)
  attr(:stats, :list, default: [])
  attr(:health_bar, :map, default: nil)
  attr(:health, :map, required: true, doc: "pip list + commit_hash for the footer")

  slot(:header_nav, doc: "right-slot in the header (usually auth controls)")
  slot(:sub_nav_left, doc: "left-slot in the sub-nav (usually a page nav dropdown + handle)")
  slot(:inner_block, required: true)

  def page_shell(assigns) do
    ~H"""
    <.header logo_text={@logo_text} logo_href={@logo_href} tagline={@tagline}>
      <:nav>{render_slot(@header_nav)}</:nav>
    </.header>
    <.sub_nav stats={@stats} health_bar={@health_bar}>
      {render_slot(@sub_nav_left)}
    </.sub_nav>

    <main class="bp-root">
      <div class={page_wrapper_class(@page_variant)}>
        {render_slot(@inner_block)}
      </div>

      <.footer pips={@health.pips} commit_hash={@health[:commit_hash] || "dev"} />
    </main>
    """
  end

  defp page_wrapper_class(:wide), do: "bp-page-wide"
  defp page_wrapper_class(:fill), do: "bp-page-wide bp-page-fill"
  defp page_wrapper_class(:narrow), do: "bp-page bp-page-narrow"
end
