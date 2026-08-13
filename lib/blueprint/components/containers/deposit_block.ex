defmodule Blueprint.Components.Containers.DepositBlock do
  @moduledoc """
  Deposit address block: lead paragraph, QR code, monospace address,
  and a copy button. Usually rendered inside a `<.modal>` but works
  standalone (e.g. inside a `<.panel>` for an inline "awaiting deposit"
  affordance).

  The `uri` attr overrides the QR payload — pass a `bitcoin:` or
  `monero:` URI so scanning wallets pre-fill amount / label; omit for
  bare-address QRs.
  """

  use Phoenix.Component

  attr(:address, :string, required: true)
  attr(:uri, :string, default: nil, doc: "QR payload — defaults to bare address")
  attr(:copy_button_id, :string, required: true)
  attr(:copy_label, :string, default: "Copy")
  attr(:copy_aria_label, :string, default: "Copy deposit address")
  attr(:show_copy, :boolean, default: true)
  slot(:lead, doc: "optional lead paragraph rendered above the QR")

  def deposit_block(assigns) do
    ~H"""
    {render_slot(@lead)}

    <div class="bp-modal-qr" aria-hidden="true">
      <div class="bp-modal-qr-inner">
        {qr_svg(@uri || @address)}
      </div>
    </div>

    <div :if={@show_copy} class="bp-copy-block">
      <code class="bp-secret-block">{@address}</code>
      <button
        type="button"
        id={@copy_button_id}
        class="bp-btn bp-btn-default bp-copy-btn"
        phx-hook="CopyOnClick"
        data-copy-text={@address}
        aria-label={@copy_aria_label}
      >
        {@copy_label}
      </button>
    </div>

    <code :if={not @show_copy} class="bp-secret-block">{@address}</code>
    """
  end

  # The payload is encoded into QR module PATHS — the text never appears
  # as text inside the SVG, so raw-rendering the generator output is
  # injection-safe. Keep it that way: never build SVG by interpolating
  # the payload into a string template. Oversized payloads (QR capacity
  # ~2KB) raise inside EQRCode — degrade to a text marker rather than
  # crashing the page render.
  defp qr_svg(text) when is_binary(text) do
    text
    |> EQRCode.encode()
    |> EQRCode.svg(width: 220, viewbox: true)
    |> Phoenix.HTML.raw()
  rescue
    _ -> "QR UNAVAILABLE"
  end
end
