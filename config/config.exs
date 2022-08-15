# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :katty, :env, Mix.env()

config :katty,
  ecto_repos: [Katty.Repo],
  generators: [binary_id: true]

config :katty, Katty.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

config :katty,
  require_user_confirmation: true,
  app_name: "Katty",
  page_url: "madkatty.com",
  company_name: "Katty Inc",
  company_address: "26955 Fritsch Bridge",
  company_zip: "54933-7180",
  company_city: "San Fransisco",
  company_state: "California",
  company_country: "United States",
  contact_name: "Katty Mad",
  contact_phone: "+1 (335) 555-2036",
  contact_email: "admin@madkatty.com",
  from_email: "admin@madkatty.com"

# Configures the endpoint
config :katty, KattyWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: KattyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Katty.PubSub,
  live_view: [signing_salt: "jCKozy0C"]

# Configures the mailer
# This is just a free smtp server to deliver the email without the needs to install a smtp locally #
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :katty, Katty.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "smtp.freesmtpservers.com",
  username: "",
  password: "",
  ssl: :false,
  tls: :never,
  auth: :never,
  port: 25,
  retries: 4,
  no_mx_lookup: true

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.0.24",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing
config :phoenix, :json_library, Jason

config :katty, Katty.Users.Guardian,
  issuer: "katty",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY_ADMINS") || "9drmYJNS+QCmz8eCXaKxje1Q9lokp7N2VjR3Jch8Q2Ast88Imp+eodEaqHHXwc73"

config :katty, Katty.Admins.Guardian,
  issuer: "katty",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY_ADMINS") || "pE2rRcSUOih5EOee5J4ZOmuw0GzBJm0gfmxnreGub1DjM4qVfvWYNBi2pZ7+el9e"

config :katty, Oban,
  repo: Katty.Repo,
  queues: [default: 10, mailers: 20, high: 50, low: 5],
  plugins: [
    {Oban.Plugins.Pruner, max_age: (3600 * 24)},
    {Oban.Plugins.Cron,
      crontab: [
       # {"0 2 * * *", Katty.Workers.DailyDigestWorker},
       # {"@reboot", Katty.Workers.StripeSyncWorker}
     ]}
  ]

  config :recaptcha,
  public_key:  "changeit",
secret:  "changeit"

import_config "#{config_env()}.exs"
