defmodule HomeDisplay.Scene.MainDisplay do
  use Scenic.Scene
  alias Scenic.Graph
  import Scenic.Primitives
  import Scenic.Components

  @target System.get_env("MIX_TARGET") || "host"


  @graph Graph.build()
    |> text("Hello World", font_size: 22, font: :roboto_mono, translate: {20, 80})
    |> button("Do Something", id: :btn_something, translate: {20, 180})

  def init(_scene_args, _options) do
    {:ok, @graph, push: @graph}
  end

  unless @target == "host" do
    # --------------------------------------------------------
    # Not a fan of this being polling. Would rather have InputEvent send me
    # an occasional event when something changes.
    def handle_info(:update_devices, graph) do
      Process.send_after(self(), :update_devices, 1000)

      devices =
        InputEvent.enumerate()
        |> Enum.reduce("", fn {_, device}, acc ->
          Enum.join([acc, inspect(device), "\r\n"])
        end)

      # update the graph
      graph = Graph.modify(graph, :devices, &text(&1, devices))

      {:noreply, graph, push: graph}
    end
  end
end
