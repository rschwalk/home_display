defmodule HomeDisplay.Scene.MainDisplay do
  use Scenic.Scene
  alias Scenic.Graph
  import Scenic.Primitives
  #import Scenic.Components

  alias HomeDisplay.Components.EventComponent

  @target System.get_env("MIX_TARGET") || "host"


  @graph Graph.build()
    |> text("Telefonkonferenzen", font_size: 22, font: :roboto_mono, translate: {20, 40})
    |> text("Montag", font_size: 22, font: :roboto_mono, translate: {20, 70})
    #|> rrect({350, 24, 6}, fill: :dark_orange, stroke: {3, :gold}, t: {20, 110 - 19})
    #|> text("14:00 Event long 1", id: :text, t: {30, 110})
    |> EventComponent.add_to_graph("12:00-12:30 Abst. CES und P", font_size: 20, translate: {30, 100})
    |> text("Dienstag", font_size: 22, font: :roboto_mono, translate: {20, 135})
    |> EventComponent.add_to_graph("09:00-10:00 M240 Teamrunde", font_size: 20, translate: {30, 165})
    |> EventComponent.add_to_graph("12:00-12:30 Possible HW/SW solution", font_size: 20, translate: {30, 195})
    |> EventComponent.add_to_graph("13:00-14:30 M240 All-Hands-Meeting", font_size: 20, translate: {30, 225})

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
