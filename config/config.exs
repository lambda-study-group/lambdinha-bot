use Mix.Config

config :app,
  bot_name: "lambdinha_bot"

config :nadia,
  token: "eh segredo"

import_config "#{Mix.env}.exs"
