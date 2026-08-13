defmodule Blueprint.Components.Form.FieldTextarea do
  @moduledoc "Labeled textarea with optional error + hint."

  use Phoenix.Component

  attr(:label, :string, required: true)
  attr(:content, :string, default: "")
  attr(:error, :string, default: nil)
  attr(:hint, :string, default: nil)

  attr(:rest, :global,
    include:
      ~w(id name value placeholder readonly disabled required rows phx-hook phx-change phx-target)
  )

  def field_textarea(assigns) do
    ~H"""
    <div class="bp-field">
      <label class="bp-field-label" for={@rest[:id]}>{@label}</label>
      <div :if={@error} class="bp-field-error">{@error}</div>
      <div class="bp-input-row">
        <textarea class={"bp-input bp-textarea #{if @error, do: "bp-input-error"}"} {@rest}>{@content}</textarea>
      </div>
      <div :if={@hint} class="bp-field-hint">{@hint}</div>
    </div>
    """
  end
end
