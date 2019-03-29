# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Demo.Repo.insert!(%Demo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Demo.Emails.Email
Demo.Repo.insert!(%Email{from: "Sarah", subject: "Check out this new Elixir course"})
Demo.Repo.insert!(%Email{from: "John", subject: "re: LiveView is awesome"})
Demo.Repo.insert!(%Email{from: "Peter", subject: "Phoenix reaches 10 millions downloads on hex.pm"})
Demo.Repo.insert!(%Email{from: "Maria", subject: "CFP for ElixirConf closes in a few hours"})
