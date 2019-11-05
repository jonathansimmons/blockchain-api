defmodule BlockchainAPIWeb.WitnessController do
  use BlockchainAPIWeb, :controller

  alias BlockchainAPI.Util
  alias BlockchainAPIWeb.WitnessView

  action_fallback BlockchainAPIWeb.FallbackController

  def show(conn, %{"address"  => address} = _params) do
    conn
    |> put_view(WitnessView)
    |> render("show.json", witnesses: witnesses(address))
  end

  defp witnesses(address) do
    address
    |> Util.string_to_bin()
    |> get_witnesses()
  end

  defp get_witnesses(addr) do
    :blockchain_worker.blockchain()
    |> :blockchain.ledger()
    |> :blockchain_ledger_v1.active_gateways()
    |> Map.get(addr)
    |> :blockchain_ledger_gateway_v2.witnesses()
    |> Map.to_list()
    |> Enum.reduce(
      [],
      fn({addr, _witness}, acc) ->
        [BlockchainAPI.Schema.Hotspot.animal_name(addr) | acc]
      end)
  end
  defp get_witnesses(_), do: []
end
