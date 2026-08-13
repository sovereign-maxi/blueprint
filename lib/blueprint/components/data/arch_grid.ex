defmodule Blueprint.Components.Data.ArchGrid do
  @moduledoc "Two-column key/value grid rendered as `<dl>`."

  use Phoenix.Component

  attr(:items, :list, required: true)

  def arch_grid(assigns) do
    ~H"""
    <dl class="bp-arch-grid">
      <div :for={item <- @items} class="bp-arch-item">
        <dt class="bp-arch-label">{item.label}</dt>
        <dd class="bp-arch-value">{item.value}</dd>
      </div>
    </dl>
    """
  end
end
