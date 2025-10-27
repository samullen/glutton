import Config

config :wallaby,
  js_errors: false,
  driver: Wallaby.Chrome,
  hackney_options: [timeout: 5_000, recv_timeout: :infinity, pool: :wallaby_pool]
