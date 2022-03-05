# FactCheck

To start

```bash
git clone https://github.com/chungwong/fact_check.git
cd fact_check
mix deps.get
mix ecto.create
mix ecto.migrate
iex -S mix phx.server
```

## API endpoints

1. To get a random fact, http://localhost:4000/fact/random
2. To get a fact by its `known id`, http://localhost:4000/fact/id/10aa91eb-13eb-41e9-ac59-454604cc9a88
3. To get a stat on the endpoints, http://localhost:4000/fact/stat
