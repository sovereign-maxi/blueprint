defmodule Blueprint.Components.Layout.Header do
  @moduledoc "Sticky top bar: wordmark + tagline + optional badge + nav slot."

  use Phoenix.Component

  import Blueprint.Components.SafeHref

  attr(:logo_text, :string, required: true)
  attr(:logo_href, :string, default: "/")
  attr(:tagline, :string, required: true)
  attr(:badge, :string, default: nil)
  slot(:nav)

  def header(assigns) do
    ~H"""
    <header class="bp-main-header">
      <div class="bp-header-container">
        <div class="bp-header-left">
          <a href={safe_href(@logo_href)} class="bp-terminal-header">{@logo_text}</a>
          <span class="bp-tagline">{@tagline}</span>
        </div>
        {render_slot(@nav)}
        <span :if={@nav == [] && @badge} class="bp-header-spacer"></span>
        <span :if={@badge} class="bp-badge">{@badge}</span>
      </div>
    </header>
    """
  end
end
