defmodule BlockchainAPI.HotspotNotifier do
  alias BlockchainAPI.{Schema.Hotspot, Util}

  def send_new_hotspot_notification(txn, type, ledger) do
    map = Hotspot.map(type, txn, ledger)
    data = %{
      hotspot_address: Util.bin_to_string(map.address),
      owner: Util.bin_to_string(map.owner),
      hash: Util.bin_to_string(txn.hash),
      type: "addHotspotSuccess"
    }
    animal_name = Hotspot.animal_name(map.address)
    message = "#{animal_name} has been added to the network!"
    Util.notifier_client().post(data, message, data.owner)
  end

  def send_add_hotspot_failed(:timed_out, pending_gateway) do
    data = %{
      hotspot_address: pending_gateway.gateway,
      owner: pending_gateway.owner,
      type: "addHotspotTimeOut"
    }
    message = "Unable to Add Hotspot. Transaction Timed Out."
    Util.notifier_client().post(data, message, data.owner)
  end

  def send_add_hotspot_failed(:already_exists, pending_gateway) do
    data = %{
      hotspot_address: pending_gateway.gateway,
      owner: pending_gateway.owner,
      type: "addHotspotAlreadyExists"
    }
    message = "Unable to Add Hotspot. Hotspot Already on Blockchain."
    Util.notifier_client().post(data, message, data.owner)
  end

  def send_confirm_location_failed(pending_location) do
    data = %{
      hotspot_address: pending_location.gateway,
      owner: pending_location.owner,
      type: "assertLocationFailure"
    }
    animal_name = Hotspot.animal_name(pending_location)
    message = "#{animal_name} Added Without Location Information."
    Util.notifier_client().post(data, message, data.owner)
  end
end
