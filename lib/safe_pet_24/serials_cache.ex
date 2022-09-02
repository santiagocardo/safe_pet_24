defmodule SafePet24.SerialsCache do
  use GenServer

  @fetch_interval :timer.seconds(60 * 60)

  def get(name \\ __MODULE__) do
    GenServer.call(name, :get_serials)
  end

  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  def init(opts) do
    state = %{
      interval: opts[:fetch_interval] || @fetch_interval,
      timer: nil,
      serials: []
    }

    {:ok, schedule_fetch(state)}
  end

  def handle_call(:get_serials, _from, state) do
    {:reply, state.serials, state}
  end

  def handle_info(:fetch_serials, state) do
    {:ok, {_response, _response_headers, body}} =
      :httpc.request("https://drive.google.com/uc?id=15RGVqoudh-AP_bcUDCddBblecxU_6vnA")

    serials = to_string(body) |> String.replace("\n", "") |> String.split(",", trim: true)

    {:noreply, schedule_fetch(%{state | serials: serials})}
  end

  defp schedule_fetch(state) do
    %{state | timer: Process.send_after(self(), :fetch_serials, state.interval)}
  end
end
