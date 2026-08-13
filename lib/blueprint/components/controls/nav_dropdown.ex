defmodule Blueprint.Components.Controls.NavDropdown do
  @moduledoc """
  Page-switcher dropdown. Trigger + hidden menu toggled via
  `Phoenix.LiveView.JS.toggle/1` on the `hidden` attr — zero JS
  runtime cost.

  Takes `items: [{label, href}]`, the currently-active label, and an
  optional trigger id (defaults to `bp-nav-trigger`, but page-local
  ids let you host multiple dropdowns on one page).
  """

  use Phoenix.Component

  alias Phoenix.LiveView.JS

  import Blueprint.Components.SafeHref

  attr(:label, :string, required: true, doc: "trigger label — usually the current page name")
  attr(:items, :list, required: true, doc: "list of `{label, href}` tuples")
  attr(:trigger_id, :string, default: "bp-nav-trigger")
  attr(:menu_id, :string, default: "bp-nav-menu")
  attr(:class, :string, default: nil)

  def nav_dropdown(assigns) do
    ~H"""
    <div
      class={["bp-nav-dropdown", @class]}
      phx-click-away={
        JS.hide(to: "##{@menu_id}")
        |> JS.set_attribute({"aria-expanded", "false"}, to: "##{@trigger_id}")
      }
    >
      <button
        type="button"
        id={@trigger_id}
        class="bp-nav-dropdown-trigger"
        phx-click={
          JS.toggle(to: "##{@menu_id}")
          |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{@trigger_id}")
        }
        aria-haspopup="true"
        aria-expanded="false"
        aria-controls={@menu_id}
      >
        {@label}
      </button>
      <div id={@menu_id} class="bp-nav-dropdown-menu" role="menu" hidden>
        <a
          :for={{label, href} <- @items}
          href={safe_href(href)}
          class="bp-nav-dropdown-item"
          role="menuitem"
        >{label}</a>
      </div>
    </div>
    """
  end
end
