# Bootloader

Bootloader has been renamed to 
`Shoehorn`

https://github.com/nerves-project/shoehorn

# How to update

If your existing project already uses Bootloader, you will
need to change some references to switch over to shoehorn.

First, lets update the dependency. 

Change

```elixir
{:bootloader, "~> 0.1"}
```

to

```elixir
{:shoehorn, "~> 0.2"}
```

Next, lets update the distillery release config in `rel/config.exs`

Find the line near the end that has

```elixir
plugin Bootloader.Plugin
```
or 
```elixir
plugin Bootloader
```

and change it to
```elixir
plugin Shoehorn
```

Finally, In your `config/config.exs`

Change:
```elixir
config :bootloader,
  init: [:nerves_runtime],
  app: :my_app
```

to 
```elixir
config :shoehorn,
  init: [:nerves_runtime],
  app: :my_app
```
