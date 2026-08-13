defmodule Blueprint.Components.Controls.Tabs do
  @moduledoc "Accessible tablist. Parent LiveView owns tab switching via `switch_tab` event."

  use Phoenix.Component

  attr(:tabs, :list, required: true)
  attr(:active, :atom, required: true)
  attr(:label, :string, default: "Views")

  def tabs(assigns) do
    ~H"""
    <div role="tablist" class="bp-tabs" aria-label={@label}>
      <button
        :for={tab <- @tabs}
        type="button"
        role="tab"
        id={"tab-#{tab.id}"}
        class={"bp-tab #{if tab.id == @active, do: "active"}"}
        aria-selected={to_string(tab.id == @active)}
        aria-controls={"tabpanel-#{tab.id}"}
        tabindex={if tab.id == @active, do: "0", else: "-1"}
        phx-click="switch_tab"
        phx-value-tab={tab.id}
      >{tab.label}</button>
    </div>
    """
  end
end
