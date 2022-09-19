defmodule SafePet24.UnconfirmedAccounts do
  use GenServer

  alias SafePet24.Accounts

  @interval :timer.seconds(60 * 30)

  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  def init(opts) do
    state = %{
      interval: opts[:interval] || @interval,
      timer: nil
    }

    {:ok, schedule(state)}
  end

  def handle_info(:delete_unconfirmed_users, state) do
    Accounts.get_unconfirmed_users()
    |> Enum.filter(&timedout?/1)
    |> Enum.each(&Accounts.delete_user/1)

    {:noreply, schedule(state)}
  end

  defp schedule(state) do
    %{state | timer: Process.send_after(self(), :delete_unconfirmed_users, state.interval)}
  end

  defp timedout?(user) do
    two_hours_after =
      user.inserted_at
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.add(60 * 60 * 2, :second)

    DateTime.compare(DateTime.utc_now(), two_hours_after) == :gt
  end
end
