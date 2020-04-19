use Mix.Config

config :home_display, :viewport, %{
  name: :main_viewport,
  # default_scene: {HomeDisplay.Scene.Crosshair, nil},
  default_scene: {HomeDisplay.Scene.MainDisplay, nil},
  size: {800, 480},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      opts: [title: "MIX_TARGET=host, app = :home_display"]
    }
  ]
}
