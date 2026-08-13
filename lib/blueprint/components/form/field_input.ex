defmodule Blueprint.Components.Form.FieldInput do
  @moduledoc "Labeled input with optional trailing unit badge."

  use Phoenix.Component

  attr(:label, :string, required: true)
  attr(:badge, :string, default: nil)
  attr(:type, :string, default: "text")

  attr(:rest, :global,
    include:
      ~w(id name value placeholder min max autofocus readonly disabled required phx-keyup phx-debounce phx-change phx-target rows)
  )

  def field_input(assigns) do
    ~H"""
    <div class="bp-field">
      <label class="bp-field-label" for={@rest[:id]}>{@label}</label>
      <div class="bp-input-row">
        <input type={@type} class="bp-input" {@rest} />
        <div :if={@badge} class="bp-input-badge">{@badge}</div>
      </div>
    </div>
    """
  end
end
