defmodule Blueprint.Components.Controls.Pill do
  @moduledoc """
  Universal pill chrome. Filter buttons, category / status labels,
  side pills — all share this. Interactive variant (cursor + hover)
  only applies to `<button>`; spans/tds get the chrome but no button
  affordance.

  Variants: `:default`, `:active`, `:muted`, `:warning`, `:critical`.
  """

  use Phoenix.Component

  attr(:variant, :atom,
    default: :default,
    values: [:default, :active, :muted, :warning, :critical]
  )

  attr(:as, :atom, default: :span, values: [:span, :button], doc: "wrapping element")
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include:
      ~w(type disabled title phx-click phx-throttle phx-value-page phx-value-id phx-value-sector phx-value-key)
  )

  slot(:inner_block, required: true)

  def pill(assigns) do
    ~H"""
    <.dynamic_tag
      tag_name={to_string(@as)}
      class={["bp-pill", variant_class(@variant), @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.dynamic_tag>
    """
  end

  defp variant_class(:default), do: nil
  defp variant_class(other), do: to_string(other)
end
