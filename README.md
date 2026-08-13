# Blueprint

Common design system.

Provides shared CSS, LiveView function components, and formatting helpers. Products set their accent colour via CSS custom properties and add product-specific styles on top.

Source: [github.com/sovereign-maxi/blueprint](https://github.com/sovereign-maxi/blueprint)

## Installation

Add to your `mix.exs`:

```elixir
{:blueprint, path: "../blueprint"}
```

### Web Module

Import components in your web module's `html_helpers`:

```elixir
defp html_helpers do
  quote do
    import Blueprint.Components
    # import Blueprint.FormatHelpers  # optional, if no local conflicts
  end
end
```

### Static Assets

Blueprint ships CSS and fonts in `priv/static/`. Serve them directly from the dependency by adding a `Plug.Static` to your endpoint — no file copying needed:

```elixir
# In your endpoint.ex, after the product's own Plug.Static:

plug Plug.Static,
  at: "/",
  from: {:blueprint, "priv/static"},
  gzip: false,
  only: ~w(assets fonts)
```

This serves `/assets/blueprint.css` and `/fonts/JetBrainsMono-*.woff2` directly from the blueprint package.

### Product CSS

Your product's `app.css` imports blueprint and overrides the accent:

```css
@import url('/assets/blueprint.css');

:root {
  --bp-accent:       #10b981;
  --bp-accent-hover: #34d399;
  --bp-accent-dim:   rgba(16, 185, 129, 0.12);
}

/* Product-specific styles below */
```

## Components

```heex
<.header logo_text="EXAMPLE" tagline="TAGLINE HERE" badge="BETA" />

<.sub_nav stats={[
  %{label: "BALANCE", value: "0 SATS", class: "accent"},
  %{label: "FEDERATION", value: "2-OF-3", class: "profit", right: true}
]} />

<.grid cols="3-2">
  <.panel title="BALANCE" meta="SATS">
    ...
  </.panel>
  <.panel title="ACTIONS">
    ...
  </.panel>
</.grid>

<.stat_row label="TOTAL SWAPS" value="2,847" class="accent" />

<.field_input label="AMOUNT" badge="SATS" type="number" placeholder="12500" />

<.btn variant="primary">INITIATE SWAP</.btn>

<.tabs tabs={[%{id: :deposit, label: "Deposit"}, %{id: :withdraw, label: "Withdraw"}]} active={:deposit} />

<.empty_state message="NO ACTIVITY YET" />

<.footer pips={[
  %{label: "FEDERATION", status: :ok},
  %{label: "TOR", status: :ok},
  %{label: "LIGHTNING", status: :degraded}
]} commit_hash="a3169a6" />
```

## Format Helpers

```elixir
import Blueprint.FormatHelpers

format_sats(250_000)          # "250,000"
format_number(2847)           # "2,847"
format_duration(840_000)      # "14 min"
format_pct(0.9997)            # "99.97%"
format_time(~U[2026-03-24 04:21:00Z])  # "04:21"
relative_time(dt, now)        # "5m ago"
commit_hash()                 # "a3169a6"
```

## Component Naming Convention

Product-specific components follow a `{domain}_{type}` naming pattern:

| Suffix | Purpose | Example |
|--------|---------|---------|
| `_card` | Read-only data display | `balance_card`, `pool_card`, `stats_card` |
| `_panel` | Interactive — forms, buttons, actions | `swap_panel`, `deposit_panel`, `status_panel` |
| `_feed` | Live-updating streaming list | `activity_feed`, `completion_feed` |
| `_history` | Historical data table | `attestation_history` |

This convention applies to product-specific LiveComponents, not Blueprint's shared function components.

## License

MIT. See [LICENSE](LICENSE).
