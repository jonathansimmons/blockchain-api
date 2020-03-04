defmodule BlockchainAPI.Query.StateChannelOpenTxn do
  @moduledoc false
  import Ecto.Query, warn: false

  alias BlockchainAPI.{Repo, Schema.StateChannelOpenTxn}

  def create(attrs \\ %{}) do
    %StateChannelOpenTxn{}
    |> StateChannelOpenTxn.changeset(attrs)
    |> Repo.insert()
  end
end