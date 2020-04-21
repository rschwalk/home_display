defmodule HomeDisplay.Components.EventComponent do
  alias Scenic.Graph
  use Scenic.Component
  #import Scenic.Primitives, only: [{:text, 3}, {:update_opts, 2}]
  import Scenic.Primitives

  @graph Graph.build()
    |> rrect({350, 25, 6}, fill: :dark_orange, stroke: {3, :gold}, t: {0, -18})
    |> text("", id: :text, t: {10, 0})

  def info( data ), do: """
    #{IO.ANSI.red()}#{__MODULE__} data must be a bitstring
    #{IO.ANSI.yellow()}Received: #{inspect(data)}
    #{IO.ANSI.default_color()}
  """

  def verify( text ) when is_bitstring(text), do: {:ok, text}
  def verify( _ ), do: :invalid_data

  def init( text, opts ) do

      # modify the already built graph
    graph = @graph
            |> Graph.modify(:_root_, &update_opts(&1, styles: opts[:styles]) )
            |> Graph.modify(:text, &text(&1, text) )

    state = %{
      graph: graph,
      text: text
    }

    {:ok, state, push: graph}
  end
end
