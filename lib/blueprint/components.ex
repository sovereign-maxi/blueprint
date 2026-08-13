defmodule Blueprint.Components do
  @moduledoc """
  Aggregator for the Blueprint design system's function components.

  Consumers do:

      use Blueprint.Components

  and every `<.panel>`, `<.header>`, `<.paginator>`, `<.pill>` etc.
  becomes callable. Individual components live under
  `lib/blueprint/components/{layout,containers,data,controls,form}/`
  — this module just imports them all so products get a single line
  of setup.

  To pull in one component and skip the rest, import the per-file
  module directly (e.g. `import Blueprint.Components.Data.Paginator`).
  """

  defmacro __using__(_opts) do
    quote do
      # Layout
      import Blueprint.Components.Layout.Announcements
      import Blueprint.Components.Layout.Footer
      import Blueprint.Components.Layout.Grid
      import Blueprint.Components.Layout.Header
      import Blueprint.Components.Layout.PageShell
      import Blueprint.Components.Layout.SubNav

      # Containers
      import Blueprint.Components.Containers.DepositBlock
      import Blueprint.Components.Containers.Modal
      import Blueprint.Components.Containers.Panel

      # Data
      import Blueprint.Components.Data.ArchGrid
      import Blueprint.Components.Data.DataTablePanel
      import Blueprint.Components.Data.EmptyState
      import Blueprint.Components.Data.Paginator
      import Blueprint.Components.Data.Stat
      import Blueprint.Components.Data.TableEmptyState

      # Controls
      import Blueprint.Components.Controls.Btn
      import Blueprint.Components.Controls.FilterRow
      import Blueprint.Components.Controls.NavDropdown
      import Blueprint.Components.Controls.Pill
      import Blueprint.Components.Controls.Tabs

      # Form
      import Blueprint.Components.Form.FieldInput
      import Blueprint.Components.Form.FieldTextarea
    end
  end
end
