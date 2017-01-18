defmodule Bootloader.ApplicationController do
  use GenServer

  alias Bootloader.Utils

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def hash() do
    GenServer.call(__MODULE__, :hash)
  end

  def init(opts) do
    app = opts[:app]
    init =  opts[:init] || []
    overlay_path = opts[:overlay_path]
    handler = opts[:handler] || Bootloader.Handler

    s = %{
      init: init,
      app: app,
      overlay_path: overlay_path,
      handler: handler,
      handler_state: handler.init()
    }

    send(self(), :init)

    {:ok, s}
  end

  def handle_call(hash, _from, s) do
    hash =
      ([s.app] ++ s.init)
      |> Enum.map(&Bootloader.Application.load/1)
      |> Enum.uniq
      |> Enum.map(& &1.hash)
      |> Enum.join
      |> Utils.hash
    {:reply, hash, s}
  end

  # Bootloader Application Init Phase
  def handle_info(:init, s) do
    IO.puts "Start Init Apps: #{inspect s.init}"
    for app <- s.init do
      Application.ensure_all_started(app)
    end
    send(self(), :app)
    {:noreply, s}
  end

  # Bootloader Application Start Phase
  def handle_info(:app, s) do
    Application.ensure_all_started(s.app)
    {:noreply, s}
  end

end