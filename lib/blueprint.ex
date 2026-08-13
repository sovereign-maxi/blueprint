defmodule Blueprint do
  @moduledoc """
  Common design system for privacy infrastructure products.

  Provides shared LiveView function components and formatting helpers.
  Products import via `use Blueprint` or selectively import modules.

  ## Usage

  In your product's web module:

      defmodule MyAppWeb do
        def html_helpers do
          quote do
            use Blueprint
          end
        end
      end

  Then in templates:

      <.header logo_text="EXAMPLE" tagline="TAGLINE HERE" />
      <.panel title="BALANCE" meta="SATS">
        ...
      </.panel>
      <.footer pips={@footer_pips} commit_hash={@commit_hash} />
  """

  defmacro __using__(_opts) do
    quote do
      import Blueprint.Components
      import Blueprint.FormatHelpers
    end
  end
end
